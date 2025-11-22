import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:flutter/material.dart';

class CreateSessionPage extends StatefulWidget {
  const CreateSessionPage({super.key});

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  String? selectedCourse;
  String? selectedLocation;
  int durationMinutes = 60;

  final List<String> courses = [
    'CSC 301 – Data Structures & Algorithms',
    'MTH 305 – Linear Algebra II',
    'PHY 302 – Electromagnetism',
    'CHM 304 – Organic Chemistry II',
  ];

  final List<String> locations = [
    'LH 201 (Large Lecture Hall)',
    'LH 105',
    'COLNAS Auditorium',
    'COLENG 001',
    'Main Library Reading Room',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: AppColors.primary,
            size: 28,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Create Session',
          style: AppTextStyles.h2.copyWith(fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Hero
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xl),
              child: Image.asset(
                AppAssets.createSessionHero,
                height: 220,
                fit: BoxFit.contain,
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                children: [
                  // Course Selector
                  _SectionTitle('Course'),
                  SizedBox(height: AppSpacing.md),
                  _DropdownTile(
                    label: 'Select course',
                    value: selectedCourse,
                    items: courses,
                    onChanged: (val) => setState(() => selectedCourse = val),
                  ),

                  SizedBox(height: AppSpacing.xxl),

                  // Location Selector
                  _SectionTitle('Lecture Venue'),
                  SizedBox(height: AppSpacing.md),
                  _DropdownTile(
                    label: 'Where is this class holding?',
                    value: selectedLocation,
                    items: locations,
                    onChanged: (val) => setState(() => selectedLocation = val),
                  ),

                  SizedBox(height: AppSpacing.xxl),

                  // Duration
                  _SectionTitle('Session Duration'),
                  SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Icon(
                        Icons.timer_outlined,
                        color: AppColors.accent,
                        size: 28,
                      ),
                      SizedBox(width: AppSpacing.md),
                      Text(
                        '$durationMinutes minutes',
                        style: AppTextStyles.h2.copyWith(
                          fontSize: 28,
                          color: AppColors.primary,
                        ),
                      ),
                      const Spacer(),
                      // Slider
                      SizedBox(
                        width: 180,
                        child: Slider(
                          value: durationMinutes.toDouble(),
                          min: 15,
                          max: 180,
                          divisions: 11,
                          activeColor: AppColors.accent,
                          inactiveColor: AppColors.accent.withOpacity(0.2),
                          onChanged:
                              (val) =>
                                  setState(() => durationMinutes = val.round()),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: AppSpacing.xxl),
                ],
              ),
            ),

            // Bottom CTA
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: Offset(0, -4),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  height: 64,
                  child: ElevatedButton(
                    onPressed:
                        (selectedCourse != null && selectedLocation != null)
                            ? () {
                              // You will create session and go to Live Attendance View
                            }
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withOpacity(
                        0.3,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 10,
                    ),
                    child: Text(
                      'Start Attendance Session',
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                      ),
                    ),
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

class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.bodyLarge.copyWith(
        fontWeight: FontWeight.w600,
        color: AppColors.primary,
      ),
    );
  }
}

class _DropdownTile extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownTile({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: AppColors.background,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            builder:
                (_) => _BottomSheetPicker(
                  items: items,
                  selected: value,
                  onSelected: onChanged,
                ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  value ?? label,
                  style:
                      value == null
                          ? AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary.withOpacity(0.6),
                          )
                          : AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.accent,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomSheetPicker extends StatelessWidget {
  final List<String> items;
  final String? selected;
  final ValueChanged<String?> onSelected;

  const _BottomSheetPicker({
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (ctx, i) {
          final item = items[i];
          final isSelected = item == selected;
          return ListTile(
            leading:
                isSelected
                    ? Icon(Icons.check_circle, color: AppColors.accent)
                    : null,
            title: Text(
              item,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
            onTap: () {
              onSelected(item);
              Navigator.pop(ctx);
            },
          );
        },
      ),
    );
  }
}
