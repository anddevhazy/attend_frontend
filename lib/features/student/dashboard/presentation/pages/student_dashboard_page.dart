import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:flutter/material.dart';

class StudentDashboardPage extends StatelessWidget {
  const StudentDashboardPage({super.key});

  // Toggle this to test both states
  final bool hasActiveSession = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top App Bar
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: AssetImage(
                      AppAssets.dashboardAvatarPlaceholder,
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        'Adebayo John',
                        style: AppTextStyles.h2.copyWith(
                          fontSize: 20,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.history_rounded,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    onPressed: () {
                      // You will go to Attendance History
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child:
                  hasActiveSession
                      ? _ActiveSessionView()
                      : _NoActiveSessionView(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActiveSessionView extends StatelessWidget {
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
            style: AppTextStyles.bodyLarge.copyWith(fontSize: 20),
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
                Text('Session ends in ', style: AppTextStyles.bodyLarge),
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
                // You will trigger Mark Attendance flow
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

class _NoActiveSessionView extends StatelessWidget {
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
              'Relax! Your lecturer will start the attendance session when class begins.',
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: 17,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
