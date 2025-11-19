import 'package:attend/global/components/app_dialog.dart';
import 'package:attend/global/components/app_toast.dart';
import 'package:attend/global/components/empty_state.dart';
import 'package:attend/global/components/loading_overlay.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:go_router/go_router.dart';

class StudentCourseSelectionPage extends StatefulWidget {
  const StudentCourseSelectionPage({super.key});

  @override
  State<StudentCourseSelectionPage> createState() =>
      _StudentCourseSelectionPageState();
}

class _StudentCourseSelectionPageState
    extends State<StudentCourseSelectionPage> {
  // Simulate logged-in user
  final String userEmail = "Elijah@gmail.com";

  // Simulated selected courses (user adds via search)
  final List<String> selectedCourses = [
    "CSC 301 – Data Structures & Algorithms",
    "MTH 305 – Linear Algebra II",
  ];

  // Search controller
  final TextEditingController _searchController = TextEditingController();

  // Simulated search results (in real app: API call)
  final List<String> mockSearchResults = [
    "CSC 301 – Data Structures & Algorithms",
    "MTH 305 – Linear Algebra II",
    "PHY 302 – Electromagnetism",
    "CHM 304 – Organic Chemistry II",
    "GST 301 – Entrepreneurship",
    "BIO 201 – Genetics",
  ];

  // Add this method inside _StudentSignUpPageState
  Future<void> _simulateCourseSelectionSubmission() async {
    // 1. Show loading
    LoadingOverlay.show(context);

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    // === SIMULATED SCENARIOS (uncomment ONE at a time to test) ===

    // Scenario 1: Network unavailable
    // LoadingOverlay.hide();
    // AppToast.show(
    //   context: context,
    //   message: "No internet connection",
    //   type: ToastType.error,
    // );
    // return;

    // Scenario 2: API failure (500)
    // LoadingOverlay.hide();
    // AppToast.show(
    //   context: context,
    //   message: "Server error. Try again later",
    //   type: ToastType.error,
    // );
    // return;

    // Scenario 4: Unexpected error (e.g. JSON parse fail)
    // LoadingOverlay.hide();
    // AppToast.show(
    //   context: context,
    //   message: "Something went wrong. Please try again",
    //   type: ToastType.error,
    // );
    // return;

    // // Scenario 5: SUCCESS → Course Selection Submitted created!
    LoadingOverlay.hide();
    AppToast.show(
      context: context,
      message: "Courses Successfully Selected",
      type: ToastType.success,
    );

    // Navigate after celebration
    await Future.delayed(const Duration(seconds: 3));
    context.goNamed(Routes.studentDashboardName);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // This prevents back navigation AND swipe-back gesture
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        // Optional: Ask "Exit app?" only if they try to go back
        _showExitConfirmation(context);
      },
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false, // Removes back arrow completely
          title: Text(
            "Welcome $userEmail",
            style: AppTextStyles.h2.copyWith(
              fontSize: 20,
              color: AppColors.primary,
            ),
          ),
          // actions: [
          //   // Optional: Add a close icon that triggers exit confirmation
          //   IconButton(
          //     icon: Icon(Icons.close_rounded, color: AppColors.primary),
          //     onPressed: () => _showExitConfirmation(context),
          //   ),
          // ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Hero
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: Image.asset(
                  AppAssets.courseSelectionHero,
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(height: AppSpacing.xl),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Text(
                  'Add Your Courses',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 32,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: AppSpacing.md),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Text(
                  'Search and add all courses you’re offering this semester',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary.withOpacity(0.85),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: AppSpacing.xxl),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search courses... e.g. CSC 301',
                    hintStyle: AppTextStyles.inputHint,
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.accent,
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) => setState(() {}), // Trigger rebuild
                ),
              ),

              SizedBox(height: AppSpacing.lg),

              // Selected Courses List
              Expanded(
                child:
                    selectedCourses.isEmpty
                        ? EmptyState(
                          illustration: AppAssets.emptyCoursesIllustration,
                          title: "No courses added yet",
                          subtitle:
                              "Search and tap to add your registered courses",
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.xl,
                          ),
                          itemCount: selectedCourses.length,
                          itemBuilder: (context, index) {
                            final course = selectedCourses[index];
                            return _SelectedCourseTile(
                              course: course,
                              onRemove: () {
                                setState(() {
                                  selectedCourses.removeAt(index);
                                });
                              },
                            );
                          },
                        ),
              ),

              // Continue Button
              Container(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    height: 58,
                    child: ElevatedButton(
                      onPressed:
                          selectedCourses.isNotEmpty
                              ? () => _showConfirmationDialog(context)
                              : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.primary.withOpacity(
                          0.3,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'Sumbit Selections',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontSize: 18,
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
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    AppDialog.confirm(
      context: context,
      title: "Confirm Courses",
      message:
          "You selected ${selectedCourses.length} course(s):\n\n${selectedCourses.join('\n')}\n\nThis cannot be changed later without contacting support.",
      confirmText: "Yes, Submit",
      cancelText: "Edit List",
    ).then((confirmed) {
      if (confirmed == true) {
        _simulateCourseSelectionSubmission();
      }
    });
  }

  void _showExitConfirmation(BuildContext context) {
    AppDialog.confirm(
      context: context,
      title: "Exit App?",
      message:
          "You haven't completed course selection.\n\nAre you sure you want to exit?",
      confirmText: "Stay",
      cancelText: "Exit App",
    ).then((exit) {
      if (exit == true) {
        Navigator.of(
          context,
        ).popUntil((route) => route.isFirst); // Or SystemNavigator.pop()
      }
    });
  }
}

// Selected Course Tile
class _SelectedCourseTile extends StatelessWidget {
  final String course;
  final VoidCallback onRemove;

  const _SelectedCourseTile({required this.course, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSpacing.md),
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, color: AppColors.accent),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              course,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close_rounded, color: AppColors.error),
            onPressed: onRemove,
          ),
        ],
      ),
    );
  }
}
