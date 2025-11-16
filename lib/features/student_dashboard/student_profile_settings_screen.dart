import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({Key? key}) : super(key: key);

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
          'Profile & Settings',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: lightGray,
                          border: Border.all(color: royalPurple, width: 2),
                        ),
                        child: Image.asset(
                          'assets/profile_placeholder.png', // Duotone profile illustration
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Adebayo Oluwaseun',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: charcoalBlack,
                        ),
                      ),
                      Text(
                        'FUNAAB/123456',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: charcoalBlack.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        '300 Level, Computer Science',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: charcoalBlack.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                // Attendance records header
                Row(
                  children: [
                    Text(
                      'Attendance Records',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: charcoalBlack,
                      ),
                    ),
                    const Text(' 📜', style: TextStyle(fontSize: 18)),
                  ],
                ),
                const SizedBox(height: 12),
                // Attendance records list
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 5, // Placeholder for records
                  itemBuilder: (context, index) {
                    final status =
                        [
                          'Present',
                          'Missed',
                          'Pending',
                          'Present',
                          'Missed',
                        ][index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        color: Colors.white,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          leading: Icon(
                            status == 'Present'
                                ? FluentIcons.checkmark_circle_24_regular
                                : status == 'Missed'
                                ? FluentIcons.error_circle_24_regular
                                : FluentIcons.clock_24_regular,
                            color:
                                status == 'Present'
                                    ? emeraldGreen
                                    : status == 'Missed'
                                    ? tomatoRed
                                    : goldYellow,
                            size: 24,
                          ),
                          title: Text(
                            'CSC 101 - Intro to Programming',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: charcoalBlack,
                            ),
                          ),
                          subtitle: Text(
                            'Date: 2025-08-${10 + index}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: charcoalBlack.withOpacity(0.7),
                            ),
                          ),
                          trailing: Text(
                            status == 'Present'
                                ? '✅'
                                : status == 'Missed'
                                ? '❌'
                                : '🕓',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Logout button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {}, // Logout navigation handled by you
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tomatoRed,
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
                        Icon(FluentIcons.sign_out_24_regular, size: 20),
                        SizedBox(width: 8),
                        Text('Logout'),
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
