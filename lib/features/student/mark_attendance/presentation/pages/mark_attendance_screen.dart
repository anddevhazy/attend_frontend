import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:flutter/material.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen>
    with TickerProviderStateMixin {
  int currentStep = 0; // 0 = Location,  1 = Selfie, 2 = Result
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Hero
            Expanded(
              flex: 3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    AppAssets.markAttendanceHero,
                    height: 380,
                    fit: BoxFit.contain,
                  ),
                  if (currentStep == 1)
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, child) {
                        return Transform.scale(
                          scale: 1 + (_pulseController.value * 0.15),
                          child: Container(
                            width: 260,
                            height: 260,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accent.withOpacity(
                                0.15 - _pulseController.value * 0.1,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),

            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Column(
                  children: [
                    SizedBox(height: AppSpacing.xl),

                    // Title
                    Text(
                      _getTitle(),
                      style: AppTextStyles.h1.copyWith(
                        fontSize: 34,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: AppSpacing.lg),

                    // Subtitle
                    Text(
                      _getSubtitle(),
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 17,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: AppSpacing.xxl),

                    // Step indicator
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(2, (i) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 400),
                          margin: EdgeInsets.symmetric(horizontal: 6),
                          width: currentStep >= i ? 32 : 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color:
                                currentStep >= i
                                    ? AppColors.accent
                                    : AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      }),
                    ),

                    Spacer(),

                    // Action Button
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
                      child: SizedBox(
                        height: 70,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            // You will handle actual verification flow
                            if (currentStep < 3) {
                              setState(() => currentStep++);
                            } else {
                              // Navigate to success / pending / failure screen
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getButtonColor(),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 12,
                          ),
                          child: Text(
                            _getButtonText(),
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
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
      ),
    );
  }

  String _getTitle() {
    switch (currentStep) {
      case 0:
        return 'Getting Location';
      case 1:
        return 'Verify that you are who you claim you are';
      default:
        return 'Processing...';
    }
  }

  String _getSubtitle() {
    switch (currentStep) {
      case 0:
        return 'Make sure you’re inside the lecture hall geofence';
      case 1:
        return 'One quick selfie for verification';
      default:
        return 'Almost there — finalizing your attendance';
    }
  }

  String _getButtonText() {
    switch (currentStep) {
      case 0:
        return 'Location Verified';
      case 1:
        return 'Take Selfie';
      default:
        return 'Complete Attendance';
    }
  }

  Color _getButtonColor() {
    if (currentStep == 0) return AppColors.success;
    if (currentStep == 1) return AppColors.accent;
    if (currentStep == 2) return AppColors.primary;
    return AppColors.success;
  }
}
