/// Application-wide constants
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'IA Browser';
  static const String appVersion = '1.0.0';

  // Default URLs
  static const String defaultHomePage = 'https://www.google.com';
  static const String defaultSearchEngine = 'https://www.google.com/search?q=';

  // Max tabs allowed
  static const int maxTabs = 10;
  static const int minTabs = 1;

  // Supported file extensions for download
  static const List<String> supportedDocumentExtensions = [
    '.pdf',
    '.docx',
    '.pptx',
    '.xlsx',
    '.doc',
    '.ppt',
    '.xls',
  ];

  // Supported MIME types
  static const Map<String, String> mimeTypes = {
    'pdf': 'application/pdf',
    'docx': 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
    'doc': 'application/msword',
    'pptx': 'application/vnd.openxmlformats-officedocument.presentationml.presentation',
    'ppt': 'application/vnd.ms-powerpoint',
    'xlsx': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
    'xls': 'application/vnd.ms-excel',
  };

  // Cache settings
  static const int maxCacheAgeDays = 7;
  static const int maxCachedPages = 50;
  static const int maxCachedSummaries = 100;

  // AI Settings
  static const int defaultSummaryLength = 150; // words
  static const int maxSummaryLength = 500;
  static const int minSummaryLength = 50;

  // Animation durations (in milliseconds)
  static const int shortAnimationDuration = 200;
  static const int mediumAnimationDuration = 350;
  static const int longAnimationDuration = 500;

  // Supported languages for translation
  static const Map<String, String> supportedLanguages = {
    'en': 'English',
    'hi': 'Hindi',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'zh': 'Chinese',
    'ja': 'Japanese',
    'ar': 'Arabic',
    'pt': 'Portuguese',
    'ru': 'Russian',
  };

  // Storage keys
  static const String tabsBoxKey = 'tabs_box';
  static const String settingsBoxKey = 'settings_box';
  static const String cacheBoxKey = 'cache_box';
  static const String historyBoxKey = 'history_box';
  static const String downloadsBoxKey = 'downloads_box';
  static const String summariesBoxKey = 'summaries_box';
}
