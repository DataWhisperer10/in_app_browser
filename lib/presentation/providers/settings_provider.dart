import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/app_settings.dart';
import 'providers.dart';

/// Settings state notifier
class SettingsNotifier extends StateNotifier<AppSettings> {
  final Ref _ref;

  SettingsNotifier(this._ref) : super(const AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final repository = _ref.read(settingsRepositoryProvider);
      final settings = await repository.getSettings();
      state = settings;
    } catch (e) {
      // Use default settings if loading fails
      state = const AppSettings();
    }
  }

  Future<void> toggleDarkMode() async {
    final newSettings = state.copyWith(isDarkMode: !state.isDarkMode);
    await _saveSettings(newSettings);
  }

  Future<void> setSearchEngine(String searchEngine) async {
    final newSettings = state.copyWith(defaultSearchEngine: searchEngine);
    await _saveSettings(newSettings);
  }

  Future<void> setDefaultLanguage(String language) async {
    final newSettings = state.copyWith(defaultLanguage: language);
    await _saveSettings(newSettings);
  }

  Future<void> toggleSaveHistory() async {
    final newSettings = state.copyWith(saveHistory: !state.saveHistory);
    await _saveSettings(newSettings);
  }

  Future<void> toggleJavascript() async {
    final newSettings = state.copyWith(enableJavascript: !state.enableJavascript);
    await _saveSettings(newSettings);
  }

  Future<void> toggleBlockPopups() async {
    final newSettings = state.copyWith(blockPopups: !state.blockPopups);
    await _saveSettings(newSettings);
  }

  Future<void> setSummaryLength(int length) async {
    final newSettings = state.copyWith(summaryLength: length);
    await _saveSettings(newSettings);
  }

  Future<void> toggleAutoSummarize() async {
    final newSettings = state.copyWith(autoSummarize: !state.autoSummarize);
    await _saveSettings(newSettings);
  }

  Future<void> toggleOfflineMode() async {
    final newSettings = state.copyWith(enableOfflineMode: !state.enableOfflineMode);
    await _saveSettings(newSettings);
  }

  Future<void> setLastTabId(String? tabId) async {
    final newSettings = state.copyWith(lastTabId: tabId);
    await _saveSettings(newSettings);
  }

  Future<void> _saveSettings(AppSettings settings) async {
    state = settings;
    final repository = _ref.read(settingsRepositoryProvider);
    await repository.saveSettings(settings);
  }

  Future<void> resetSettings() async {
    final repository = _ref.read(settingsRepositoryProvider);
    await repository.resetSettings();
    state = const AppSettings();
  }
}

/// Settings provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier(ref);
});

/// Theme mode provider
final isDarkModeProvider = Provider<bool>((ref) {
  return ref.watch(settingsProvider).isDarkMode;
});
