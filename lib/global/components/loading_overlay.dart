import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';
import '../constants/text_styles.dart';

class LoadingOverlay {
  static OverlayEntry? _entry;

  static void show(BuildContext context, {String? message}) {
    if (_entry?.mounted ?? false) return;

    _entry = OverlayEntry(
      builder:
          (_) => Material(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xxl,
                  vertical: AppSpacing.xl,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 42,
                      height: 42,
                      child: CircularProgressIndicator(
                        strokeWidth: 4,
                        valueColor: AlwaysStoppedAnimation(AppColors.accent),
                      ),
                    ),

                    if (message != null) ...[
                      const SizedBox(height: AppSpacing.lg),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  static void hide() {
    if (_entry?.mounted ?? false) {
      _entry!.remove();
      _entry = null;
    }
  }
}
