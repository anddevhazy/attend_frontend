import 'package:attend/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/enums/role.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is Successful) {
            context.goNamed(Routes.lecturerHomeName);
          }

          if (state is Failed) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is Loading;

          return SafeArea(
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
                        onTap:
                            isLoading
                                ? null
                                : () {
                                  context
                                      .read<AuthCubit>()
                                      .continueWithGoogle();
                                },
                        borderRadius: BorderRadius.circular(18),
                        child:
                            isLoading
                                ? const CircularProgressIndicator()
                                : SvgPicture.asset(
                                  AppAssets.googleContinueButton,
                                ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
