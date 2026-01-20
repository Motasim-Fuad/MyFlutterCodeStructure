import 'package:flutter/material.dart';

// =====================================================
// APP COLORS
// =====================================================
// WHY: Centralized color management
// - Easy to maintain brand colors
// - Single source of truth
// - Easy to update theme
// =====================================================

class AppColors {
  // Prevent instantiation
  // WHY: This is a utility class, no need for objects
  AppColors._();

  // ====== PRIMARY COLORS ======
  // WHY: Main brand colors used throughout the app
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF64B5F6);

  // ====== SECONDARY COLORS ======
  // WHY: Accent colors for highlights and CTAs
  static const Color secondary = Color(0xFF03A9F4);
  static const Color secondaryDark = Color(0xFF0288D1);
  static const Color secondaryLight = Color(0xFF4FC3F7);

  // ====== SEMANTIC COLORS ======
  // WHY: Consistent feedback colors across app
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);

  // ====== NEUTRAL COLORS (Light Theme) ======
  // WHY: Background, text, borders for light theme
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF5F5F5);
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color dividerLight = Color(0xFFBDBDBD);

  // ====== NEUTRAL COLORS (Dark Theme) ======
  // WHY: Background, text, borders for dark theme
  static const Color backgroundDark = Color(0xFF121212);
  static const Color surfaceDark = Color(0xFF1E1E1E);
  static const Color textPrimaryDark = Color(0xFFFFFFFF);
  static const Color textSecondaryDark = Color(0xFFB0B0B0);
  static const Color dividerDark = Color(0xFF424242);

  // ====== GRADIENT COLORS ======
  // WHY: For premium UI elements, buttons, cards
  static const List<Color> primaryGradient = [
    Color(0xFF2196F3),
    Color(0xFF1976D2),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFF03A9F4),
    Color(0xFF0288D1),
  ];
}