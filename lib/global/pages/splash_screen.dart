import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/enums/role.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:attend/global/storage/token_storage.dart';
import 'package:attend/service_locator.dart';
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
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    Future.delayed(const Duration(milliseconds: 2500), () async {
      if (!mounted) return;
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

      final tokenStorage = sl<TokenStorage>();
      final accessToken = await tokenStorage.getAccessToken();
      final refreshToken = await tokenStorage.getRefreshToken();

      if (!mounted) return;

      if (accessToken != null && refreshToken != null) {
        // Already logged in — go straight to lecturer home (or check role)
        context.goNamed(Routes.lecturerHomeName);
      } else {
        context.goNamed(Routes.loginName, extra: Role.lecturer);
      }
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
