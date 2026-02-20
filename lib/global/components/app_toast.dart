import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/spacing.dart';

class AppToast {
  static void show({
    required BuildContext context,
    required String message,
    required ToastType type,
    Duration duration = const Duration(seconds: 4),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 24,
            right: 24,
            child: Material(
              color: Colors.transparent,
              child: Dismissible(
                key: ValueKey(message),
                direction: DismissDirection.up,
                onDismissed: (_) => entry.remove(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.md,
                  ),
                  decoration: BoxDecoration(
                    color:
                        type == ToastType.success
                            ? AppColors.success
                            : type == ToastType.error
                            ? AppColors.error
                            : AppColors.warning,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 16,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        type == ToastType.success
                            ? Icons.check_circle_rounded
                            : type == ToastType.error
                            ? Icons.error_rounded
                            : Icons.warning_amber_rounded,
                        color: AppColors.white,
                        size: 28,
                      ),
                      SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          message,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );

    overlay.insert(entry);

    Future.delayed(duration, () {
      try {
        entry.remove();
      } catch (_) {
        // Optionally ignore any errors
      }
    });
  }
}

enum ToastType { success, error, warning }
