import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class SelfieCaptureScreen extends StatelessWidget {
  const SelfieCaptureScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors from visual identity
    const deepNavy = Color(0xFF091E42);
    const royalPurple = Color(0xFF6A0DAD);
    const lightGray = Color(0xFFF4F6FA);
    const charcoalBlack = Color(0xFF1C1C1E);
    const emeraldGreen = Color(0xFF34C759);
    const tomatoRed = Color(0xFFFF3B30);

    // Placeholder: Simulate whether a selfie has been captured
    const hasCapturedSelfie = false;

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
          'Capture Selfie',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Take a Selfie',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: charcoalBlack,
                    ),
                  ),
                  const Text(' 📸', style: TextStyle(fontSize: 18)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Ensure your face is clearly visible for verification.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: charcoalBlack.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              // Camera preview or captured selfie
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                color: Colors.white,
                child: Container(
                  height: 350,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: lightGray,
                  ),
                  child:
                      hasCapturedSelfie
                          ? Image.asset(
                            'assets/selfie_placeholder.png', // Placeholder for captured selfie
                            fit: BoxFit.cover,
                          )
                          : Center(
                            child: Text(
                              'Camera Preview', // Placeholder for live camera feed
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: charcoalBlack.withOpacity(0.7),
                              ),
                            ),
                          ),
                ),
              ),
              const SizedBox(height: 24),
              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          hasCapturedSelfie
                              ? () {}
                              : null, // Retake action handled by you
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            hasCapturedSelfie
                                ? tomatoRed
                                : tomatoRed.withOpacity(0.5),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        textStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FluentIcons.camera_24_regular,
                            size: 20,
                          ), // Fluent UI camera icon
                          SizedBox(width: 8),
                          Text('Retake'),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {}, // Capture action handled by you
                      style: ElevatedButton.styleFrom(
                        backgroundColor: royalPurple,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                        textStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FluentIcons.camera_24_regular,
                            size: 20,
                          ), // Fluent UI camera icon
                          SizedBox(width: 8),
                          Text('Capture'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Continue button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed:
                      hasCapturedSelfie
                          ? () {}
                          : null, // Continue action handled by you
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        hasCapturedSelfie
                            ? emeraldGreen
                            : emeraldGreen.withOpacity(0.5),
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
