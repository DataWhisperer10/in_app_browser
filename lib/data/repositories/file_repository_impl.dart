import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:uuid/uuid.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../../core/utils/file_utils.dart';
import '../../core/utils/url_utils.dart';
import '../../domain/entities/downloaded_file.dart';
import '../../domain/repositories/file_repository.dart';
import '../datasources/local_storage_datasource.dart';
import '../models/downloaded_file_model.dart';

/// File repository implementation
class FileRepositoryImpl implements FileRepository {
  final LocalStorageDatasource _datasource;
  final Dio _dio;
  final Uuid _uuid = const Uuid();

  FileRepositoryImpl(this._datasource, this._dio);

  @override
  Future<List<DownloadedFile>> getDownloadedFiles() async {
    final models = _datasource.getDownloads();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<DownloadedFile> downloadFile(String url, {String? customName}) async {
    final downloadsPath = await FileUtils.getDownloadsPath();
    final fileName = customName ?? UrlUtils.getFileNameFromUrl(url);
    final extension = UrlUtils.getFileExtension(url) ?? '';
    final filePath = '$downloadsPath/$fileName';
    final fileId = _uuid.v4();

    // Create initial file record
    var file = DownloadedFile(
      id: fileId,
      name: fileName,
      path: filePath,
      extension: extension,
      size: 0,
      sourceUrl: url,
      downloadedAt: DateTime.now(),
      status: DownloadStatus.downloading,
      progress: 0.0,
    );

    // Save initial state
    await saveDownloadedFile(file);

    try {
      // Download file
      final response = await _dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) async {
          if (total != -1) {
            final progress = received / total;
            await updateDownloadProgress(fileId, progress);
          }
        },
      );

      if (response.statusCode == 200) {
        final fileSize = await FileUtils.getFileSize(filePath);
        file = file.copyWith(
          size: fileSize,
          status: DownloadStatus.completed,
          progress: 1.0,
        );
        await saveDownloadedFile(file);
      } else {
        file = file.copyWith(
          status: DownloadStatus.failed,
          error: 'Download failed with status: ${response.statusCode}',
        );
        await saveDownloadedFile(file);
      }
    } catch (e) {
      file = file.copyWith(
        status: DownloadStatus.failed,
        error: e.toString(),
      );
      await saveDownloadedFile(file);
    }

    return file;
  }

  @override
  Future<void> saveDownloadedFile(DownloadedFile file) async {
    await _datasource.saveDownload(DownloadedFileModel.fromEntity(file));
  }

  @override
  Future<void> deleteDownloadedFile(String fileId) async {
    final model = _datasource.getDownloadById(fileId);
    if (model != null) {
      await FileUtils.deleteFile(model.path);
    }
    await _datasource.deleteDownload(fileId);
  }

  @override
  Future<void> updateDownloadProgress(String fileId, double progress) async {
    final model = _datasource.getDownloadById(fileId);
    if (model != null) {
      final updated = DownloadedFileModel(
        id: model.id,
        name: model.name,
        path: model.path,
        extension: model.extension,
        size: model.size,
        sourceUrl: model.sourceUrl,
        downloadedAt: model.downloadedAt,
        status: model.status,
        progress: progress,
        error: model.error,
      );
      await _datasource.saveDownload(updated);
    }
  }

  @override
  Future<DownloadedFile?> getFileById(String fileId) async {
    final model = _datasource.getDownloadById(fileId);
    return model?.toEntity();
  }

  @override
  Future<void> openFile(String filePath) async {
    await OpenFile.open(filePath);
  }

  @override
  Future<String?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'xls', 'xlsx'],
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files.first.path;
    }
    return null;
  }

  @override
  Future<String> extractTextFromDocument(String filePath) async {
    final extension = filePath.split('.').last.toLowerCase();

    if (extension == 'pdf') {
      return await _extractTextFromPdf(filePath);
    }

    // For other document types, return a placeholder
    // In production, use appropriate libraries for each format
    return 'Text extraction for .$extension files is coming soon. Please use PDF files for now.';
  }

  Future<String> _extractTextFromPdf(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      final document = PdfDocument(inputBytes: bytes);
      
      final StringBuffer textBuffer = StringBuffer();
      
      for (int i = 0; i < document.pages.count; i++) {
        final text = PdfTextExtractor(document).extractText(startPageIndex: i, endPageIndex: i);
        textBuffer.write(text);
        textBuffer.write('\n');
      }
      
      document.dispose();
      return textBuffer.toString();
    } catch (e) {
      return 'Failed to extract text from PDF: $e';
    }
  }

  @override
  Future<int> getStorageUsage() async {
    final files = _datasource.getDownloads();
    int totalSize = 0;
    for (final file in files) {
      if (await FileUtils.fileExists(file.path)) {
        totalSize += await FileUtils.getFileSize(file.path);
      }
    }
    return totalSize;
  }

  @override
  Future<void> clearDownloads() async {
    final files = _datasource.getDownloads();
    for (final file in files) {
      await FileUtils.deleteFile(file.path);
    }
    await _datasource.clearDownloads();
  }
}
