import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors from visual identity
    const deepNavy = Color(0xFF091E42);
    const royalPurple = Color(0xFF6A0DAD);
    const lightGray = Color(0xFFF4F6FA);
    const charcoalBlack = Color(0xFF1C1C1E);
    const emeraldGreen = Color(0xFF34C759);

    // Placeholder data for carousel
    final features = [
      {
        'image': 'assets/onboarding_1.png',
        'title': 'Track Attendance',
        'description': 'Mark your presence effortlessly with our smart system.',
        'emoji': '✅',
      },
      {
        'image': 'assets/onboarding_2.png',
        'title': 'Geofencing',
        'description':
            'Ensure you’re in the right place with location verification.',
        'emoji': '📍',
      },
      {
        'image': 'assets/onboarding_3.png',
        'title': 'Secure Verification',
        'description': 'Use biometrics for fast and secure attendance.',
        'emoji': '🔒',
      },
    ];

    return Scaffold(
      backgroundColor: lightGray,
      body: SafeArea(
        child: Column(
          children: [
            // Logo header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Image.asset(
                'assets/logo.png', // Fingerprint + location pin SVG
                width: 60,
                height: 60,
              ),
            ),
            // Carousel
            Expanded(
              child: PageView.builder(
                itemCount: features.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Feature illustration
                        Image.asset(
                          features[index]['image']!,
                          width: 200,
                          height: 200,
                        ),
                        const SizedBox(height: 24),
                        // Feature title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              features[index]['title']!,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: charcoalBlack,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              features[index]['emoji']!,
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Feature description
                        Text(
                          features[index]['description']!,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: charcoalBlack.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Page indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                features.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        index == 0
                            ? royalPurple
                            : royalPurple.withOpacity(
                              0.3,
                            ), // Placeholder active index
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Get Started button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {}, // Navigation handled by you
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
                      Text('Get Started'),
                      SizedBox(width: 8),
                      Icon(
                        FluentIcons.arrow_right_24_regular,
                        size: 20,
                      ), // Fluent UI arrow icon
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
