/// String extension methods
extension StringExtensions on String {
  /// Capitalize first letter
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalize each word
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String suffix = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Check if string is URL
  bool get isUrl {
    final uri = Uri.tryParse(this);
    return uri != null && uri.hasScheme;
  }

  /// Remove HTML tags
  String get stripHtml {
    return replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Count words
  int get wordCount {
    if (trim().isEmpty) return 0;
    return trim().split(RegExp(r'\s+')).length;
  }
}
