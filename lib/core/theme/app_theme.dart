import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.accent,
      brightness: Brightness.light,
      primary: AppColors.accent,
      surface: AppColors.secondary,
      error: AppColors.destructive,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.dominant,
      textTheme: AppTypography.textTheme(),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.accent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.destructive),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
