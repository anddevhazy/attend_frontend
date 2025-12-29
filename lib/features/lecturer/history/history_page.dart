import 'dart:io';
import 'dart:math';

import 'package:attend/global/components/app_toast.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class LecturerHistoryGradingPage extends StatefulWidget {
  const LecturerHistoryGradingPage({super.key});

  @override
  State<LecturerHistoryGradingPage> createState() =>
      _LecturerHistoryGradingPageState();
}

class _LecturerHistoryGradingPageState extends State<LecturerHistoryGradingPage>
    with SingleTickerProviderStateMixin {
  // ---- Demo data (replace with API/state later) ----
  final List<_CourseUi> _courses = const [
    _CourseUi(code: "CSC 301", title: "Data Structures & Algorithms"),
    _CourseUi(code: "MTH 305", title: "Linear Algebra II"),
    _CourseUi(code: "PHY 302", title: "Electromagnetism"),
  ];

  late _CourseUi _selectedCourse = _courses.first;

  // Grading config
  int _classesHeld = 12;
  int _attendanceMarks = 10;

  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          onPressed: () => context.pop(),
        ),
        title: Text(
          "History & Grading",
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
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.sm),

          // Header controls (shared across tabs)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Column(
              children: [
                _CoursePicker(
                  courses: _courses,
                  selected: _selectedCourse,
                  onChanged: (c) => setState(() => _selectedCourse = c),
                ),
                const SizedBox(height: AppSpacing.sm),
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

          const SizedBox(height: AppSpacing.lg),

          // Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.primary.withOpacity(0.06)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                    color: AppColors.primary.withOpacity(0.04),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: AppColors.white,
                unselectedLabelColor: AppColors.textPrimary.withOpacity(0.72),
                labelStyle: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w900,
                ),
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                tabs: const [Tab(text: "History"), Tab(text: "Grading")],
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _HistoryTab(sessions: sessions),
                _GradingTab(
                  classesHeld: _classesHeld,
                  attendanceMarks: _attendanceMarks,
                  onEditClassesHeld: () async {
                    final v = await _pickNumber(
                      title: "Classes held",
                      subtitle:
                          "How many classes will you hold for this course?",
                      initial: _classesHeld,
                      min: 1,
                      max: 40,
                    );
                    if (!mounted || v == null) return;
                    setState(() => _classesHeld = v);
                  },
                  onEditAttendanceMarks: () async {
                    final v = await _pickNumber(
                      title: "Attendance marks",
                      subtitle: "How many marks should attendance carry?",
                      initial: _attendanceMarks,
                      min: 1,
                      max: 30,
                    );
                    if (!mounted || v == null) return;
                    setState(() => _attendanceMarks = v);
                  },
                  scoreExample: (attended) => _score(attended),
                  onExport: _simulateExport,
                ),
              ],
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

  Future<int?> _pickNumber({
    required String title,
    required String subtitle,
    required int initial,
    required int min,
    required int max,
  }) async {
    int temp = initial;

    return showModalBottomSheet<int>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (_) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.xl,
            AppSpacing.lg,
            AppSpacing.xl,
            AppSpacing.xl,
          ),
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: StatefulBuilder(
            builder: (ctx, setSheet) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    title,
                    style: AppTextStyles.h2.copyWith(
                      fontSize: 18,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary.withOpacity(0.75),
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.08),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _StepperBtn(
                          icon: Icons.remove_rounded,
                          onTap: () {
                            if (temp > min) {
                              setSheet(() => temp--);
                            }
                          },
                        ),
                        const SizedBox(width: 18),
                        Text(
                          "$temp",
                          style: AppTextStyles.h2.copyWith(
                            fontSize: 28,
                            color: AppColors.primary,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 18),
                        _StepperBtn(
                          icon: Icons.add_rounded,
                          onTap: () {
                            if (temp < max) {
                              setSheet(() => temp++);
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppSpacing.lg),

                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(ctx, temp),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        "Save",
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: AppColors.primary.withOpacity(0.18),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontWeight: FontWeight.w900,
                          color: AppColors.primary,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Future<void> _simulateExport() async {
    const students = 84;

    final classesHeld = _classesHeld;
    final attendanceMarks = _attendanceMarks;
    final rng = Random(42);

    String matricFor(int i) => "2020${(1683 + i).toString()}";

    final excel = Excel.createExcel();
    final sheet = excel['Sheet1'];

    // Header row
    sheet.cell(CellIndex.indexByString("A1")).value = TextCellValue(
      "Matric No.",
    );
    sheet.cell(CellIndex.indexByString("B1")).value = TextCellValue(
      "Score (𝑥/12)  ",
    );
    sheet.cell(CellIndex.indexByString("C1")).value = TextCellValue(
      "70% Attendance  ",
    );

    // Center style for both columns
    final centerStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      bold: false,
    );

    final headerStyle = CellStyle(
      horizontalAlign: HorizontalAlign.Center,
      verticalAlign: VerticalAlign.Center,
      bold: true,
    );

    sheet.cell(CellIndex.indexByString("A1")).cellStyle = headerStyle;
    sheet.cell(CellIndex.indexByString("B1")).cellStyle = headerStyle;
    sheet.cell(CellIndex.indexByString("C1")).cellStyle = headerStyle;

    // Data rows
    for (int i = 1; i <= students; i++) {
      final attended = max(
        0,
        min(classesHeld, 2 + rng.nextInt(max(1, classesHeld - 1))),
      );
      final score =
          ((attended / max(1, classesHeld)) * attendanceMarks)
              .clamp(0, attendanceMarks)
              .round();

      // Calculate if score is at least 70% of total attainable marks
      final seventyPercentThreshold = attendanceMarks * 0.7;
      final meetsThreshold = score >= seventyPercentThreshold;

      final row = i + 1; // since row 1 is header

      final a = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: row - 1),
      );
      final b = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: row - 1),
      );
      final c = sheet.cell(
        CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: row - 1),
      );

      a.value = TextCellValue(matricFor(i));
      b.value = TextCellValue(score.toString());
      c.value = TextCellValue(meetsThreshold ? "✅  " : "❌  ");

      a.cellStyle = centerStyle;
      b.cellStyle = centerStyle;
      c.cellStyle = centerStyle;
    }

    // Optional: set column widths
    sheet.setColumnWidth(0, 20);
    sheet.setColumnWidth(1, 30);
    sheet.setColumnWidth(2, 25);

    final bytes = excel.encode();
    if (bytes == null) return;

    final dir = await getTemporaryDirectory();
    final safeCourse = _selectedCourse.code.replaceAll(" ", "_");
    final now = DateTime.now();
    final dateStr =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year}";
    final timeStr =
        "${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";

    final fileName =
        "${safeCourse}_attendance_CA_1stSemester_2025-2026_${dateStr}_$timeStr.xlsx";
    final file = File("${dir.path}/$fileName");

    await file.writeAsBytes(bytes, flush: true);
    if (!mounted) return;

    await Share.shareXFiles(
      [
        XFile(
          file.path,
          mimeType:
              "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        ),
      ],
      subject: "${_selectedCourse.code} Attendance CA",
      text: "Attendance CA export for ${_selectedCourse.code}.",
    );

    if (!mounted) return;

    AppToast.show(
      context: context,
      message: "${_selectedCourse.code} CA exported",
      type: ToastType.success,
    );
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

    return all.where((s) => s.courseCode == code).toList();
  }
}

// ---------------- Tabs ----------------

class _HistoryTab extends StatelessWidget {
  final List<_SessionUi> sessions;
  const _HistoryTab({required this.sessions});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.sm,
            AppSpacing.huge,
          ),
          sliver: SliverList.separated(
            itemCount: sessions.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, i) => _SessionCard(session: sessions[i]),
          ),
        ),
      ],
    );
  }
}

class _GradingTab extends StatelessWidget {
  final int classesHeld;
  final int attendanceMarks;
  final VoidCallback onEditClassesHeld;
  final VoidCallback onEditAttendanceMarks;
  final double Function(int attended) scoreExample;
  final Future<void> Function() onExport;

  const _GradingTab({
    required this.classesHeld,
    required this.attendanceMarks,
    required this.onEditClassesHeld,
    required this.onEditAttendanceMarks,
    required this.scoreExample,
    required this.onExport,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.sm,
            AppSpacing.huge,
          ),
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
                    "Set how many marks attendance carries for this semester. We will compute each student’s score automatically.",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary.withOpacity(0.75),
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  _EditStatTile(
                    value: "$attendanceMarks marks",
                    hint: "Tap to edit",
                    icon: Icons.workspace_premium_rounded,
                    onTap: onEditAttendanceMarks,
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
                            "E.g: If a student attended 8 out of 10 classes when attendance carries 12 marks for the semester, his Attendance CA score will be           10 / 12 marks.",
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

                  SizedBox(
                    height: 52,
                    child: OutlinedButton.icon(
                      onPressed: onExport,
                      icon: const Icon(Icons.download_rounded),
                      label: Text(
                        "Download Continuous Assessment",
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
      ],
    );
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

class _EditStatTile extends StatelessWidget {
  final String value;
  final String hint;
  final IconData icon;
  final VoidCallback onTap;

  const _EditStatTile({
    required this.value,
    required this.hint,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.background,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary.withOpacity(0.08)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.08),
                  ),
                ),
                child: Icon(icon, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
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
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Text(
                hint,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary.withOpacity(0.55),
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textPrimary.withOpacity(0.55),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepperBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepperBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withOpacity(0.10)),
          ),
          child: Icon(icon, color: AppColors.primary),
        ),
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
          const SizedBox(height: AppSpacing.md),
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
      padding: const EdgeInsets.all(AppSpacing.md),
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
