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

  TimeOfDay _addMinutes(TimeOfDay time, int minutesToAdd) {
    final total = time.hour * 60 + time.minute + minutesToAdd;
    final wrapped = total % (24 * 60);
    return TimeOfDay(hour: wrapped ~/ 60, minute: wrapped % 60);
  }

  int _diffMinutes(TimeOfDay start, TimeOfDay end) {
    final s = start.hour * 60 + start.minute;
    final e = end.hour * 60 + end.minute;

    // allow crossing midnight
    final diff = e >= s ? (e - s) : ((24 * 60 - s) + e);

    // clamp to your allowed range (15–180)
    if (diff < 15) return 15;
    if (diff > 180) return 180;
    return diff;
  }

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
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              0,
              AppSpacing.xl,
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

                    const SizedBox(height: AppSpacing.xl),

                    // Duration (better hierarchy)
                    const _SectionTitle('Session duration'),
                    const SizedBox(height: AppSpacing.md),
                    _DurationTile(
                      useExactTime: useExactTime,
                      minutes: durationMinutes,
                      startTime: startTime,
                      endTime: endTime,
                      onModeChanged: (val) {
                        setState(() {
                          useExactTime = val;
                          if (!useExactTime) {
                            // reset exact times (optional)
                            startTime = null;
                            endTime = null;
                          } else {
                            // sensible defaults when switching to exact
                            startTime ??= TimeOfDay.now();
                          }
                        });
                      },
                      onMinutesChanged:
                          (m) => setState(() => durationMinutes = m),
                      onStartNow: () {
                        setState(() {
                          startTime = TimeOfDay.now();
                          // optional: if end isn't set, set it to start + duration
                          endTime ??= _addMinutes(startTime!, durationMinutes);
                        });
                      },
                      onStartChanged: (t) {
                        setState(() {
                          startTime = t;
                          if (startTime != null && endTime != null) {
                            durationMinutes = _diffMinutes(
                              startTime!,
                              endTime!,
                            );
                          } else if (startTime != null && endTime == null) {
                            endTime = _addMinutes(startTime!, durationMinutes);
                          }
                        });
                      },
                      onEndChanged: (t) {
                        setState(() {
                          endTime = t;
                          if (startTime != null && endTime != null) {
                            durationMinutes = _diffMinutes(
                              startTime!,
                              endTime!,
                            );
                          }
                        });
                      },
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

class _DurationTile extends StatelessWidget {
  final bool useExactTime;
  final int minutes;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;

  final ValueChanged<bool> onModeChanged;
  final ValueChanged<int> onMinutesChanged;
  final ValueChanged<TimeOfDay?> onStartChanged;
  final ValueChanged<TimeOfDay?> onEndChanged;
  final VoidCallback onStartNow;

  const _DurationTile({
    required this.useExactTime,
    required this.minutes,
    required this.startTime,
    required this.endTime,
    required this.onModeChanged,
    required this.onMinutesChanged,
    required this.onStartChanged,
    required this.onEndChanged,
    required this.onStartNow,
  });

  String _prettyDuration(int minutes) {
    if (minutes < 60) return '$minutes mins';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  String _prettyTime(BuildContext context, TimeOfDay? t) {
    if (t == null) return '--:--';
    return t.format(context);
  }

  @override
  Widget build(BuildContext context) {
    final durationLabel = _prettyDuration(minutes);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title row (simple)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.timer_outlined,
                  color: AppColors.accent,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  'Duration',
                  style: AppTextStyles.h2.copyWith(
                    fontSize: 18,
                    color: AppColors.primary,
                  ),
                ),
              ),
              Text(
                durationLabel,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary.withOpacity(0.65),
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Mode switch on its own row (fixes the cramped look)
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.primary.withOpacity(0.06)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _ModePill(
                    text: 'Quick Time',
                    active: !useExactTime,
                    onTap: () => onModeChanged(false),
                  ),
                ),
                Expanded(
                  child: _ModePill(
                    text: 'Custom Time',
                    active: useExactTime,
                    onTap: () => onModeChanged(true),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          if (!useExactTime) ...[
            // QUICK MODE: slider
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Pick duration',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary.withOpacity(0.65),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Text(
                  '15–180',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary.withOpacity(0.55),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Slider(
              value: minutes.toDouble(),
              min: 15,
              max: 180,
              divisions: 11,
              activeColor: AppColors.accent,
              inactiveColor: AppColors.accent.withOpacity(0.2),
              onChanged: (val) => onMinutesChanged(val.round()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Short',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary.withOpacity(0.55),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Standard',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary.withOpacity(0.55),
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Long',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary.withOpacity(0.55),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ] else ...[
            // CUSTOM MODE: time pickers + derived duration line
            Text(
              'Set exact start and end time',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary.withOpacity(0.65),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            _TimeRow(
              label: 'Start',
              value: _prettyTime(context, startTime),
              helper: 'Tap to pick',
              trailing: const SizedBox(width: 1),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: startTime ?? TimeOfDay.now(),
                );
                if (picked != null) onStartChanged(picked);
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _TimeRow(
              label: 'End',
              value: _prettyTime(context, endTime),
              helper: 'Tap to pick',
              trailing: const SizedBox(width: 1),
              onTap: () async {
                final base = endTime ?? startTime ?? TimeOfDay.now();
                final picked = await showTimePicker(
                  context: context,
                  initialTime: base,
                );
                if (picked != null) onEndChanged(picked);
              },
            ),
          ],
        ],
      ),
    );
  }
}

class _ModePill extends StatelessWidget {
  final String text;
  final bool active;
  final VoidCallback onTap;

  const _ModePill({
    required this.text,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bg = active ? AppColors.primary : Colors.transparent;
    final fg =
        active ? AppColors.white : AppColors.textPrimary.withOpacity(0.65);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium.copyWith(
              color: fg,
              fontWeight: FontWeight.w900,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _NowPill extends StatelessWidget {
  final VoidCallback onTap;
  const _NowPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.primary.withOpacity(0.10)),
          ),
          child: Text(
            'Now',
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              height: 1.0,
            ),
          ),
        ),
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  final String label;
  final String value;
  final String helper;
  final Widget trailing;
  final VoidCallback onTap;

  const _TimeRow({
    required this.label,
    required this.value,
    required this.helper,
    required this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isUnset = value == '--:--';

    return Material(
      color: AppColors.primary.withOpacity(0.03),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Row(
            children: [
              // Left: label + helper
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary.withOpacity(0.65),
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      helper,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary.withOpacity(0.50),
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),

              // Right: time value (feels like an input)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.06),
                  ),
                ),
                child: Text(
                  value,
                  style: AppTextStyles.h2.copyWith(
                    fontSize: 18,
                    color:
                        isUnset
                            ? AppColors.textPrimary.withOpacity(0.35)
                            : AppColors.primary,
                    height: 1.0,
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // optional trailing (Now pill on Start)
              trailing,

              // (optional) chevron - keep subtle
              const SizedBox(width: 6),
              Icon(
                Icons.expand_more_rounded,
                color: AppColors.textPrimary.withOpacity(0.28),
                size: 22,
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
