import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      image: AppAssets.onboarding1,
      title: 'Secure Attendance\nin Seconds',
      subtitle:
          'Biometric + GPS verification ensures only you can mark present — no proxies, no excuses.',
    ),
    _OnboardingPageData(
      image: AppAssets.onboarding2,
      title: 'Lecturers Stay\nin Control',
      subtitle:
          'Start sessions instantly. See who’s really in class. Approve exceptions with a selfie check.',
    ),
    _OnboardingPageData(
      image: AppAssets.onboarding3,
      title: 'Never Miss a Class\nAgain',
      subtitle:
          'Real-time dashboard. Instant feedback. Peace of mind for you and your lecturer.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // navigation to role selection
                  context.goNamed(Routes.roleSelectionName);
                },
                child: Text(
                  'Skip',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xl,
                    ),
                    child: Column(
                      children: [
                        const Spacer(flex: 2),

                        // Illustration
                        Image.asset(
                          page.image,
                          height: 320,
                          fit: BoxFit.contain,
                        ),

                        const Spacer(flex: 2),

                        // Title
                        Text(
                          page.title,
                          style: AppTextStyles.h1.copyWith(
                            fontSize: 32,
                            height: 1.2,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        SizedBox(height: AppSpacing.lg),

                        // Subtitle
                        Text(
                          page.subtitle,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textPrimary.withOpacity(0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const Spacer(flex: 3),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Page Indicator + Next Button Row
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                0,
                AppSpacing.xl,
                AppSpacing.xxl,
              ),
              child: Row(
                children: [
                  // Dots
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(right: 8),
                        width: _currentPage == i ? 24 : 8,
                        height: AppSpacing.pageIndicatorHeight,
                        decoration: BoxDecoration(
                          color:
                              _currentPage == i
                                  ? AppColors.accent
                                  : AppColors.accent.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Next / Get Started Button
                  SizedBox(
                    height: 56,
                    width: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == _pages.length - 1) {
                          // navigation to Role Selection
                          context.goNamed(Routes.roleSelectionName);
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        shape: const CircleBorder(),
                        elevation: 4,
                      ),
                      child: Icon(
                        _currentPage == _pages.length - 1
                            ? Icons.check
                            : Icons.arrow_forward,
                        color: AppColors.white,
                        size: 28,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final String image;
  final String title;
  final String subtitle;

  _OnboardingPageData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
