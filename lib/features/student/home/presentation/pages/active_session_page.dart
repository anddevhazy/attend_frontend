import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ActiveSessionPage extends StatelessWidget {
  const ActiveSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        children: [
          Image.asset(
            AppAssets.dashboardActiveClass,
            height: 260,
            fit: BoxFit.contain,
          ),
          SizedBox(height: AppSpacing.xxl),

          Text(
            'CSC 301 is live!',
            style: AppTextStyles.h1.copyWith(
              fontSize: 36,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: AppSpacing.lg),

          Text(
            'Data Structures & Algorithms',
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'Dr. Adebayo • LH 201',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary.withOpacity(0.8),
            ),
          ),

          SizedBox(height: AppSpacing.xxl),

          // Countdown Timer
          Container(
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.lg,
              horizontal: AppSpacing.xl,
            ),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.timer_outlined, color: AppColors.accent),
                SizedBox(width: 8),
                Text(
                  'Session ends in ',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '14:27',
                  style: AppTextStyles.h2.copyWith(
                    fontSize: 28,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: AppSpacing.xxl),

          // Mark Attendance Button
          SizedBox(
            width: double.infinity,
            height: 64,
            child: ElevatedButton(
              onPressed: () {
                context.goNamed(Routes.markAttendanceName);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 10,
              ),
              child: Text(
                'Mark Attendance Now',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
