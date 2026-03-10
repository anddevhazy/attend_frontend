import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateSessionPage extends StatefulWidget {
  const CreateSessionPage({super.key});

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  String? selectedCourse;
  String? selectedLocation;
  int durationMinutes = 60;
  bool useExactTime = false;

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final List<String> courses = const [
    'CSC 301 – Data Structures & Algorithms',
    'MTH 305 – Linear Algebra II',
    'PHY 302 – Electromagnetism',
    'CHM 304 – Organic Chemistry II',
  ];

  final List<String> locations = const [
    'LH 201 (Large Lecture Hall)',
    'LH 105',
    'COLNAS Auditorium',
    'COLENG 001',
    'Main Library Reading Room',
    '1k Cap',
  ];

  bool get canStart => selectedCourse != null && selectedLocation != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.close_rounded,
            color: AppColors.primary,
            size: 28,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Create Session',
          style: AppTextStyles.h2.copyWith(
            fontSize: 20,
            color: AppColors.primary,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            height: 1,
            color: AppColors.primary.withOpacity(0.06),
          ),
        ),
      ),

      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              0,
              AppSpacing.sm,
              120, // room for bottom CTA
            ),
            sliver: SliverToBoxAdapter(
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.05),
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 18,
                      offset: const Offset(0, 10),
                      color: AppColors.primary.withOpacity(0.06),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header inside the card (small + purposeful)
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(
                            Icons.play_circle_outline_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Session setup',
                                style: AppTextStyles.h2.copyWith(
                                  fontSize: 18,
                                  color: AppColors.primary,
                                  height: 1.0,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Select course, venue and duration',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary.withOpacity(
                                    0.65,
                                  ),
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Image.asset(
                          AppAssets.createSessionHero,
                          height: 62,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),
                    _DividerLight(),
                    const SizedBox(height: AppSpacing.lg),

                    // Course
                    const _SectionTitle('Course'),
                    const SizedBox(height: AppSpacing.md),
                    _DropdownTile(
                      label: 'Select course',
                      value: selectedCourse,
                      items: courses,
                      onChanged: (val) => setState(() => selectedCourse = val),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // Location
                    const _SectionTitle('Lecture venue'),
                    const SizedBox(height: AppSpacing.md),
                    _DropdownTile(
                      label: 'Where is this class holding?',
                      value: selectedLocation,
                      items: locations,
                      onChanged:
                          (val) => setState(() => selectedLocation = val),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),

      // Bottom pinned CTA (clean + consistent)
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.md,
            AppSpacing.xl,
            AppSpacing.md,
          ),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed:
                  canStart
                      ? () {
                        context.goNamed(
                          Routes.lecturerHomeName,
                          queryParameters: {'status': 'active'},
                        );
                      }
                      : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                disabledBackgroundColor: AppColors.primary.withOpacity(0.25),
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                'Start Attendance Session',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontSize: 16.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DividerLight extends StatelessWidget {
  const _DividerLight();

  @override
  Widget build(BuildContext context) {
    return Container(height: 1, color: AppColors.primary.withOpacity(0.06));
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
        fontWeight: FontWeight.w800,
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
    final hasValue = value != null;

    return Material(
      borderRadius: BorderRadius.circular(18),
      color: AppColors.primary.withOpacity(0.04),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.transparent,
            isScrollControlled: true,
            builder:
                (_) => _BottomSheetPicker(
                  title: label,
                  items: items,
                  selected: value,
                  onSelected: onChanged,
                ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  hasValue ? value! : label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      hasValue
                          ? AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          )
                          : AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary.withOpacity(0.55),
                            fontWeight: FontWeight.w700,
                          ),
                ),
              ),
              const SizedBox(width: 10),
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
  final String title;
  final List<String> items;
  final String? selected;
  final ValueChanged<String?> onSelected;

  const _BottomSheetPicker({
    required this.title,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.35,
      maxChildSize: 0.9,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.textPrimary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.lg,
                  AppSpacing.xl,
                  AppSpacing.md,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.h2.copyWith(
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  controller: controller,
                  itemCount: items.length,
                  separatorBuilder:
                      (_, __) => Container(
                        height: 1,
                        color: AppColors.primary.withOpacity(0.05),
                      ),
                  itemBuilder: (ctx, i) {
                    final item = items[i];
                    final isSelected = item == selected;

                    return ListTile(
                      leading:
                          isSelected
                              ? Icon(
                                Icons.check_circle,
                                color: AppColors.accent,
                              )
                              : Icon(
                                Icons.circle_outlined,
                                color: AppColors.textPrimary.withOpacity(0.22),
                              ),
                      title: Text(
                        item,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight:
                              isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                      onTap: () {
                        onSelected(item);
                        Navigator.pop(ctx);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
