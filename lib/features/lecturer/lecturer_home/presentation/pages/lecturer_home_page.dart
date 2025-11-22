import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LecturerHomePage extends StatelessWidget {
  const LecturerHomePage({super.key});

  // Toggle to test both states
  final bool hasActiveSession = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.accent.withOpacity(0.2),
                    child: Text(
                      'DO',
                      style: AppTextStyles.h2.copyWith(
                        fontSize: 20,
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        'Dr. Okafor',
                        style: AppTextStyles.h2.copyWith(
                          fontSize: 22,
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
                      size: 30,
                    ),
                    onPressed: () {
                      // You will go to Past Sessions
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

      // Floating Action Button – always visible
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.goNamed(Routes.createSessionName);
        },
        backgroundColor: AppColors.primary,
        elevation: 10,
        icon: const Icon(Icons.play_arrow_rounded, size: 32),
        label: Text(
          'Start Session',
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
          Image.asset(AppAssets.lecturerDashboardHero, height: 240),
          SizedBox(height: AppSpacing.xxl),

          Text(
            'CSC 301 • LH 201',
            style: AppTextStyles.h1.copyWith(
              fontSize: 32,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Data Structures & Algorithms',
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),

          SizedBox(height: AppSpacing.xxl),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatChip(
                label: 'Present',
                count: '47',
                color: AppColors.success,
              ),
              SizedBox(width: AppSpacing.xl),
              _StatChip(label: 'Pending', count: '3', color: AppColors.warning),
              SizedBox(width: AppSpacing.xl),
              _StatChip(label: 'Requests', count: '2', color: AppColors.accent),
            ],
          ),

          SizedBox(height: AppSpacing.xxl),

          // Live indicator
          Container(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.circle, color: AppColors.success, size: 16),
                SizedBox(width: 8),
                Text(
                  'Session Live • Ends in 42:15',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
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
            AppAssets.lecturerNoSession,
            height: 320,
            fit: BoxFit.contain,
          ),
          SizedBox(height: AppSpacing.xxl),

          Text(
            'Ready when you are',
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
              'Tap the button below to start taking attendance for your class',
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

class _StatChip extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: AppTextStyles.h2.copyWith(fontSize: 32, color: color),
          ),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
