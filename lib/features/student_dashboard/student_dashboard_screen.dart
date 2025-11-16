import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors from visual identity
    const deepNavy = Color(0xFF091E42);
    const royalPurple = Color(0xFF6A0DAD);
    const lightGray = Color(0xFFF4F6FA);
    const charcoalBlack = Color(0xFF1C1C1E);
    const emeraldGreen = Color(0xFF34C759);

    // Placeholder: No active session (toggle to test active session UI)
    const hasActiveSession = false;

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: deepNavy,
        elevation: 0,
        title: Text(
          'Attend',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              FluentIcons.person_24_regular, // Fluent UI profile icon
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {}, // Navigation to profile handled by you
          ),
        ],
      ),
      body: SafeArea(
        child:
            hasActiveSession
                ? _buildActiveSessionView(
                  deepNavy: deepNavy,
                  royalPurple: royalPurple,
                  charcoalBlack: charcoalBlack,
                  emeraldGreen: emeraldGreen,
                )
                : _buildNoActiveSessionView(
                  deepNavy: deepNavy,
                  charcoalBlack: charcoalBlack,
                ),
      ),
    );
  }

  Widget _buildActiveSessionView({
    required Color deepNavy,
    required Color royalPurple,
    required Color charcoalBlack,
    required Color emeraldGreen,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Active Class',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: charcoalBlack,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'CSC 101 - Intro to Programming',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: charcoalBlack,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('📚', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Lecturer: Dr. John Adebayo',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: charcoalBlack.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        FluentIcons.clock_24_regular, // Fluent UI clock icon
                        size: 20,
                        color: royalPurple,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Ends in: 45m 32s',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: royalPurple,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          () {}, // Navigation to mark attendance handled by you
                      style: ElevatedButton.styleFrom(
                        backgroundColor: emeraldGreen,
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
                          Text('Mark Attendance'),
                          SizedBox(width: 8),
                          Icon(
                            FluentIcons
                                .checkmark_circle_24_regular, // Fluent UI check icon
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoActiveSessionView({
    required Color deepNavy,
    required Color charcoalBlack,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/no_class_illustration.png', // Duotone illustration
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No Active Class',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: charcoalBlack,
                  ),
                ),
                const SizedBox(width: 8),
                const Text('😴', style: TextStyle(fontSize: 20)),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'There are no ongoing classes for your courses right now.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: charcoalBlack.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
