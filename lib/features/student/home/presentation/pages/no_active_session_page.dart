import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:flutter/material.dart';

class NoActiveSessionPage extends StatelessWidget {
  const NoActiveSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AppAssets.dashboardNoClass,
            height: 300,
            fit: BoxFit.contain,
          ),
          SizedBox(height: AppSpacing.xxl),

          Text(
            'No active class 😴',
            style: AppTextStyles.h1.copyWith(
              fontSize: 34,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppSpacing.lg),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            child: Text(
              'Relax! You will see an attendance session here when any of your lecturers starts a class.',
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: 17,
                height: 1.5,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
