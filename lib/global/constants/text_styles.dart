import 'package:attend/global/constants/colors.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  // Headlines
  static const TextStyle h1 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 1.2,
    color: AppColors.white,
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w700,
    fontSize: 28,
    height: 1.25,
    color: AppColors.white,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
    color: AppColors.white,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.45,
    color: AppColors.white,
  );

  static const TextStyle inputLabel = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: AppColors.primary,
  );

  static TextStyle inputHint = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.textPrimary.withOpacity(0.6),
  );
}
