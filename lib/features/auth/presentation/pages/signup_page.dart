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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isValid = false;

  void _validate() {
    final isValidNow = _formKey.currentState?.validate() ?? false;
    if (_isValid != isValidNow) setState(() => _isValid = isValidNow);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_isValid) return;

    // ✅ role-aware (adjust to your cubit methods)
    // If your cubit only has studentSignUp for now, keep it but it’s a bug long-term.
    final cubit = context.read<AuthCubit>();

    if (widget.role == Role.student) {
      cubit.studentSignUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    } else {
      // TODO: Replace with your real lecturer signup method when you add it.
      // cubit.lecturerSignUp(...)
      cubit.studentSignUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isStudent = widget.role == Role.student;
    final title =
        isStudent ? "Create student account" : "Create lecturer account";
    final subtitle =
        isStudent
            ? "Secure attendance, less stress."
            : "Verify attendance fast and export records.";

    final hero =
        isStudent ? AppAssets.signupStudentHero : AppAssets.signupLecturerHero;

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

            // ✅ decide destination (student vs lecturer)
            if (isStudent) {
              context.goNamed(Routes.studentCourseSelectionName);
            } else {
              context.goNamed(Routes.lecturerHomeName);
            }
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
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.primary,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                isStudent ? "Student signup" : "Lecturer signup",
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
                  color: AppColors.primary.withOpacity(0.06),
                ),
              ),
            ),

            body: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: SizedBox(height: AppSpacing.md),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl,
                    0,
                    AppSpacing.xl,
                    140, // room for bottom CTA
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Form(
                      key: _formKey,
                      onChanged: _validate,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Image.asset(
                              hero,
                              height: 200,
                              fit: BoxFit.contain,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),

                          Text(
                            title,
                            style: AppTextStyles.h1.copyWith(
                              fontSize: 28,
                              color: AppColors.primary,
                              height: 1.1,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            subtitle,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary.withOpacity(0.75),
                              fontWeight: FontWeight.w600,
                              height: 1.35,
                              fontSize: 14.8,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          // ✅ One clean card
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.lg),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.05),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 18,
                                  offset: const Offset(0, 10),
                                  color: AppColors.primary.withOpacity(0.06),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                SignupInputFieldWidget(
                                  label: 'Email',
                                  hint: 'name@gmail.com',
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Email is required";
                                    }
                                    if (!value.contains("@") ||
                                        !value.contains(".")) {
                                      return "Enter a valid email";
                                    }
                                    return null;
                                  },
                                  onChanged: (_) => _validate(),
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                SignupInputFieldWidget(
                                  label: 'Password',
                                  hint: 'Create a strong password',
                                  isPassword: true,
                                  controller: _passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Password is required";
                                    }
                                    if (value.length < 6) {
                                      return "Must be at least 6 characters";
                                    }
                                    return null;
                                  },
                                  onChanged: (_) => _validate(),
                                ),
                                const SizedBox(height: AppSpacing.lg),
                                SignupInputFieldWidget(
                                  label: 'Confirm Password',
                                  hint: 'Re-type your password',
                                  isPassword: true,
                                  controller: _confirmPasswordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please confirm your password";
                                    }
                                    if (value != _passwordController.text) {
                                      return "Passwords do not match";
                                    }
                                    return null;
                                  },
                                  onChanged: (_) => _validate(),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: AppSpacing.lg),

                          Center(
                            child: TextButton(
                              onPressed: () {
                                context.pushNamed(
                                  Routes.loginName,
                                  extra: widget.role,
                                );
                              },
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 14.8,
                                    color: AppColors.textPrimary.withOpacity(
                                      0.75,
                                    ),
                                    fontWeight: FontWeight.w700,
                                  ),
                                  children: const [
                                    TextSpan(text: 'Already have an account? '),
                                    TextSpan(
                                      text: 'Log in',
                                      style: TextStyle(
                                        color: AppColors.accent,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // ✅ Sticky CTA
            bottomNavigationBar: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.md,
                  AppSpacing.xl,
                  AppSpacing.md,
                ),
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isValid ? _submit : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withOpacity(
                        0.25,
                      ),
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.white,
                        fontSize: 16.5,
                      ),
                    ),
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
