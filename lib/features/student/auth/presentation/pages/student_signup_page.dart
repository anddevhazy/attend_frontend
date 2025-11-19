import 'package:attend/global/components/app_toast.dart';
import 'package:attend/global/components/attendance_result_overlay.dart';
import 'package:attend/global/components/loading_overlay.dart';
import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentSignUpPage extends StatefulWidget {
  const StudentSignUpPage({super.key});

  @override
  State<StudentSignUpPage> createState() => _StudentSignUpPageState();
}

class _StudentSignUpPageState extends State<StudentSignUpPage> {
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

  // Add this method inside _StudentSignUpPageState
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

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email is required";
                    }
                    if (!value.contains("@") || !value.contains(".")) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),

                SizedBox(height: AppSpacing.lg),

                // Password Field
                _InputField(
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
                ),

                SizedBox(height: AppSpacing.lg),

                // Confirm Password
                _InputField(
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

class _InputField extends StatefulWidget {
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const _InputField({
    required this.label,
    required this.hint,
    this.keyboardType,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.controller,
  });

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  bool _obscure = true; // initial hidden state
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.inputLabel),
        SizedBox(height: 8),
        TextFormField(
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscure : false,

          onChanged: (value) {
            setState(() {
              _errorText = widget.validator?.call(value);
            });
            widget.onChanged?.call(value);
            final parentState =
                context.findAncestorStateOfType<_StudentSignUpPageState>();
            parentState?._validate();
          },
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
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
            errorText: _errorText,
            errorStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.error,
              fontSize: 13,
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.error, width: 3),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),

            contentPadding: EdgeInsets.symmetric(vertical: 12),

            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: AppColors.textPrimary.withOpacity(0.6),
                      ),
                      onPressed: () {
                        setState(() => _obscure = !_obscure);
                      },
                    )
                    : null,
          ),
          controller: widget.controller,
        ),
      ],
    );
  }
}
