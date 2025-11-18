import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentLoginPage extends StatelessWidget {
  const StudentLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: AppSpacing.xl),

              // Hero Illustration
              Center(
                child: Image.asset(
                  AppAssets.loginStudentHero,
                  height: 280,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: AppSpacing.xxl),

              // Headline
              Text(
                'Welcome Back!',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 36,
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: AppSpacing.md),

              Text(
                'Log in with your email address',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 17,
                  color: AppColors.textPrimary.withOpacity(0.85),
                ),
              ),

              SizedBox(height: AppSpacing.xxl),

              // Matric / Email Field
              _InputField(
                label: 'Email',
                hint: 'name@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: AppSpacing.xl),

              // Password Field
              _InputField(
                label: 'Password',
                hint: 'Enter your password',
                isPassword: true,
              ),

              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // I will handle forgot password later
                  },
                  child: Text(
                    'Forgot Password?',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.xxl),

              // Log In Button
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigation to dashboard
                    context.goNamed(Routes.studentDashboardName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                  ),
                  child: Text(
                    'Log In',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              // Sign Up Redirect
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigation to StudentSignUpScreen
                    context.goNamed(Routes.studentSignUpName);
                  },
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 15),
                      children: [
                        const TextSpan(text: "Don't have an account? "),
                        TextSpan(
                          text: 'Sign up',
                          style: const TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

// Reusable input field (same as sign-up, kept identical for consistency)
class _InputField extends StatelessWidget {
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final bool isPassword;

  const _InputField({
    required this.label,
    required this.hint,
    this.keyboardType,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.inputLabel),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: keyboardType,
          obscureText: isPassword,
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.inputHint,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent, width: 3),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }
}
