import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors from visual identity
    const deepNavy = Color(0xFF091E42);
    const royalPurple = Color(0xFF6A0DAD);
    const lightGray = Color(0xFFF4F6FA);
    const charcoalBlack = Color(0xFF1C1C1E);
    const emeraldGreen = Color(0xFF34C759);
    const tomatoRed = Color(0xFFFF3B30);

    return Scaffold(
      backgroundColor: lightGray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Illustration
              Image.asset(
                'assets/no_internet_illustration.png', // Duotone no internet illustration
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 24),
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No Internet Connection',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: charcoalBlack,
                    ),
                  ),
                  const Text(' 📡', style: TextStyle(fontSize: 20)),
                ],
              ),
              const SizedBox(height: 12),
              // Message
              Text(
                'Please check your connection and try again or proceed offline.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: charcoalBlack.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 32),
              // Retry button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {}, // Retry action handled by you
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
                      Icon(
                        FluentIcons.arrow_sync_24_regular,
                        size: 20,
                      ), // Fluent UI retry icon
                      SizedBox(width: 8),
                      Text('Retry Connection'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Proceed Offline button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {}, // Offline action handled by you
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
                        FluentIcons.cloud_off_24_regular,
                        size: 20,
                      ), // Fluent UI offline icon
                      SizedBox(width: 8),
                      Text('Proceed Offline'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Back to Login link
              GestureDetector(
                onTap: () {}, // Navigation to login handled by you
                child: Text(
                  'Back to Login',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: royalPurple,
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
