import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class SessionDetailScreen extends StatelessWidget {
  const SessionDetailScreen({Key? key}) : super(key: key);

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
          'Session Details',
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
              // Session header
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
                '2025-08-10 | 10:00 AM - 11:00 AM',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: charcoalBlack.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Location: Lecture Hall A',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: charcoalBlack.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 16),
              // Attendance summary
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildSummaryItem(
                        label: 'Present',
                        value: '25',
                        color: emeraldGreen,
                        emoji: '✅',
                      ),
                      _buildSummaryItem(
                        label: 'Missed',
                        value: '5',
                        color: tomatoRed,
                        emoji: '❌',
                      ),
                      _buildSummaryItem(
                        label: 'Pending',
                        value: '2',
                        color: goldYellow,
                        emoji: '🕓',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Attendance list
              Text(
                'Attendance Records',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: charcoalBlack,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: 5, // Placeholder for attendance records
                  itemBuilder: (context, index) {
                    final status =
                        [
                          'Present',
                          'Missed',
                          'Pending',
                          'Present',
                          'Missed',
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
              ),
              // Export button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {}, // Export action handled by you
                  style: ElevatedButton.styleFrom(
                    backgroundColor: royalPurple,
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
                        FluentIcons.arrow_export_24_regular,
                        size: 20,
                      ), // Fluent UI export icon
                      SizedBox(width: 8),
                      Text('Export Data'),
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

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required Color color,
    required String emoji,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            const SizedBox(width: 4),
            Text(emoji, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}
