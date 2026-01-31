import '../entities/app_settings.dart';

/// Settings repository interface
abstract class SettingsRepository {
  /// Get current settings
  Future<AppSettings> getSettings();

  /// Save settings
  Future<void> saveSettings(AppSettings settings);

  /// Reset settings to default
  Future<void> resetSettings();

  /// Update single setting
  Future<void> updateSetting(String key, dynamic value);

  /// Check if first launch
  Future<bool> isFirstLaunch();

  /// Mark first launch complete
  Future<void> markFirstLaunchComplete();
}
