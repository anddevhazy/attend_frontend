import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class LecturerDashboardScreen extends StatelessWidget {
  const LecturerDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors from visual identity
    const deepNavy = Color(0xFF091E42);
    const royalPurple = Color(0xFF6A0DAD);
    const lightGray = Color(0xFFF4F6FA);
    const charcoalBlack = Color(0xFF1C1C1E);
    const emeraldGreen = Color(0xFF34C759);

    // Placeholder: No sessions (toggle to test sessions list)
    const hasSessions = true;

    return Scaffold(
      backgroundColor: lightGray,
      appBar: AppBar(
        backgroundColor: deepNavy,
        elevation: 0,
        title: Text(
          'Lecturer Dashboard',
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
            hasSessions
                ? _buildSessionsView(
                  deepNavy: deepNavy,
                  royalPurple: royalPurple,
                  charcoalBlack: charcoalBlack,
                  emeraldGreen: emeraldGreen,
                )
                : _buildNoSessionsView(
                  deepNavy: deepNavy,
                  charcoalBlack: charcoalBlack,
                ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // Navigation to create session handled by you
        backgroundColor: royalPurple,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(
          FluentIcons.add_24_regular, // Fluent UI add icon
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildSessionsView({
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
          Row(
            children: [
              Text(
                'Your Sessions',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: charcoalBlack,
                ),
              ),
              const Text(' 📅', style: TextStyle(fontSize: 18)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'View active and past attendance sessions.',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: charcoalBlack.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: 4, // Placeholder for sessions
              itemBuilder: (context, index) {
                final isActive = index == 0; // First session is active
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
                        isActive
                            ? FluentIcons.live_24_regular
                            : FluentIcons.history_24_regular,
                        color:
                            isActive
                                ? emeraldGreen
                                : charcoalBlack.withOpacity(0.7),
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
                        isActive
                            ? 'Active - Ends in 45m'
                            : '2025-08-${10 + index} - Completed',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: charcoalBlack.withOpacity(0.7),
                        ),
                      ),
                      trailing: Icon(
                        FluentIcons.arrow_right_24_regular,
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
                  'No Sessions',
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
              'No attendance sessions created yet. Tap the + button to start a new session.',
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
