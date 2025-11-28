import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/pages/role_selection/presentation/widgets/role_card_widget.dart';
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
              RoleCardWidget(
                image: AppAssets.roleStudent,
                title: 'Student',
                subtitle: 'Mark attendance\nCheck records\nStay verified',
                color: AppColors.primary,
                onTap: () {
                  // Navigation to Student Signup
                  context.pushNamed(Routes.studentSignUpName);
                },
              ),

              SizedBox(height: AppSpacing.xl),

              // Lecturer Card
              RoleCardWidget(
                image: AppAssets.roleLecturer,
                title: 'Lecturer',
                subtitle: 'Create sessions\nVerify presence\nExport records',
                color: AppColors.accent,
                onTap: () {
                  context.pushNamed(Routes.studentSignUpName);
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
