import 'package:flutter/material.dart';

/// BuildContext extension methods
extension ContextExtensions on BuildContext {
  /// Get theme data
  ThemeData get theme => Theme.of(this);

  /// Get text theme
  TextTheme get textTheme => theme.textTheme;

  /// Get color scheme
  ColorScheme get colorScheme => theme.colorScheme;

  /// Get media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size
  Size get screenSize => mediaQuery.size;

  /// Get screen width
  double get screenWidth => screenSize.width;

  /// Get screen height
  double get screenHeight => screenSize.height;

  /// Check if dark mode
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Get bottom padding (for safe area)
  double get bottomPadding => mediaQuery.padding.bottom;

  /// Get top padding (for safe area)
  double get topPadding => mediaQuery.padding.top;

  /// Check if landscape
  bool get isLandscape => mediaQuery.orientation == Orientation.landscape;

  /// Check if mobile (width < 600)
  bool get isMobile => screenWidth < 600;

  /// Check if tablet (600 <= width < 1200)
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;

  /// Check if desktop (width >= 1200)
  bool get isDesktop => screenWidth >= 1200;

  /// Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
      ),
    );
  }

  /// Pop navigation
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  /// Push named route
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed(routeName, arguments: arguments);
  }
}
