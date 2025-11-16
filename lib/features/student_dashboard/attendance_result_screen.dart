import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class AttendanceResultScreen extends StatelessWidget {
  const AttendanceResultScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors from visual identity
    const deepNavy = Color(0xFF091E42);
    const royalPurple = Color(0xFF6A0DAD);
    const lightGray = Color(0xFFF4F6FA);
    const charcoalBlack = Color(0xFF1C1C1E);
    const emeraldGreen = Color(0xFF34C759);
    const tomatoRed = Color(0xFFFF3B30);
    const goldYellow = Color(0xFFFFD60A);

    // Placeholder: Change to 'success', 'failure', or 'pending' for different states
    const resultStatus = 'success';

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: deepNavy,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            FluentIcons.arrow_left_24_regular, // Fluent UI back icon
            color: Colors.white,
            size: 24,
          ),
          onPressed: () {}, // Navigation handled by you
        ),
        title: Text(
          'Attendance Result',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Illustration based on status
                Image.asset(
                  resultStatus == 'success'
                      ? 'assets/success_illustration.png'
                      : resultStatus == 'failure'
                      ? 'assets/failure_illustration.png'
                      : 'assets/pending_illustration.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 24),
                // Title with emoji
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      resultStatus == 'success'
                          ? 'Attendance Marked!'
                          : resultStatus == 'failure'
                          ? 'Attendance Failed'
                          : 'Pending Approval',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: charcoalBlack,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      resultStatus == 'success'
                          ? '✅'
                          : resultStatus == 'failure'
                          ? '❌'
                          : '🕓',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Description
                Text(
                  resultStatus == 'success'
                      ? 'You’re all set! Your attendance for CSC 101 has been recorded.'
                      : resultStatus == 'failure'
                      ? 'Something went wrong. Please try again or request an override.'
                      : 'Your attendance is pending lecturer approval. You’ll be notified soon.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: charcoalBlack.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                // Action button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {}, // Navigation handled by you
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          resultStatus == 'success'
                              ? emeraldGreen
                              : resultStatus == 'failure'
                              ? tomatoRed
                              : goldYellow,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          resultStatus == 'success'
                              ? 'Back to Dashboard'
                              : resultStatus == 'failure'
                              ? 'Try Again'
                              : 'View Status',
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          resultStatus == 'success'
                              ? FluentIcons.home_24_regular
                              : resultStatus == 'failure'
                              ? FluentIcons.arrow_sync_24_regular
                              : FluentIcons.clock_24_regular,
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
      ),
    );
  }
}
