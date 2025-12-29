import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/enums/role.dart';
import 'package:attend/global/pages/role_selection/presentation/widgets/role_card_widget.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoleSelectionPage extends StatelessWidget {
  const RoleSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.xl,
              ),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: AppSpacing.lg),

                    Text(
                      'Welcome to Attend',
                      style: AppTextStyles.h1.copyWith(
                        fontSize: 34,
                        height: 1.1,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      'Choose your role to continue',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 16.5,
                        color: AppColors.textPrimary.withOpacity(0.8),
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    RoleCardWidget(
                      image: AppAssets.roleStudent,
                      title: 'Student',
                      subtitle: 'Mark attendance\nCheck records\nStay verified',
                      color: AppColors.primary,
                      onTap: () {
                        context.pushNamed(
                          Routes.signUpName,
                          extra: Role.student,
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    RoleCardWidget(
                      image: AppAssets.roleLecturer,
                      title: 'Lecturer',
                      subtitle:
                          'Create sessions\nVerify presence\nExport records',
                      color: AppColors.accent,
                      onTap: () {
                        context.pushNamed(
                          Routes.signUpName,
                          extra: Role.lecturer,
                        );
                      },
                    ),

                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
