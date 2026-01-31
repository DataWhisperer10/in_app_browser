/// Application settings entity
class AppSettings {
  final bool isDarkMode;
  final String defaultSearchEngine;
  final String defaultLanguage;
  final bool saveHistory;
  final bool enableJavascript;
  final bool blockPopups;
  final int summaryLength;
  final bool autoSummarize;
  final bool enableOfflineMode;
  final String? lastTabId;

  const AppSettings({
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

  AppSettings copyWith({
    bool? isDarkMode,
    String? defaultSearchEngine,
    String? defaultLanguage,
    bool? saveHistory,
    bool? enableJavascript,
    bool? blockPopups,
    int? summaryLength,
    bool? autoSummarize,
    bool? enableOfflineMode,
    String? lastTabId,
  }) {
    return AppSettings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      defaultSearchEngine: defaultSearchEngine ?? this.defaultSearchEngine,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      saveHistory: saveHistory ?? this.saveHistory,
      enableJavascript: enableJavascript ?? this.enableJavascript,
      blockPopups: blockPopups ?? this.blockPopups,
      summaryLength: summaryLength ?? this.summaryLength,
      autoSummarize: autoSummarize ?? this.autoSummarize,
      enableOfflineMode: enableOfflineMode ?? this.enableOfflineMode,
      lastTabId: lastTabId ?? this.lastTabId,
    );
  }
}
