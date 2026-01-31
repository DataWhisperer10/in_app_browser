import '../constants/app_constants.dart';

/// URL utility functions
class UrlUtils {
  UrlUtils._();

  /// Check if string is a valid URL
  static bool isValidUrl(String input) {
    final uri = Uri.tryParse(input);
    if (uri == null) return false;
    return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  /// Normalize URL input - add https if missing
  static String normalizeUrl(String input) {
    input = input.trim();
    
    if (input.isEmpty) return AppConstants.defaultHomePage;
    
    // Check if it's already a valid URL
    if (isValidUrl(input)) return input;
    
    // Check if it looks like a domain
    if (_looksLikeDomain(input)) {
      return 'https://$input';
    }
    
    // Otherwise, treat as search query
    return '${AppConstants.defaultSearchEngine}${Uri.encodeComponent(input)}';
  }

  /// Check if input looks like a domain name
  static bool _looksLikeDomain(String input) {
    // Simple check for domain-like patterns
    final domainPattern = RegExp(
      r'^[a-zA-Z0-9][a-zA-Z0-9-]*(\.[a-zA-Z]{2,})+(/.*)?$',
    );
    return domainPattern.hasMatch(input);
  }

  /// Extract domain from URL
  static String? extractDomain(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.host;
    } catch (e) {
      return null;
    }
  }

  /// Get favicon URL for a domain
  static String getFaviconUrl(String url) {
    final domain = extractDomain(url);
    if (domain == null) return '';
    return 'https://www.google.com/s2/favicons?domain=$domain&sz=64';
  }

  /// Check if URL is downloadable document
  static bool isDownloadableDocument(String url) {
    final lowerUrl = url.toLowerCase();
    return AppConstants.supportedDocumentExtensions.any(
      (ext) => lowerUrl.endsWith(ext),
    );
  }

  /// Get file extension from URL
  static String? getFileExtension(String url) {
    try {
      final uri = Uri.parse(url);
      final path = uri.path;
      final lastDot = path.lastIndexOf('.');
      if (lastDot == -1) return null;
      return path.substring(lastDot).toLowerCase();
    } catch (e) {
      return null;
    }
  }

  /// Get filename from URL
  static String getFileNameFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      final segments = uri.pathSegments;
      if (segments.isEmpty) return 'download';
      return segments.last.isNotEmpty ? segments.last : 'download';
    } catch (e) {
      return 'download';
    }
  }

  /// Check if URL is secure (HTTPS)
  static bool isSecure(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == 'https';
    } catch (e) {
      return false;
    }
  }
}
