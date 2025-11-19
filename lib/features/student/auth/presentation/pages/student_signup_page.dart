import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentSignUpPage extends StatelessWidget {
  const StudentSignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
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
              SizedBox(height: AppSpacing.lg),

              // Hero Illustration
              Center(
                child: Image.asset(
                  AppAssets.signupStudentHero,
                  height: 240,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: AppSpacing.xxl),

              // Headline
              Text(
                'Create Student Account',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 32,
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: AppSpacing.md),

              Text(
                'Join thousands of FUNAAB students using secure attendance',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 16,
                  color: AppColors.textPrimary.withOpacity(0.85),
                ),
              ),

              SizedBox(height: AppSpacing.xxl),

              // Email Field
              _InputField(
                label: 'Email',
                hint: 'name@gmail.com',
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: AppSpacing.lg),

              // Password Field
              _InputField(
                label: 'Password',
                hint: 'Create a strong password',
                isPassword: true,
              ),

              SizedBox(height: AppSpacing.lg),

              // Confirm Password
              _InputField(
                label: 'Confirm Password',
                hint: 'Re-type your password',
                isPassword: true,
              ),

              SizedBox(height: AppSpacing.xxl),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigation to course selection page
                    context.goNamed(Routes.studentCourseSelectionName);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                  ),
                  child: Text(
                    'Continue',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              // Login Redirect
              Center(
                child: TextButton(
                  onPressed: () {
                    // Navigation to login
                    context.goNamed(Routes.studentLoginName);
                  },
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.bodyMedium,
                      children: [
                        TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Log in',
                          style: TextStyle(
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
        SizedBox(height: 8),
        TextFormField(
          keyboardType: keyboardType,
          obscureText: isPassword,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.inputHint,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent, width: 3),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ],
    );
  }
}
