import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';

class StudentCourseSelectionScreen extends StatelessWidget {
  const StudentCourseSelectionScreen({super.key});

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
          'Select Your Courses',
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
              // Header with emoji
              Row(
                children: [
                  Text(
                    'Choose Your Courses',
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
                'Select all courses you’re registered for this semester.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: charcoalBlack.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    final course =
                        'CSC ${101 + index} - ${['Intro to Programming', 'Data Structures', 'Algorithms', 'Database Systems', 'Operating Systems', 'Software Engineering'][index]}';
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
                            vertical: 12,
                          ),
                          title: Text(
                            course,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: charcoalBlack,
                            ),
                          ),
                          subtitle: Text(
                            '${3 + (index % 2)} Credits',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: charcoalBlack.withOpacity(0.6),
                            ),
                          ),
                          trailing: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  false
                                      ? emeraldGreen
                                      : Colors.transparent, // Placeholder state
                              border: Border.all(color: royalPurple, width: 2),
                            ),
                            child:
                                false // Placeholder state
                                    ? const Icon(
                                      FluentIcons
                                          .checkmark_24_regular, // Fluent UI check icon
                                      color: Colors.white,
                                      size: 16,
                                    )
                                    : null,
                          ),
                          onTap: () {}, // State management handled by you
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Save button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {}, // Navigation handled by you
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
                      Text('Save & Continue'),
                      SizedBox(width: 8),
                      Icon(
                        FluentIcons
                            .arrow_right_24_regular, // Fluent UI arrow icon
                        size: 20,
                      ),
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
