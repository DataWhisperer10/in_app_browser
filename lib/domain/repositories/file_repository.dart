import '../entities/downloaded_file.dart';

/// File repository interface
abstract class FileRepository {
  /// Get all downloaded files
  Future<List<DownloadedFile>> getDownloadedFiles();

  /// Download file from URL
  Future<DownloadedFile> downloadFile(String url, {String? customName});

  /// Save downloaded file metadata
  Future<void> saveDownloadedFile(DownloadedFile file);

  /// Delete downloaded file
  Future<void> deleteDownloadedFile(String fileId);

  /// Update download progress
  Future<void> updateDownloadProgress(String fileId, double progress);

  /// Get file by ID
  Future<DownloadedFile?> getFileById(String fileId);

  /// Open file
  Future<void> openFile(String filePath);

  /// Pick file from device
  Future<String?> pickFile();

  /// Extract text from document
  Future<String> extractTextFromDocument(String filePath);

  /// Get storage usage
  Future<int> getStorageUsage();

  /// Clear all downloads
  Future<void> clearDownloads();
}
