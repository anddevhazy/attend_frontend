import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/enums/role.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  final Role role;

  const LoginPage({super.key, required this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final roleLabel = widget.role == Role.student ? "Student" : "Lecturer";
    final hero =
        widget.role == Role.student
            ? AppAssets.loginStudentHero
            : AppAssets.loginHero;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        // leading: IconButton(
        //   icon: const Icon(
        //     Icons.arrow_back_ios_new_rounded,
        //     color: AppColors.primary,
        //   ),
        //   onPressed: () => Navigator.pop(context),
        // ),
        title: Text(
          "Attend",
          style: AppTextStyles.h2.copyWith(
            fontSize: 18,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            // ignore: deprecated_member_use
            color: AppColors.primary.withOpacity(0.06),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(hero, height: 210, fit: BoxFit.contain),
                const SizedBox(height: AppSpacing.lg),

                Text(
                  "Welcome",
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 28,
                    color: AppColors.primary,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),

                Text(
                  "Continue with your Google account",
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 14.8,
                    // ignore: deprecated_member_use
                    color: AppColors.textPrimary.withOpacity(0.75),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),

                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () => context.goNamed(Routes.lecturerHomeName),
                    borderRadius: BorderRadius.circular(18),
                    child: SvgPicture.asset(AppAssets.googleContinueButton),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
