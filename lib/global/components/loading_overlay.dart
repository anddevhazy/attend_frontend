import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/spacing.dart';

class LoadingOverlay {
  static OverlayEntry? _entry;

  static void show(BuildContext context) {
    if (_entry?.mounted ?? false) return;

    _entry = OverlayEntry(
      builder:
          (_) => Container(
            color: Colors.black.withOpacity(0.5),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(AppSpacing.xxl),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.accent),
                  strokeWidth: 5,
                ),
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_entry!);
  }

  static void hide() {
    if (_entry?.mounted ?? false) {
      _entry!.remove();
      _entry = null; // Reset so we can show again later
    }
  }
}
