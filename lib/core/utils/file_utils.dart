import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../constants/app_constants.dart';

/// File utility functions
class FileUtils {
  FileUtils._();

  /// Get the downloads directory path
  static Future<String> getDownloadsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    final downloadsDir = Directory('${directory.path}/downloads');
    if (!await downloadsDir.exists()) {
      await downloadsDir.create(recursive: true);
    }
    return downloadsDir.path;
  }

  /// Get the cache directory path
  static Future<String> getCachePath() async {
    final directory = await getApplicationCacheDirectory();
    return directory.path;
  }

  /// Format file size to human readable
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Get file type icon name based on extension
  static String getFileTypeIcon(String extension) {
    switch (extension.toLowerCase()) {
      case '.pdf':
        return 'picture_as_pdf';
      case '.doc':
      case '.docx':
        return 'description';
      case '.xls':
      case '.xlsx':
        return 'table_chart';
      case '.ppt':
      case '.pptx':
        return 'slideshow';
      default:
        return 'insert_drive_file';
    }
  }

  /// Get MIME type from extension
  static String? getMimeType(String extension) {
    final ext = extension.replaceFirst('.', '').toLowerCase();
    return AppConstants.mimeTypes[ext];
  }

  /// Check if file extension is supported
  static bool isSupportedExtension(String extension) {
    return AppConstants.supportedDocumentExtensions.contains(
      extension.toLowerCase(),
    );
  }

  /// Delete file
  static Future<bool> deleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  /// Get file size
  static Future<int> getFileSize(String path) async {
    try {
      final file = File(path);
      return await file.length();
    } catch (e) {
      return 0;
    }
  }

  /// Check if file exists
  static Future<bool> fileExists(String path) async {
    try {
      return await File(path).exists();
    } catch (e) {
      return false;
    }
  }

  /// Clean old cache files
  static Future<void> cleanOldCache(int maxAgeDays) async {
    try {
      final cachePath = await getCachePath();
      final cacheDir = Directory(cachePath);
      final now = DateTime.now();
      
      await for (final entity in cacheDir.list()) {
        if (entity is File) {
          final stat = await entity.stat();
          final age = now.difference(stat.modified);
          if (age.inDays > maxAgeDays) {
            await entity.delete();
          }
        }
      }
    } catch (e) {
      // Ignore cache cleaning errors
    }
  }
}
