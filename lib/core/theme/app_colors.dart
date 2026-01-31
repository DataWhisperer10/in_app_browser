import 'package:flutter/material.dart';

/// Application color palette - Cyber-minimal aesthetic with deep contrasts
class AppColors {
  AppColors._();

  // Primary palette - Electric cyan meets obsidian
  static const Color primary = Color(0xFF00E5FF);
  static const Color primaryDark = Color(0xFF00B8D4);
  static const Color primaryLight = Color(0xFF6EFFFF);

  // Secondary palette - Warm coral accent
  static const Color secondary = Color(0xFFFF6B6B);
  static const Color secondaryDark = Color(0xFFEE5A5A);
  static const Color secondaryLight = Color(0xFFFF8A8A);

  // Accent - Vibrant violet
  static const Color accent = Color(0xFF7C4DFF);
  static const Color accentDark = Color(0xFF651FFF);
  static const Color accentLight = Color(0xFFB388FF);

  // Neutrals - Deep space grays
  static const Color backgroundDark = Color(0xFF0A0E14);
  static const Color surfaceDark = Color(0xFF121820);
  static const Color cardDark = Color(0xFF1A2332);
  static const Color borderDark = Color(0xFF2D3748);

  // Light mode neutrals
  static const Color backgroundLight = Color(0xFFF7F8FA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFF0F2F5);
  static const Color borderLight = Color(0xFFE2E8F0);

  // Text colors
  static const Color textPrimaryDark = Color(0xFFF7FAFC);
  static const Color textSecondaryDark = Color(0xFFA0AEC0);
  static const Color textTertiaryDark = Color(0xFF718096);

  static const Color textPrimaryLight = Color(0xFF1A202C);
  static const Color textSecondaryLight = Color(0xFF4A5568);
  static const Color textTertiaryLight = Color(0xFF718096);

  // Semantic colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Browser specific
  static const Color tabActive = Color(0xFF1E293B);
  static const Color tabInactive = Color(0xFF0F172A);
  static const Color urlBarBackground = Color(0xFF1E293B);
  static const Color progressBar = primary;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0A0E14), Color(0xFF1A2332)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [secondary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Shimmer colors
  static const Color shimmerBase = Color(0xFF1E293B);
  static const Color shimmerHighlight = Color(0xFF334155);
}
