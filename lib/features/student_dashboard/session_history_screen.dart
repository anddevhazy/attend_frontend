import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class SessionHistoryScreen extends StatelessWidget {
  const SessionHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors from visual identity
    const deepNavy = Color(0xFF091E42);
    const royalPurple = Color(0xFF6A0DAD);
    const lightGray = Color(0xFFF4F6FA);
    const charcoalBlack = Color(0xFF1C1C1E);

    // Placeholder: No sessions (toggle to test sessions list)
    const hasSessions = true;

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
          'Session History',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child:
            hasSessions
                ? _buildSessionsView(
                  deepNavy: deepNavy,
                  royalPurple: royalPurple,
                  charcoalBlack: charcoalBlack,
                )
                : _buildNoSessionsView(
                  deepNavy: deepNavy,
                  charcoalBlack: charcoalBlack,
                ),
      ),
    );
  }

  Widget _buildSessionsView({
    required Color deepNavy,
    required Color royalPurple,
    required Color charcoalBlack,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Past Sessions',
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
          Text(
            'View or export attendance data for past sessions.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: charcoalBlack.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Placeholder for past sessions
              itemBuilder: (context, index) {
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
                        FluentIcons
                            .history_24_regular, // Fluent UI history icon
                        color: charcoalBlack,
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
                        '2025-08-${10 + index} | 10:00 AM - 11:00 AM',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: charcoalBlack.withOpacity(0.7),
                        ),
                      ),
                      trailing: Icon(
                        FluentIcons
                            .arrow_right_24_regular, // Fluent UI arrow icon
                        color: royalPurple,
                        size: 20,
                      ),
                      onTap:
                          () {}, // Navigation to session details handled by you
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoSessionsView({
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
              'assets/no_sessions_illustration.png', // Duotone illustration
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'No Past Sessions',
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
              'No past sessions found. Create a new session to start tracking attendance.',
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
