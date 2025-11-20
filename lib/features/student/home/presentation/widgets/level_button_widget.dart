import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:flutter/material.dart';

class LevelButtonWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const LevelButtonWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.transparent,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.h2.copyWith(
            fontSize: 20,
            color: isSelected ? AppColors.white : AppColors.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
