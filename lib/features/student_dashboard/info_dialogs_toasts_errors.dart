import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

// Info Dialog
class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String emoji;

  const InfoDialog({
    Key? key,
    required this.title,
    required this.message,
    this.emoji = 'ℹ️',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors from visual identity
    const deepNavy = Color(0xFF091E42);
    const lightGray = Color(0xFFF4F6FA);
    const charcoalBlack = Color(0xFF1C1C1E);
    const emeraldGreen = Color(0xFF34C759);

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
            // Logo
            Image.asset(
              'assets/logo.png', // Fingerprint + location pin SVG
              width: 60,
              height: 60,
            ),
            const SizedBox(height: 16),
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: charcoalBlack,
                  ),
                ),
                const SizedBox(width: 8),
                Text(emoji, style: const TextStyle(fontSize: 20)),
              ],
            ),
            const SizedBox(height: 12),
            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: charcoalBlack.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            // OK button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {}, // Dismiss action handled by you
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
                child: const Text('OK'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Success Toast
class SuccessToast extends StatelessWidget {
  final String message;

  const SuccessToast({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors from visual identity
    const lightGray = Color(0xFFF4F6FA);
    const charcoalBlack = Color(0xFF1C1C1E);
    const emeraldGreen = Color(0xFF34C759);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: lightGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: emeraldGreen, width: 1),
        boxShadow: [
          BoxShadow(
            color: charcoalBlack.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/success_illustration.png', // Duotone success illustration
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: charcoalBlack,
              ),
            ),
          ),
          const Text('✅', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// Error Toast
class ErrorToast extends StatelessWidget {
  final String message;

  const ErrorToast({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors from visual identity
    const lightGray = Color(0xFFF4F6FA);
    const charcoalBlack = Color(0xFF1C1C1E);
    const tomatoRed = Color(0xFFFF3B30);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: lightGray,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tomatoRed, width: 1),
        boxShadow: [
          BoxShadow(
            color: charcoalBlack.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/error_illustration.png', // Duotone error illustration
            width: 40,
            height: 40,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: charcoalBlack,
              ),
            ),
          ),
          const Text('❌', style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

// Example usage in a screen (for reference, implement as needed)
class ExampleScreen extends StatelessWidget {
  const ExampleScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA), // Light Gray
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Example buttons to trigger dialogs/toasts
            ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => const InfoDialog(
                        title: 'Action Required',
                        message:
                            'Please verify your identity to proceed with attendance.',
                        emoji: 'ℹ️',
                      ),
                );
              },
              child: const Text('Show Info Dialog'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const SuccessToast(
                      message: 'Override request submitted successfully!',
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    padding: EdgeInsets.zero,
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              child: const Text('Show Success Toast'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const ErrorToast(
                      message: 'Invalid login credentials. Please try again.',
                    ),
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    padding: EdgeInsets.zero,
                    duration: const Duration(seconds: 3),
                  ),
                );
              },
              child: const Text('Show Error Toast'),
            ),
          ],
        ),
      ),
    );
  }
}
