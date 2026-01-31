import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_constants.dart';
import '../../data/datasources/local_storage_datasource.dart';
import '../../data/repositories/browser_repository_impl.dart';
import '../../data/repositories/file_repository_impl.dart';
import '../../data/repositories/ai_repository_impl.dart';
import '../../data/repositories/settings_repository_impl.dart';
import '../../domain/repositories/browser_repository.dart';
import '../../domain/repositories/file_repository.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../domain/repositories/settings_repository.dart';

/// Dio HTTP client provider
final dioProvider = Provider<Dio>((ref) {
  return Dio(
    BaseOptions(
      connectTimeout: Duration(seconds: ApiConstants.connectionTimeout),
      receiveTimeout: Duration(seconds: ApiConstants.receiveTimeout),
      headers: ApiConstants.defaultHeaders,
    ),
  );
});

/// Local storage datasource provider
final localStorageProvider = Provider<LocalStorageDatasource>((ref) {
  return LocalStorageDatasource.instance;
});

/// Browser repository provider
final browserRepositoryProvider = Provider<BrowserRepository>((ref) {
  final datasource = ref.watch(localStorageProvider);
  return BrowserRepositoryImpl(datasource);
});

/// File repository provider
final fileRepositoryProvider = Provider<FileRepository>((ref) {
  final datasource = ref.watch(localStorageProvider);
  final dio = ref.watch(dioProvider);
  return FileRepositoryImpl(datasource, dio);
});

/// AI repository provider
final aiRepositoryProvider = Provider<AIRepository>((ref) {
  final datasource = ref.watch(localStorageProvider);
  final dio = ref.watch(dioProvider);
  return AIRepositoryImpl(datasource, dio);
});

/// Settings repository provider
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  final datasource = ref.watch(localStorageProvider);
  return SettingsRepositoryImpl(datasource);
});
