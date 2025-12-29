import 'package:attend/global/components/loading_overlay.dart';
import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/enums/role.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  final Role role;

  const LoginPage({super.key, required this.role});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _obscure = true;
  bool _isLoggingIn = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_isLoggingIn) return;

    setState(() => _isLoggingIn = true);

    FocusScope.of(context).unfocus();

    LoadingOverlay.show(context, message: "Logging you in…");

    await Future.delayed(const Duration(milliseconds: 900));

    LoadingOverlay.hide();

    if (!mounted) return;

    // Optional: simulate invalid credentials
    // AppToast.show(
    //   context: context,
    //   message: "Invalid email or password",
    //   type: ToastType.error,
    // );
    // setState(() => _isLoggingIn = false);
    // return;

    widget.role == Role.student
        ? context.goNamed(Routes.studentHomeName)
        : context.goNamed(Routes.lecturerHomeName);

    // If you ever stay on this page (e.g. failed login), re-enable button:
    // setState(() => _isLoggingIn = false);
  }

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
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "$roleLabel login",
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
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              0,
              AppSpacing.xl,
              140, // room for bottom CTA
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Hero (smaller + intentional)
                  Center(
                    child: Image.asset(hero, height: 210, fit: BoxFit.contain),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  Text(
                    "Welcome back",
                    style: AppTextStyles.h1.copyWith(
                      fontSize: 28,
                      color: AppColors.primary,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    "Log in with your email address",
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 14.8,
                      color: AppColors.textPrimary.withOpacity(0.75),
                      fontWeight: FontWeight.w600,
                      height: 1.35,
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
                        _Field(
                          label: "Email",
                          hint: "name@gmail.com",
                          controller: _emailCtrl,
                          focusNode: _emailFocus,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          prefixIcon: Icons.alternate_email_rounded,
                          onSubmitted:
                              (_) => FocusScope.of(
                                context,
                              ).requestFocus(_passwordFocus),
                        ),
                        const SizedBox(height: AppSpacing.md),
                        _Field(
                          label: "Password",
                          hint: "Enter your password",
                          controller: _passwordCtrl,
                          focusNode: _passwordFocus,
                          keyboardType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.done,
                          prefixIcon: Icons.lock_rounded,
                          obscureText: _obscure,
                          suffixIcon:
                              _obscure
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                          onSuffixTap:
                              () => setState(() => _obscure = !_obscure),
                          onSubmitted: (_) => _login(),
                        ),

                        const SizedBox(height: AppSpacing.sm),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: forgot password later
                            },
                            child: Text(
                              "Forgot password?",
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  // Sign up redirect (kept, but calmer)
                  Center(
                    child: TextButton(
                      onPressed: () {
                        // Your route expects Role as extra.
                        context.goNamed(Routes.signUpName, extra: widget.role);
                      },
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontSize: 14.8,
                            color: AppColors.textPrimary.withOpacity(0.75),
                            fontWeight: FontWeight.w700,
                          ),
                          children: const [
                            TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: "Sign up",
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
                ],
              ),
            ),
          ),
        ],
      ),

      // ✅ Sticky bottom CTA (consistent with your newer pages)
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
              onPressed: _isLoggingIn ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                "Log in",
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
  }
}

class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final IconData prefixIcon;

  final bool obscureText;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixTap;

  final ValueChanged<String>? onSubmitted;

  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    required this.prefixIcon,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.suffixIcon,
    this.onSuffixTap,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary.withOpacity(0.70),
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          onFieldSubmitted: onSubmitted,
          style: AppTextStyles.bodyLarge.copyWith(
            fontSize: 15.5,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary.withOpacity(0.45),
              fontWeight: FontWeight.w700,
            ),
            filled: true,
            fillColor: AppColors.background,
            prefixIcon: Icon(prefixIcon, color: AppColors.primary),
            suffixIcon:
                suffixIcon == null
                    ? null
                    : IconButton(
                      icon: Icon(suffixIcon, color: AppColors.primary),
                      onPressed: onSuffixTap,
                    ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: AppColors.primary.withOpacity(0.08),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: AppColors.primary.withOpacity(0.08),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: AppColors.accent, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
