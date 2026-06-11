import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static TextTheme textTheme() {
    final base = GoogleFonts.interTextTheme();

    return base.copyWith(
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: AppColors.textPrimary,
      ),
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: AppColors.textPrimary,
      ),
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.textPrimary,
      ),
      displaySmall: base.displaySmall?.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 1.2,
        color: AppColors.textPrimary,
      ),
    );
  }
}
