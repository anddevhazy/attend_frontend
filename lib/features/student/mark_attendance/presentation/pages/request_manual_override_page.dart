import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:flutter/material.dart';

class RequestManualOverridePage extends StatelessWidget {
  const RequestManualOverridePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: AppColors.primary,
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Hero illustration
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xl),
              child: Image.asset(AppAssets.overrideRequestHero, height: 240),
            ),

            SizedBox(height: AppSpacing.xl),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                children: [
                  Text(
                    'Device Blocked',
                    style: AppTextStyles.h1.copyWith(
                      fontSize: 36,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: AppSpacing.lg),

                  Text(
                    "This phone is tied to another student's account.\n"
                    'To mark attendance today, send a selfie to your lecturer for manual approval.',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 17,
                      height: 1.5,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: AppSpacing.xxl),

                  // Selfie capture area
                  Text(
                    'Take a clear selfie in class',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.md),

                  Container(
                    height: 340,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: 2,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(18),
                      child: Image.asset(
                        AppAssets.overrideSelfiePlaceholder,
                        fit: BoxFit.cover,
                        color: AppColors.primary.withOpacity(0.05),
                        colorBlendMode: BlendMode.dstATop,
                      ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.lg),

                  // Retake / Capture button
                  SizedBox(
                    height: 56,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        // You will open camera
                      },
                      icon: Icon(
                        Icons.camera_alt_rounded,
                        color: AppColors.accent,
                      ),
                      label: Text(
                        'Take Selfie',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.accent, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),

            // Send Request button
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),

              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 64,
                  child: ElevatedButton(
                    onPressed: () {
                      // You will send override request with selfie
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 10,
                    ),
                    child: Text(
                      'Send Override Request',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
