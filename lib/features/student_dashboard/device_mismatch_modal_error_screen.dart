import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class DeviceMismatchModal extends StatelessWidget {
  const DeviceMismatchModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors from visual identity
    const deepNavy = Color(0xFF091E42);
    const royalPurple = Color(0xFF6A0DAD);
    const lightGray = Color(0xFFF4F6FA);
    const charcoalBlack = Color(0xFF1C1C1E);
    const emeraldGreen = Color(0xFF34C759);
    const tomatoRed = Color(0xFFFF3B30);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: lightGray,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: charcoalBlack.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Error illustration
            Image.asset(
              'assets/error_illustration.png', // Duotone error illustration
              width: 120,
              height: 120,
            ),
            const SizedBox(height: 16),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Device Mismatch',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: charcoalBlack,
                  ),
                ),
                const Text(' 🚫', style: TextStyle(fontSize: 20)),
              ],
            ),
            const SizedBox(height: 12),
            // Description
            Text(
              'The device you’re using doesn’t match the registered device. Please request a manual override or try again.',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: charcoalBlack.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            // Manual Override button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {}, // Manual override action handled by you
                style: ElevatedButton.styleFrom(
                  backgroundColor: emeraldGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  textStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FluentIcons.person_support_24_regular,
                      size: 20,
                    ), // Fluent UI support icon
                    SizedBox(width: 8),
                    Text('Request Manual Override'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Back button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {}, // Back action handled by you
                style: ElevatedButton.styleFrom(
                  backgroundColor: tomatoRed,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  textStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FluentIcons.arrow_left_24_regular,
                      size: 20,
                    ), // Fluent UI back icon
                    SizedBox(width: 8),
                    Text('Go Back'),
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
