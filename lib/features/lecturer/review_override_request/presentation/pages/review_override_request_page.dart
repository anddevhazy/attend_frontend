import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:flutter/material.dart';

class ReviewOverrideRequestPage extends StatelessWidget {
  const ReviewOverrideRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Review Override Requests',
          style: AppTextStyles.h2.copyWith(
            fontSize: 22,
            color: AppColors.primary,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Hero
            Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Image.asset(AppAssets.overrideReviewHero, height: 180),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                children: [
                  // Request Card
                  _StudentRequestCard(),

                  SizedBox(height: AppSpacing.xxl),

                  // Selfie Comparison
                  Text(
                    'Selfie Verification',
                    style: AppTextStyles.h2.copyWith(
                      fontSize: 24,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: _SelfieBox(
                          title: 'Current Request',
                          image: AppAssets.studentSelfieSample,
                        ),
                      ),
                      SizedBox(width: AppSpacing.lg),
                      Expanded(
                        child: _SelfieBox(
                          title: 'Previous Owner',
                          image: AppAssets.previousOwnerSelfieSample,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.xxl),

                  // Device Info
                  _InfoBox(
                    title: 'Device Previously Tied To',
                    content:
                        'Chukwuemeka Okonkwo\n19/ENG/00241\nLast used: 14 Nov 2025',
                  ),

                  SizedBox(height: AppSpacing.xl),

                  _InfoBox(
                    title: 'Current Student',
                    content:
                        'Aisha Ibrahim\n21/SCI/00817\nRequest time: Today 09:42 AM',
                    highlight: true,
                  ),

                  SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),

            // Decision Buttons
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: 64,
                        child: OutlinedButton(
                          onPressed: () {
                            // You will DENY override
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: AppColors.error,
                              width: 2.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Deny',
                            style: AppTextStyles.h2.copyWith(
                              fontSize: 20,
                              color: AppColors.error,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: SizedBox(
                        height: 64,
                        child: ElevatedButton(
                          onPressed: () {
                            // You will APPROVE override
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 10,
                          ),
                          child: Text(
                            'Approve',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: AppColors.white,
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
}

class _StudentRequestCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.4), width: 2),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: AssetImage(AppAssets.studentSelfieSample),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Aisha Ibrahim',
            style: AppTextStyles.h1.copyWith(
              fontSize: 28,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            '21/SCI/00817',
            style: AppTextStyles.bodyLarge.copyWith(color: AppColors.accent),
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.15),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              'Device Mismatch • Override Requested',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.warning,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SelfieBox extends StatelessWidget {
  final String title;
  final String image;

  const _SelfieBox({required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            image,
            height: 180,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ],
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String content;
  final bool highlight;

  const _InfoBox({
    required this.title,
    required this.content,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: highlight ? AppColors.accent.withOpacity(0.08) : AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              highlight
                  ? AppColors.accent
                  : AppColors.primary.withOpacity(0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.primary.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 8),
          Text(
            content,
            style: AppTextStyles.bodyLarge.copyWith(
              height: 1.4,
              color: AppColors.textPrimary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
