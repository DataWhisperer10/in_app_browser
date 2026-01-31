import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';

/// Application theme configuration
class AppTheme {
  AppTheme._();

  // Font families - fallback to system fonts if custom fonts not available
  static const String _fontFamily = 'Geist';

  /// Dark theme - Primary theme for the browser
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      
      // Color scheme
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
        onPrimary: AppColors.backgroundDark,
        onSecondary: AppColors.textPrimaryDark,
        onSurface: AppColors.textPrimaryDark,
        onError: AppColors.textPrimaryDark,
      ),

      // Scaffold
      scaffoldBackgroundColor: AppColors.backgroundDark,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppColors.backgroundDark,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderDark, width: 1),
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 12,
        ),
      ),

      // Navigation Bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        indicatorColor: AppColors.primary.withValues(alpha: 0.2),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: _fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            );
          }
          return const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 12,
            color: AppColors.textTertiaryDark,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primary, size: 24);
          }
          return const IconThemeData(color: AppColors.textTertiaryDark, size: 24);
        }),
      ),

      // Elevated Button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.backgroundDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text Button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Icon Button
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: AppColors.textSecondaryDark,
        ),
      ),

      // Input Decoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(
          fontFamily: _fontFamily,
          color: AppColors.textTertiaryDark,
        ),
        labelStyle: const TextStyle(
          fontFamily: _fontFamily,
          color: AppColors.textSecondaryDark,
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.cardDark,
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        side: const BorderSide(color: AppColors.borderDark),
        labelStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontSize: 13,
          color: AppColors.textPrimaryDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Tab Bar
      tabBarTheme: const TabBarThemeData(
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textTertiaryDark,
        indicatorColor: AppColors.primary,
        labelStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.backgroundDark,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Progress Indicator
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.borderDark,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 1,
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: _fontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
      ),

      // Bottom Sheet
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceDark,
        modalBackgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.cardDark,
        contentTextStyle: const TextStyle(
          fontFamily: _fontFamily,
          color: AppColors.textPrimaryDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimaryDark,
        ),
        displayMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimaryDark,
        ),
        displaySmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimaryDark,
        ),
        headlineLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        headlineMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        headlineSmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        titleLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        titleMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        titleSmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryDark,
        ),
        bodyLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimaryDark,
        ),
        bodyMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondaryDark,
        ),
        bodySmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textTertiaryDark,
        ),
        labelLarge: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryDark,
        ),
        labelMedium: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondaryDark,
        ),
        labelSmall: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.textTertiaryDark,
        ),
      ),
    );
  }

  /// Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: _fontFamily,
      
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryDark,
        secondary: AppColors.secondary,
        tertiary: AppColors.accent,
        surface: AppColors.surfaceLight,
        error: AppColors.error,
        onPrimary: AppColors.surfaceLight,
        onSecondary: AppColors.textPrimaryLight,
        onSurface: AppColors.textPrimaryLight,
        onError: AppColors.surfaceLight,
      ),

      scaffoldBackgroundColor: AppColors.backgroundLight,

      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: AppColors.surfaceLight,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          fontFamily: _fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimaryLight,
        ),
      ),

      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.borderLight, width: 1),
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        indicatorColor: AppColors.primaryDark.withValues(alpha: 0.1),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: _fontFamily,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryDark,
            );
          }
          return const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 12,
            color: AppColors.textTertiaryLight,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: AppColors.primaryDark, size: 24);
          }
          return const IconThemeData(color: AppColors.textTertiaryLight, size: 24);
        }),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.surfaceLight,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: _fontFamily,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryDark, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(
          fontFamily: _fontFamily,
          color: AppColors.textTertiaryLight,
        ),
      ),

      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: _fontFamily, fontSize: 57, fontWeight: FontWeight.w400, color: AppColors.textPrimaryLight),
        displayMedium: TextStyle(fontFamily: _fontFamily, fontSize: 45, fontWeight: FontWeight.w400, color: AppColors.textPrimaryLight),
        displaySmall: TextStyle(fontFamily: _fontFamily, fontSize: 36, fontWeight: FontWeight.w400, color: AppColors.textPrimaryLight),
        headlineLarge: TextStyle(fontFamily: _fontFamily, fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight),
        headlineMedium: TextStyle(fontFamily: _fontFamily, fontSize: 28, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight),
        headlineSmall: TextStyle(fontFamily: _fontFamily, fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight),
        titleLarge: TextStyle(fontFamily: _fontFamily, fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight),
        titleMedium: TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight),
        titleSmall: TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimaryLight),
        bodyLarge: TextStyle(fontFamily: _fontFamily, fontSize: 16, fontWeight: FontWeight.w400, color: AppColors.textPrimaryLight),
        bodyMedium: TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textSecondaryLight),
        bodySmall: TextStyle(fontFamily: _fontFamily, fontSize: 12, fontWeight: FontWeight.w400, color: AppColors.textTertiaryLight),
        labelLarge: TextStyle(fontFamily: _fontFamily, fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimaryLight),
        labelMedium: TextStyle(fontFamily: _fontFamily, fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.textSecondaryLight),
        labelSmall: TextStyle(fontFamily: _fontFamily, fontSize: 11, fontWeight: FontWeight.w500, color: AppColors.textTertiaryLight),
      ),
    );
  }
}
