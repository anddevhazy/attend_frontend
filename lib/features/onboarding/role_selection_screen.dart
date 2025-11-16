import 'package:attend/features/app/app_colors.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGray,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.all(24.r),
                child: SvgPicture.asset('assets/logo.svg', fit: BoxFit.contain),
              ),
              SizedBox(height: 24.h),
              Text(
                'Select Your Role To Get Started.... 😊',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: charcoalBlack,
                ),
              ),
              SizedBox(height: 32.h),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Card(
                    elevation: 2.h,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    color: whiteColor,
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(24.r),
                            child: SvgPicture.asset(
                              'assets/student_illustration.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Student 📚',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: charcoalBlack,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Mark your attendance and track your records',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: charcoalBlack.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Card(
                    elevation: 2.h,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    color: whiteColor,
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(24.r),
                            child: SvgPicture.asset(
                              'assets/lecturer_illustration.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'Lecturer 📚',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: charcoalBlack,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Manage sessions and review attendance.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400,
                              color: charcoalBlack.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 8.h),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      null, // Disabled state, enable via state management
                  style: ElevatedButton.styleFrom(
                    backgroundColor: emeraldGreen.withOpacity(0.5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    textStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continue'),
                      SizedBox(width: 8),
                      Icon(
                        FluentIcons.arrow_right_24_regular,
                        size: 20,
                      ), // Fluent UI arrow icon
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
