import 'package:attend/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:attend/features/auth/presentation/widgets/signup_input_field_widget.dart';
import 'package:attend/global/components/app_toast.dart';
import 'package:attend/global/components/loading_overlay.dart';
import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/enums/role.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:attend/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignupPage extends StatefulWidget {
  final Role role;

  const SignupPage({super.key, required this.role});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _emailController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => sl<AuthCubit>(),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Loading) {
            LoadingOverlay.show(context);
          } else {
            LoadingOverlay.hide();
          }

          if (state is Successful) {
            AppToast.show(
              context: context,
              message: state.message,
              type: ToastType.success,
            );

            // Only navigate if account was created
            context.goNamed(Routes.studentCourseSelectionName);
          } else if (state is Failed) {
            AppToast.show(
              context: context,
              message: state.message,
              type: ToastType.error,
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBar(
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
                      Center(
                        child: Image.asset(
                          widget.role == Role.student
                              ? AppAssets.signupStudentHero
                              : AppAssets.signupLecturerHero,
                          height: 280,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xxl),
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
                        widget.role == Role.student
                            ? 'Join thousands of FUNAAB students using secure attendance'
                            : 'Start using the most efficient method of verifying who came to class',
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
                        controller: _emailController,
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
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          if (value.length < 6)
                            return "Must be at least 6 characters";
                          return null;
                        },
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
                                    context.read<AuthCubit>().studentSignUp(
                                      email: _emailController.text,
                                      password: passwordController.text,
                                    );
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
                            widget.role == Role.student
                                ? context.pushNamed(
                                  Routes.loginName,
                                  extra: Role.student,
                                )
                                : context.pushNamed(
                                  Routes.loginName,
                                  extra: Role.lecturer,
                                );
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
        },
      ),
    );
  }
}
