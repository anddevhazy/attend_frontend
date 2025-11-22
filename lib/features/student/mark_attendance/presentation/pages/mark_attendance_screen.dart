// lib/features/student/mark_attendance_screen.dart
import 'package:attend/global/components/app_toast.dart';
import 'package:attend/global/components/loading_overlay.dart';
import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({super.key});

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen>
    with TickerProviderStateMixin {
  int currentStep = 0; // 0 = Selfie, 1 = Processing
  late AnimationController _pulseController;
  String? _selfiePath;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();

    // Simulate location check on open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _simulateLocationCheck();
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  // LOCATION SIMULATION — UNCOMMENT ONLY ONE
  void _simulateLocationCheck() async {
    LoadingOverlay.show(context);
    await Future.delayed(Duration(seconds: 2));
    LoadingOverlay.hide();

    // SUCCESS
    AppToast.show(
      context: context,
      message: "Location feched!",
      type: ToastType.success,
    );

    // FAILURE — UNCOMMENT TO TEST
    // AppToast.show(
    //   context: context,
    //   message: "Couldn’t fetch your location",
    //   type: ToastType.error,
    // );
    // await Future.delayed(Duration(seconds: 2));
    // if (mounted) Navigator.pop(context);
  }

  void _simulateTakeSelfie() async {
    LoadingOverlay.show(context);
    await Future.delayed(Duration(seconds: 2));
    LoadingOverlay.hide();

    setState(() {
      _selfiePath = AppAssets.overrideSelfiePlaceholder;
    });
  }

  void _retakeSelfie() => setState(() => _selfiePath = null);

  // FINAL SUBMISSION — UNCOMMENT ONLY ONE BLOCK
  void _completeAttendance() async {
    setState(() => currentStep = 1);
    await Future.delayed(Duration(seconds: 2));

    // 1. SUCCESS — You're in!
    // AppToast.show(
    //   context: context,
    //   message: "Attendance Marked Successfully!",
    //   type: ToastType.success,
    // );
    // await Future.delayed(Duration(seconds: 2));
    // if (mounted) context.goNamed(Routes.studentHomeName);

    // 2. DEVICE BLOCKED — Override required
    AppToast.show(
      context: context,
      message: "This isn't your phone — override required",
      type: ToastType.error,
    );
    await Future.delayed(Duration(seconds: 3));
    if (mounted) context.goNamed(Routes.requestManualOverrideName);

    // 3. NO NETWORK
    // AppToast.show(
    //   context: context,
    //   message: "No internet connection",
    //   type: ToastType.error,
    // );

    // 4. SERVER ERROR
    // AppToast.show(
    //   context: context,
    //   message: "Server error — try again later",
    //   type: ToastType.error,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          // This saves you!
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              // Hero Section
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    AppAssets.markAttendanceHero,
                    height: 320,
                    fit: BoxFit.contain,
                  ),
                  if (currentStep == 0 && _selfiePath == null)
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder:
                          (_, child) => Transform.scale(
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
                          ),
                    ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),

              // Title
              // Title & Subtitle
              //
              Text(
                currentStep == 0
                    ? (_selfiePath == null ? "One quick selfie" : "Looks good!")
                    : "Processing...",
                style: AppTextStyles.h1.copyWith(
                  fontSize: 34,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.lg),

              Text(
                currentStep == 0
                    ? (_selfiePath == null
                        ? "We need to verify it’s really you in class"
                        : "Your selfie is clear and well-lit")
                    : "Finalizing your attendance...",
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 17,
                  height: 1.5,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Selfie Preview + Buttons
              if (_selfiePath != null && currentStep == 0) ...[
                Container(
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accent, width: 3),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(_selfiePath!, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _retakeSelfie,
                        child: const Text("Retake"),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: ElevatedButton(
                        // onPressed: () => setState(() => currentStep = 1),
                        onPressed: _completeAttendance,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: const Text(
                          "Use This",
                          style: TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xxl),
              ] else
                const SizedBox(height: AppSpacing.xl),

              // Main Action Button (fixed at bottom with padding)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.xl,
                  AppSpacing.xl,
                  AppSpacing.xxl + 20, // extra bottom space for small devices
                ),
                child: SizedBox(
                  height: 70,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        currentStep == 1
                            ? null
                            : (_selfiePath == null
                                ? _simulateTakeSelfie
                                : _completeAttendance),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          currentStep == 0
                              ? AppColors.accent
                              : AppColors.success,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 12,
                    ),
                    child: Text(
                      currentStep == 1
                          ? "Please wait..."
                          : (_selfiePath == null
                              ? "Take Selfie"
                              : "Complete Attendance"),
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
    );
  }
}
