import 'package:attend/global/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Headlines
  static TextStyle h1 = GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 1.2,
    color: AppColors.white,
  );

  static TextStyle h2 = GoogleFonts.poppins(
    fontWeight: FontWeight.w700,
    fontSize: 28,
    height: 1.25,
    color: AppColors.white,
  );

  // Body
  static TextStyle bodyLarge = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    height: 1.5,
    color: AppColors.white,
  );

  static TextStyle bodyMedium = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    height: 1.45,
    color: AppColors.white,
  );

  static TextStyle inputLabel = GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: AppColors.primary,
  );

  static TextStyle inputHint = GoogleFonts.poppins(
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColors.textPrimary.withOpacity(0.6),
  );
}
