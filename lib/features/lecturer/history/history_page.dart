import 'dart:math';

import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:flutter/material.dart';

class LecturerHistoryGradingPage extends StatefulWidget {
  const LecturerHistoryGradingPage({super.key});

  @override
  State<LecturerHistoryGradingPage> createState() =>
      _LecturerHistoryGradingPageState();
}

class _LecturerHistoryGradingPageState
    extends State<LecturerHistoryGradingPage> {
  // ---- Demo data (replace with API/state later) ----
  final List<_CourseUi> _courses = const [
    _CourseUi(code: "CSC 301", title: "Data Structures & Algorithms"),
    _CourseUi(code: "MTH 305", title: "Linear Algebra II"),
    _CourseUi(code: "PHY 302", title: "Electromagnetism"),
  ];

  late _CourseUi _selectedCourse = _courses.first;

  // Grading config
  int _classesHeld = 12; // lecturer inputs
  int _attendanceMarks = 10; // lecturer inputs

  @override
  Widget build(BuildContext context) {
    final sessions = _demoSessionsFor(_selectedCourse.code);
    final totalSessions = sessions.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "History & grading",
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
          SliverToBoxAdapter(child: const SizedBox(height: AppSpacing.lg)),

          // Header controls
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  _CoursePicker(
                    courses: _courses,
                    selected: _selectedCourse,
                    onChanged: (c) => setState(() => _selectedCourse = c),
                  ),
                  const SizedBox(height: AppSpacing.md),

                  Row(
                    children: [
                      Expanded(
                        child: _MiniStat(
                          label: "Sessions",
                          value: "$totalSessions",
                          icon: Icons.calendar_month_rounded,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(child: const SizedBox(height: AppSpacing.lg)),

          // Grading config card
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverToBoxAdapter(
              child: _Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _SectionIcon(icon: Icons.auto_graph_rounded),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(
                            "Attendance grading",
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      "Set how many classes you’ll hold and how many marks attendance carries. We’ll compute each student’s score automatically.",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary.withOpacity(0.75),
                        fontWeight: FontWeight.w600,
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),

                    Row(
                      children: [
                        Expanded(
                          child: _NumberField(
                            label: "Classes held",
                            value: _classesHeld,
                            min: 1,
                            max: 40,
                            onChanged: (v) => setState(() => _classesHeld = v),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _NumberField(
                            label: "Attendance marks",
                            value: _attendanceMarks,
                            min: 1,
                            max: 30,
                            onChanged:
                                (v) => setState(() => _attendanceMarks = v),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppSpacing.lg),
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.accent.withOpacity(0.16),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.accent,
                            size: 20,
                          ),
                          const SizedBox(width: AppSpacing.md),
                          Expanded(
                            child: Text(
                              "Example: 8 / $_classesHeld classes ⇒ ${_score(8).toStringAsFixed(1)} / $_attendanceMarks marks",
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textPrimary.withOpacity(0.85),
                                fontWeight: FontWeight.w700,
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Export placeholder
                    SizedBox(
                      height: 52,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: export CSV/PDF
                        },
                        icon: const Icon(Icons.download_rounded),
                        label: Text(
                          "Export report (CSV)",
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                            fontSize: 15.5,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.primary.withOpacity(0.18),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: const SizedBox(height: AppSpacing.lg)),

          // Session history list
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
            sliver: SliverToBoxAdapter(
              child: Text(
                "Session history",
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(child: const SizedBox(height: AppSpacing.md)),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              0,
              AppSpacing.xl,
              AppSpacing.huge,
            ),
            sliver: SliverList.separated(
              itemCount: sessions.length,
              separatorBuilder:
                  (_, __) => const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, i) {
                final s = sessions[i];
                return _SessionCard(session: s);
              },
            ),
          ),
        ],
      ),
    );
  }

  double _score(int attended) {
    if (_classesHeld <= 0) return 0;
    final ratio = attended / _classesHeld;
    return (ratio * _attendanceMarks).clamp(0, _attendanceMarks).toDouble();
  }

  List<_SessionUi> _demoSessionsFor(String code) {
    final all = <_SessionUi>[
      _SessionUi(
        courseCode: "CSC 301",
        dateLabel: "Mon • Nov 10",
        timeLabel: "10:00 – 12:00",
        venue: "LH 201",
        present: 47,
        denied: 2,
      ),
      _SessionUi(
        courseCode: "CSC 301",
        dateLabel: "Wed • Nov 12",
        timeLabel: "10:00 – 12:00",
        venue: "LH 201",
        present: 45,
        denied: 1,
      ),
      _SessionUi(
        courseCode: "CSC 301",
        dateLabel: "Mon • Nov 17",
        timeLabel: "10:00 – 12:00",
        venue: "LH 201",
        present: 50,
        denied: 0,
      ),
      _SessionUi(
        courseCode: "MTH 305",
        dateLabel: "Tue • Nov 11",
        timeLabel: "08:00 – 10:00",
        venue: "COLNAS Auditorium",
        present: 122,
        denied: 3,
      ),
      _SessionUi(
        courseCode: "PHY 302",
        dateLabel: "Thu • Nov 13",
        timeLabel: "14:00 – 16:00",
        venue: "LH 105",
        present: 76,
        denied: 2,
      ),
    ];

    // simple filter simulation
    var list = all.where((s) => s.courseCode == code).toList();

    return list;
  }
}

// ---------------- UI Pieces ----------------

class _CoursePicker extends StatelessWidget {
  final List<_CourseUi> courses;
  final _CourseUi selected;
  final ValueChanged<_CourseUi> onChanged;

  const _CoursePicker({
    required this.courses,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          _SectionIcon(icon: Icons.class_rounded),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selected.code,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selected.title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary.withOpacity(0.70),
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          PopupMenuButton<_CourseUi>(
            tooltip: "",
            color: AppColors.white,
            onSelected: onChanged,
            itemBuilder: (_) {
              return courses
                  .map(
                    (c) => PopupMenuItem<_CourseUi>(
                      value: c,
                      child: Text(
                        "${c.code} • ${c.title}",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  )
                  .toList();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.primary.withOpacity(0.08)),
              ),
              child: Row(
                children: [
                  Text(
                    "Change",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.expand_more_rounded,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MiniStat({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Row(
        children: [
          _SectionIcon(icon: icon),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.h2.copyWith(
                  fontSize: 20,
                  color: AppColors.primary,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary.withOpacity(0.70),
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  final _SessionUi session;
  const _SessionCard({required this.session});

  @override
  Widget build(BuildContext context) {
    final total = max(1, session.present);
    final pct = (session.present / total) * 100;

    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionIcon(icon: Icons.event_available_rounded),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.dateLabel,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${session.timeLabel} • ${session.venue}",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary.withOpacity(0.70),
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.success.withOpacity(0.22),
                  ),
                ),
                child: Text(
                  "${pct.round()}% present",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary.withOpacity(0.85),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: _TinyStat(
                  label: "Present",
                  value: "${session.present}",
                  tint: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.md),

              Expanded(
                child: _TinyStat(
                  label: "Denied",
                  value: "${session.denied}",
                  tint: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TinyStat extends StatelessWidget {
  final String label;
  final String value;
  final Color tint;

  const _TinyStat({
    required this.label,
    required this.value,
    required this.tint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: tint.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: tint.withOpacity(0.18)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.h2.copyWith(
              fontSize: 20,
              color: tint,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: tint,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: AppColors.primary.withOpacity(0.06),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _SectionIcon extends StatelessWidget {
  final IconData icon;
  const _SectionIcon({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.08)),
      ),
      child: Icon(icon, color: AppColors.primary, size: 22),
    );
  }
}

class _NumberField extends StatelessWidget {
  final String label;
  final int value;
  final int min;
  final int max;
  final ValueChanged<int> onChanged;

  const _NumberField({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.primary.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary.withOpacity(0.70),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _IconBtn(icon: Icons.remove_rounded, onTap: () => onChanged(max)),
              const SizedBox(width: 12),
              Text(
                "$value",
                style: AppTextStyles.h2.copyWith(
                  fontSize: 22,
                  color: AppColors.primary,
                  height: 1.0,
                ),
              ),
              const SizedBox(width: 12),
              _IconBtn(icon: Icons.add_rounded, onTap: () => onChanged(min)),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary.withOpacity(0.10)),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
      ),
    );
  }
}

// ---------------- Data models ----------------

class _CourseUi {
  final String code;
  final String title;
  const _CourseUi({required this.code, required this.title});
}

class _SessionUi {
  final String courseCode;
  final String dateLabel;
  final String timeLabel;
  final String venue;
  final int present;
  final int denied;

  const _SessionUi({
    required this.courseCode,
    required this.dateLabel,
    required this.timeLabel,
    required this.venue,
    required this.present,
    required this.denied,
  });
}
