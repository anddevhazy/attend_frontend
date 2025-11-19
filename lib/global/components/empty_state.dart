import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/spacing.dart';

class EmptyState extends StatelessWidget {
  final String illustration;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    required this.illustration,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(illustration, height: 240),
            SizedBox(height: AppSpacing.xxl),
            Text(
              title,
              style: AppTextStyles.h1.copyWith(
                fontSize: 30,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: AppSpacing.lg),
              Text(
                subtitle!,
                style: AppTextStyles.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null) ...[
              SizedBox(height: AppSpacing.xl),
              ElevatedButton(onPressed: onAction, child: Text(actionText!)),
            ],
          ],
        ),
      ),
    );
  }
}
