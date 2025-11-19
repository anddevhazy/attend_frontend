import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:flutter/material.dart';

class StudentCourseSelectionPage extends StatefulWidget {
  const StudentCourseSelectionPage({super.key});

  @override
  State<StudentCourseSelectionPage> createState() =>
      _StudentCourseSelectionPageState();
}

class _StudentCourseSelectionPageState
    extends State<StudentCourseSelectionPage> {
  // I will replace with real data from backend
  final List<Map<String, dynamic>> availableCourses = [
    {
      'code': 'CSC 301',
      'title': 'Data Structures & Algorithms',
      'lecturer': 'Dr. Adebayo',
      'selected': false,
    },
    {
      'code': 'MTH 305',
      'title': 'Linear Algebra II',
      'lecturer': 'Prof. Okafor',
      'selected': false,
    },
    {
      'code': 'PHY 302',
      'title': 'Electromagnetism',
      'lecturer': 'Dr. Eze',
      'selected': false,
    },
    {
      'code': 'CHM 304',
      'title': 'Organic Chemistry II',
      'lecturer': 'Dr. Ibrahim',
      'selected': false,
    },
  ];

  int selectedCount = 0;

  @override
  Widget build(BuildContext context) {
    final selectedCourses =
        availableCourses.where((c) => c['selected'] as bool).toList();
    selectedCount = selectedCourses.length;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppSpacing.lg),

                  // Hero
                  Center(
                    child: Image.asset(
                      AppAssets.courseSelectionHero,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),

                  SizedBox(height: AppSpacing.xxl),

                  Text(
                    'Select Your Courses',
                    style: AppTextStyles.h1.copyWith(
                      fontSize: 34,
                      color: AppColors.primary,
                    ),
                  ),

                  SizedBox(height: AppSpacing.md),

                  Text(
                    'Choose all courses you’re offering  this semester',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary.withOpacity(0.85),
                    ),
                  ),

                  SizedBox(height: AppSpacing.xl),
                ],
              ),
            ),

            // Course List
            Expanded(
              child:
                  availableCourses.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              AppAssets.emptyCoursesIllustration,
                              height: 180,
                            ),
                            SizedBox(height: AppSpacing.xl),
                            Text(
                              'No courses found 😴',
                              style: AppTextStyles.h2.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl,
                        ),
                        itemCount: availableCourses.length,
                        separatorBuilder:
                            (_, __) => SizedBox(height: AppSpacing.md),
                        itemBuilder: (context, index) {
                          final course = availableCourses[index];
                          final bool isSelected = course['selected'] as bool;

                          return _CourseTile(
                            code: course['code'] as String,
                            title: course['title'] as String,
                            lecturer: course['lecturer'] as String,
                            isSelected: isSelected,
                            onTap: () {
                              setState(() {
                                availableCourses[index]['selected'] =
                                    !isSelected;
                              });
                            },
                          );
                        },
                      ),
            ),

            // Bottom sticky bar
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Text(
                      '$selectedCount selected',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed:
                            selectedCount > 0
                                ? () {
                                  // You will save courses & go to dashboard
                                }
                                : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: AppColors.primary
                              .withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                          ),
                          child: Text(
                            'Continue',
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
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

class _CourseTile extends StatelessWidget {
  final String code;
  final String title;
  final String lecturer;
  final bool isSelected;
  final VoidCallback onTap;

  const _CourseTile({
    required this.code,
    required this.title,
    required this.lecturer,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color:
          isSelected ? AppColors.accent.withOpacity(0.1) : AppColors.background,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? AppColors.accent
                          : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isSelected ? Icons.check : Icons.book_outlined,
                  color: isSelected ? AppColors.white : AppColors.primary,
                  size: 28,
                ),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      code,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color:
                    isSelected
                        ? AppColors.accent
                        : AppColors.primary.withOpacity(0.4),
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
