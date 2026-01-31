/// API-related constants
class ApiConstants {
  ApiConstants._();

  // Mock AI Summarization API (using a free summarization service)
  // In production, replace with actual API endpoints
  static const String summarizationBaseUrl = 'https://api.smmry.com';
  
  // LibreTranslate API (free and open-source)
  static const String translationBaseUrl = 'https://libretranslate.com';
  static const String translateEndpoint = '/translate';
  static const String detectEndpoint = '/detect';
  static const String languagesEndpoint = '/languages';

  // Timeouts
  static const int connectionTimeout = 30; // seconds
  static const int receiveTimeout = 60; // seconds

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
