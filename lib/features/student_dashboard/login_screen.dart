import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Colors from visual identity
    const deepNavy = Color(0xFF091E42);
    const royalPurple = Color(0xFF6A0DAD);
    const lightGray = Color(0xFFF4F6FA);
    const charcoalBlack = Color(0xFF1C1C1E);
    const emeraldGreen = Color(0xFF34C759);

    return Scaffold(
      backgroundColor: lightGray,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/logo.png', // Fingerprint + location pin SVG
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 24),
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome Back',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: charcoalBlack,
                      ),
                    ),
                    const Text(' 😊', style: TextStyle(fontSize: 24)),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Log in to continue tracking attendance.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: charcoalBlack.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 32),
                // ID field
                TextField(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Matric No. / Faculty ID',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: charcoalBlack.withOpacity(0.5),
                    ),
                    prefixIcon: const Icon(
                      FluentIcons.person_24_regular, // Fluent UI person icon
                      color: royalPurple,
                      size: 24,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: charcoalBlack,
                  ),
                ),
                const SizedBox(height: 16),
                // Password field
                TextField(
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Password',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: charcoalBlack.withOpacity(0.5),
                    ),
                    prefixIcon: const Icon(
                      FluentIcons.lock_closed_24_regular, // Fluent UI lock icon
                      color: royalPurple,
                      size: 24,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                  ),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: charcoalBlack,
                  ),
                ),
                const SizedBox(height: 24),
                // Login button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {}, // Login action handled by you
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
                        Text('Log In'),
                        SizedBox(width: 8),
                        Icon(
                          FluentIcons.arrow_right_24_regular,
                          size: 20,
                        ), // Fluent UI arrow icon
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Sign-up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don’t have an account? ',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: charcoalBlack.withOpacity(0.7),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {}, // Navigation to sign-up handled by you
                      child: Text(
                        'Sign Up',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: royalPurple,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
