import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Hide system UI for the splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    // Navigate after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;

      // Restore system UI for the rest of the app
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      // Go to onboarding
      context.goNamed(Routes.onboardingName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // Deep Navy full screen
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Hero Logo
            Image.asset(
              AppAssets.splashFingerprintPin,
              width: 180,
              height: 180,
              fit: BoxFit.contain,
            ),
            SizedBox(height: AppSpacing.xxl),

            // App Name - Poppins Bold
            Text(
              'Attend',
              style: AppTextStyles.h1.copyWith(
                fontSize: 48,
                letterSpacing: -1.5,
              ),
            ),
            SizedBox(height: AppSpacing.md),

            // Tagline
            Text(
              'Secure. Fast. Verified.',
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: AppSpacing.huge),

            // Subtle loading indicator
            SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
