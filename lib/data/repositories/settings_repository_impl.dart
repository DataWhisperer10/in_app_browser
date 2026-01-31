import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/local_storage_datasource.dart';
import '../models/app_settings_model.dart';

/// Settings repository implementation
class SettingsRepositoryImpl implements SettingsRepository {
  final LocalStorageDatasource _datasource;

  SettingsRepositoryImpl(this._datasource);

  @override
  Future<AppSettings> getSettings() async {
    final model = _datasource.getSettings();
    return model.toEntity();
  }

  @override
  Future<void> saveSettings(AppSettings settings) async {
    await _datasource.saveSettings(AppSettingsModel.fromEntity(settings));
  }

  @override
  Future<void> resetSettings() async {
    await _datasource.saveSettings(AppSettingsModel());
  }

  @override
  Future<void> updateSetting(String key, dynamic value) async {
    final current = _datasource.getSettings();
    AppSettingsModel updated;

    switch (key) {
      case 'isDarkMode':
        updated = AppSettingsModel(
          isDarkMode: value as bool,
          defaultSearchEngine: current.defaultSearchEngine,
          defaultLanguage: current.defaultLanguage,
          saveHistory: current.saveHistory,
          enableJavascript: current.enableJavascript,
          blockPopups: current.blockPopups,
          summaryLength: current.summaryLength,
          autoSummarize: current.autoSummarize,
          enableOfflineMode: current.enableOfflineMode,
          lastTabId: current.lastTabId,
        );
        break;
      case 'defaultSearchEngine':
        updated = AppSettingsModel(
          isDarkMode: current.isDarkMode,
          defaultSearchEngine: value as String,
          defaultLanguage: current.defaultLanguage,
          saveHistory: current.saveHistory,
          enableJavascript: current.enableJavascript,
          blockPopups: current.blockPopups,
          summaryLength: current.summaryLength,
          autoSummarize: current.autoSummarize,
          enableOfflineMode: current.enableOfflineMode,
          lastTabId: current.lastTabId,
        );
        break;
      case 'defaultLanguage':
        updated = AppSettingsModel(
          isDarkMode: current.isDarkMode,
          defaultSearchEngine: current.defaultSearchEngine,
          defaultLanguage: value as String,
          saveHistory: current.saveHistory,
          enableJavascript: current.enableJavascript,
          blockPopups: current.blockPopups,
          summaryLength: current.summaryLength,
          autoSummarize: current.autoSummarize,
          enableOfflineMode: current.enableOfflineMode,
          lastTabId: current.lastTabId,
        );
        break;
      case 'saveHistory':
        updated = AppSettingsModel(
          isDarkMode: current.isDarkMode,
          defaultSearchEngine: current.defaultSearchEngine,
          defaultLanguage: current.defaultLanguage,
          saveHistory: value as bool,
          enableJavascript: current.enableJavascript,
          blockPopups: current.blockPopups,
          summaryLength: current.summaryLength,
          autoSummarize: current.autoSummarize,
          enableOfflineMode: current.enableOfflineMode,
          lastTabId: current.lastTabId,
        );
        break;
      case 'summaryLength':
        updated = AppSettingsModel(
          isDarkMode: current.isDarkMode,
          defaultSearchEngine: current.defaultSearchEngine,
          defaultLanguage: current.defaultLanguage,
          saveHistory: current.saveHistory,
          enableJavascript: current.enableJavascript,
          blockPopups: current.blockPopups,
          summaryLength: value as int,
          autoSummarize: current.autoSummarize,
          enableOfflineMode: current.enableOfflineMode,
          lastTabId: current.lastTabId,
        );
        break;
      case 'lastTabId':
        updated = AppSettingsModel(
          isDarkMode: current.isDarkMode,
          defaultSearchEngine: current.defaultSearchEngine,
          defaultLanguage: current.defaultLanguage,
          saveHistory: current.saveHistory,
          enableJavascript: current.enableJavascript,
          blockPopups: current.blockPopups,
          summaryLength: current.summaryLength,
          autoSummarize: current.autoSummarize,
          enableOfflineMode: current.enableOfflineMode,
          lastTabId: value as String?,
        );
        break;
      default:
        return;
    }

    await _datasource.saveSettings(updated);
  }

  @override
  Future<bool> isFirstLaunch() async {
    // Check if we have any tabs saved - if not, it's first launch
    final tabs = _datasource.getTabs();
    return tabs.isEmpty;
  }

  @override
  Future<void> markFirstLaunchComplete() async {
    // No action needed - having tabs saved indicates launch is complete
  }
}
