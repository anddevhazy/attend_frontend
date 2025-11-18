import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              const Spacer(flex: 3),

              // Headline
              Text(
                'Welcome to Attend',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 36,
                  height: 1.1,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSpacing.md),

              Text(
                'Choose your role to continue',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 18,
                  color: AppColors.textPrimary.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 4),

              // Student Card
              _RoleCard(
                image: AppAssets.roleStudent,
                title: 'Student',
                subtitle: 'Mark attendance\nCheck records\nStay verified',
                color: AppColors.primary,
                onTap: () {
                  // Navigation to Student Signup
                  context.goNamed(Routes.studentSignUpName);
                },
              ),

              SizedBox(height: AppSpacing.xl),

              // Lecturer Card
              _RoleCard(
                image: AppAssets.roleLecturer,
                title: 'Lecturer',
                subtitle: 'Create sessions\nVerify presence\nExport records',
                color: AppColors.accent,
                onTap: () {
                  // Navigation to Lecturer Signup
                },
              ),

              const Spacer(flex: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _RoleCard({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 8,
      shadowColor: color.withOpacity(0.3),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.xl),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.12), color.withOpacity(0.05)],
            ),
          ),
          child: Row(
            children: [
              // Illustration
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  image,
                  width: 120,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(width: AppSpacing.xl),

              // Text Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.h2.copyWith(
                        fontSize: 32,
                        color: color,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 16,
                        height: 1.4,
                        color: AppColors.textPrimary.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow
              Icon(Icons.arrow_forward_ios_rounded, color: color, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}
