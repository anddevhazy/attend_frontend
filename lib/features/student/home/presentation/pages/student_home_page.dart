import 'package:attend/features/student/home/presentation/pages/activate_account_page.dart';
import 'package:attend/features/student/home/presentation/pages/active_session_page.dart';
import 'package:attend/features/student/home/presentation/pages/no_active_session_page.dart';
import 'package:attend/global/components/app_toast.dart';
import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:flutter/material.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  // SIMULATION STATE — In real app, store this in Hive/secure storage
  bool _isAccountActivated = false; // Set to false first time

  // Toggle this to test live session
  final bool _hasActiveSession = false;

  @override
  Widget build(BuildContext context) {
    if (!_isAccountActivated) {
      return ActivateAccountPage(
        onActivated: () {
          setState(() => _isAccountActivated = true);
          AppToast.show(
            context: context,
            message: "Account activated successfully!",
            type: ToastType.success,
          );
        },
      );
    }

    // Normal dashboard once activated
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
                        'Welcome back',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        'Elijah',
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
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            Expanded(
              child:
                  _hasActiveSession
                      ? ActiveSessionPage()
                      : NoActiveSessionPage(),
            ),
          ],
        ),
      ),
    );
  }
}
