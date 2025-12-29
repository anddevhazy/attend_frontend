import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:flutter/material.dart';

class RoleCardWidget extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const RoleCardWidget({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(24),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.lg), // tighter than xl
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primary.withOpacity(0.06)),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 10),
                color: AppColors.primary.withOpacity(0.06),
              ),
            ],
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [color.withOpacity(0.10), color.withOpacity(0.04)],
            ),
          ),
          child: Row(
            children: [
              // Illustration (reduced height)
              ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.asset(
                  image,
                  width: 110,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: AppSpacing.lg),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.h2.copyWith(
                        fontSize: 24,
                        color: color,
                        height: 1.05,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 14.5,
                        height: 1.35,
                        color: AppColors.textPrimary.withOpacity(0.82),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.md),
              Icon(Icons.arrow_forward_ios_rounded, color: color, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
