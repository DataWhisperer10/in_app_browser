import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/downloaded_file.dart';
import 'providers.dart';

/// File state
class FileState {
  final List<DownloadedFile> files;
  final bool isLoading;
  final String? error;
  final DownloadedFile? currentDownload;

  const FileState({
    this.files = const [],
    this.isLoading = false,
    this.error,
    this.currentDownload,
  });

  FileState copyWith({
    List<DownloadedFile>? files,
    bool? isLoading,
    String? error,
    DownloadedFile? currentDownload,
  }) {
    return FileState(
      files: files ?? this.files,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      currentDownload: currentDownload,
    );
  }
}

/// File state notifier
class FileNotifier extends StateNotifier<FileState> {
  final Ref _ref;

  FileNotifier(this._ref) : super(const FileState()) {
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    try {
      state = state.copyWith(isLoading: true);
      final repository = _ref.read(fileRepositoryProvider);
      final files = await repository.getDownloadedFiles();
      state = state.copyWith(files: files, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> downloadFile(String url, {String? customName}) async {
    try {
      state = state.copyWith(isLoading: true);
      final repository = _ref.read(fileRepositoryProvider);
      final file = await repository.downloadFile(url, customName: customName);
      
      final updatedFiles = [...state.files, file];
      state = state.copyWith(
        files: updatedFiles,
        isLoading: false,
        currentDownload: file,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> deleteFile(String fileId) async {
    try {
      final repository = _ref.read(fileRepositoryProvider);
      await repository.deleteDownloadedFile(fileId);
      
      final updatedFiles = state.files.where((f) => f.id != fileId).toList();
      state = state.copyWith(files: updatedFiles);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> openFile(String filePath) async {
    try {
      final repository = _ref.read(fileRepositoryProvider);
      await repository.openFile(filePath);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<String?> pickFile() async {
    try {
      final repository = _ref.read(fileRepositoryProvider);
      return await repository.pickFile();
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return null;
    }
  }

  Future<String> extractText(String filePath) async {
    try {
      final repository = _ref.read(fileRepositoryProvider);
      return await repository.extractTextFromDocument(filePath);
    } catch (e) {
      state = state.copyWith(error: e.toString());
      return '';
    }
  }

  Future<void> refreshFiles() async {
    await _loadFiles();
  }

  Future<void> clearAllDownloads() async {
    try {
      final repository = _ref.read(fileRepositoryProvider);
      await repository.clearDownloads();
      state = state.copyWith(files: []);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// File provider
final fileProvider = StateNotifierProvider<FileNotifier, FileState>((ref) {
  return FileNotifier(ref);
});

/// Storage usage provider
final storageUsageProvider = FutureProvider<int>((ref) async {
  final repository = ref.watch(fileRepositoryProvider);
  return repository.getStorageUsage();
});
