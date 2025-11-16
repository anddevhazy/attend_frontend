import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class LiveAttendanceViewerScreen extends StatelessWidget {
  const LiveAttendanceViewerScreen({Key? key}) : super(key: key);

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
          'Live Attendance',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with session info
              Row(
                children: [
                  Text(
                    'CSC 101 - Intro to Programming',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: charcoalBlack,
                    ),
                  ),
                  const Text(' 📚', style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Session ends in: 45m 32s',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: royalPurple,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Live Check-Ins',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: charcoalBlack,
                ),
              ),
              const SizedBox(height: 12),
              // Student check-in list
              Expanded(
                child: ListView.builder(
                  itemCount: 5, // Placeholder for check-ins
                  itemBuilder: (context, index) {
                    final status =
                        [
                          'Present',
                          'Blocked',
                          'Manual Request',
                          'Present',
                          'Blocked',
                        ][index];
                    final studentName =
                        [
                          'Adebayo Oluwaseun',
                          'Chika Nwosu',
                          'Fatima Bello',
                          'Emeka Okoro',
                          'Aisha Yusuf',
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
                                : status == 'Blocked'
                                ? FluentIcons.error_circle_24_regular
                                : FluentIcons.clock_24_regular,
                            color:
                                status == 'Present'
                                    ? emeraldGreen
                                    : status == 'Blocked'
                                    ? tomatoRed
                                    : goldYellow,
                            size: 24,
                          ),
                          title: Text(
                            studentName,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: charcoalBlack,
                            ),
                          ),
                          subtitle: Text(
                            'FUNAAB/12345${index + 1}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: charcoalBlack.withOpacity(0.7),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                status == 'Present'
                                    ? '✅'
                                    : status == 'Blocked'
                                    ? '🚫'
                                    : '🕓',
                                style: const TextStyle(fontSize: 16),
                              ),
                              if (status == 'Manual Request') ...[
                                const SizedBox(width: 8),
                                Icon(
                                  FluentIcons.arrow_right_24_regular,
                                  color: royalPurple,
                                  size: 20,
                                ),
                              ],
                            ],
                          ),
                          onTap:
                              status == 'Manual Request'
                                  ? () {} // Navigation to override request handled by you
                                  : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              // End session button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {}, // End session action handled by you
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
                      Icon(
                        FluentIcons.stop_24_regular,
                        size: 20,
                      ), // Fluent UI stop icon
                      SizedBox(width: 8),
                      Text('End Session'),
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
