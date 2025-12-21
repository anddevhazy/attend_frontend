import 'package:attend/features/auth/presentation/widgets/signup_input_field_widget.dart';
import 'package:attend/global/components/app_toast.dart';
import 'package:attend/global/components/loading_overlay.dart';
import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/enums/role.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  final Role role;

  const SignupPage({super.key, required this.role});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isValid = false;

  void _validate() {
    setState(() {
      _isValid = _formKey.currentState?.validate() ?? false;
    });
  }

  // Add this method inside _SignupPageState
  Future<void> _simulateSignUp() async {
    // 1. Show loading
    LoadingOverlay.show(context);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // === SIMULATED SCENARIOS (uncomment ONE at a time to test) ===

    // Scenario 1: Network unavailable
    // LoadingOverlay.hide();
    // AppToast.show(
    //   context: context,
    //   message: "No internet connection",
    //   type: ToastType.error,
    // );
    // return;

    // Scenario 2: API failure (500)
    // LoadingOverlay.hide();
    // AppToast.show(
    //   context: context,
    //   message: "Server error. Try again later",
    //   type: ToastType.error,
    // );
    // return;

    // Scenario 3: Email already in use
    // LoadingOverlay.hide();
    // AppToast.show(
    //   context: context,
    //   message: "This email is already registered",
    //   type: ToastType.warning,
    // );
    // return;

    // Scenario 4: Unexpected error (e.g. JSON parse fail)
    // LoadingOverlay.hide();
    // AppToast.show(
    //   context: context,
    //   message: "Something went wrong. Please try again",
    //   type: ToastType.error,
    // );
    // return;

    // // Scenario 5: SUCCESS → Account created!
    LoadingOverlay.hide();
    AppToast.show(
      context: context,
      message: "Account created successfully",
      type: ToastType.success,
    );

    // Navigate after celebration
    await Future.delayed(const Duration(seconds: 3));
    context.goNamed(Routes.studentCourseSelectionName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
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
          child: Form(
            key: _formKey,
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
                  widget.role == Role.student
                      ? 'Create Student Account'
                      : 'Create Lecturer Account',
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
                SignupInputFieldWidget(
                  label: 'Email',
                  hint: 'name@gmail.com',
                  keyboardType: TextInputType.emailAddress,

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!value.contains("@") || !value.contains(".")) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                  onChanged: (_) => _validate(),
                ),

                SizedBox(height: AppSpacing.lg),

                // Password Field
                SignupInputFieldWidget(
                  label: 'Password',
                  hint: 'Create a strong password',
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required";
                    }
                    if (value.length < 2)
                      return "Must be at least 6 characters";
                    return null;
                  },
                  controller: passwordController,
                  onChanged: (_) => _validate(),
                ),

                SizedBox(height: AppSpacing.lg),

                // Confirm Password
                SignupInputFieldWidget(
                  label: 'Confirm Password',
                  hint: 'Re-type your password',
                  isPassword: true,
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please confirm your password";
                    }
                    if (value != passwordController.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  onChanged: (_) => _validate(),
                ),

                SizedBox(height: AppSpacing.xxl),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed:
                        _isValid
                            ? () {
                              // Navigation to course selection page
                              // context.goNamed(
                              //   Routes.studentCourseSelectionName,
                              // );
                              _simulateSignUp();
                            }
                            : null,
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
      ),
    );
  }
}
