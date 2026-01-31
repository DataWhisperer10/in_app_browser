import 'package:hive/hive.dart';
import '../../domain/entities/app_settings.dart';

part 'app_settings_model.g.dart';

@HiveType(typeId: 5)
class AppSettingsModel extends HiveObject {
  @HiveField(0)
  final bool isDarkMode;

  @HiveField(1)
  final String defaultSearchEngine;

  @HiveField(2)
  final String defaultLanguage;

  @HiveField(3)
  final bool saveHistory;

  @HiveField(4)
  final bool enableJavascript;

  @HiveField(5)
  final bool blockPopups;

  @HiveField(6)
  final int summaryLength;

  @HiveField(7)
  final bool autoSummarize;

  @HiveField(8)
  final bool enableOfflineMode;

  @HiveField(9)
  final String? lastTabId;

  AppSettingsModel({
    this.isDarkMode = true,
    this.defaultSearchEngine = 'https://www.google.com/search?q=',
    this.defaultLanguage = 'en',
    this.saveHistory = true,
    this.enableJavascript = true,
    this.blockPopups = true,
    this.summaryLength = 150,
    this.autoSummarize = false,
    this.enableOfflineMode = true,
    this.lastTabId,
  });

  factory AppSettingsModel.fromEntity(AppSettings settings) {
    return AppSettingsModel(
      isDarkMode: settings.isDarkMode,
      defaultSearchEngine: settings.defaultSearchEngine,
      defaultLanguage: settings.defaultLanguage,
      saveHistory: settings.saveHistory,
      enableJavascript: settings.enableJavascript,
      blockPopups: settings.blockPopups,
      summaryLength: settings.summaryLength,
      autoSummarize: settings.autoSummarize,
      enableOfflineMode: settings.enableOfflineMode,
      lastTabId: settings.lastTabId,
    );
  }

  AppSettings toEntity() {
    return AppSettings(
      isDarkMode: isDarkMode,
      defaultSearchEngine: defaultSearchEngine,
      defaultLanguage: defaultLanguage,
      saveHistory: saveHistory,
      enableJavascript: enableJavascript,
      blockPopups: blockPopups,
      summaryLength: summaryLength,
      autoSummarize: autoSummarize,
      enableOfflineMode: enableOfflineMode,
      lastTabId: lastTabId,
    );
  }
}
