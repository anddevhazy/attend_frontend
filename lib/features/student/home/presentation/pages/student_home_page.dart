import 'dart:async';

import 'package:attend/features/student/home/presentation/pages/activate_account_page.dart';
import 'package:attend/features/student/mark_attendance/attendance_sim_result.dart';
import 'package:attend/features/student/mark_attendance/mark_attendance_args.dart';
import 'package:attend/global/components/app_toast.dart';
import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StudentHomePage extends StatefulWidget {
  final String? initialStatus;
  const StudentHomePage({super.key, this.initialStatus});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  bool _isAccountActivated = true;

  // 1. Change this to a regular list so it can be modified
  List<_StudentSessionUiModel> _sessions = [];

  // AD STATE - Now independent
  bool _isAdVisible = false;
  @override
  void initState() {
    super.initState();
    if (widget.initialStatus == 'pending') {
      _sessions = [_demoSession];
    }
  }

  // 2. Define the "Demo" session data
  final _demoSession = const _StudentSessionUiModel(
    sessionId: 'sess_001',
    code: 'CSC 301',
    title: 'Data Structures & Algorithms',
    lecturer: 'Dr. Okafor',
    venue: '1k Cap',
    endsIn: '14:55',
    isLive: true,
  );
  // _StudentSessionUiModel(
  //   sessionId: 'sess_002',
  //   code: 'MTH 305',
  //   title: 'Linear Algebra II',
  //   lecturer: 'Dr. Okafor',
  //   venue: 'COLNAS Auditorium',
  //   endsIn: '38:10',
  //   isLive: true,
  // );

  @override
  Widget build(BuildContext context) {
    if (!_isAccountActivated) {
      return ActivateAccountPage(
        userEmail: "Elijah@gmail.com",
        onActivated: () {
          setState(() => _isAccountActivated = true);
          AppToast.show(
            context: context,
            message: "Account activated successfully!",
            type: ToastType.success,
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _StudentAppBar(
        name: 'Elijah, 20201842',
        // Toggle Session via History Icon
        onHistoryTap: () {
          setState(() {
            _sessions = _sessions.isEmpty ? [_demoSession] : [];
          });
        },
        // Toggle Ad via Name Tap
        onNameTap: () {
          setState(() {
            _isAdVisible = !_isAdVisible;
          });
        },
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
          if (_sessions.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _NoActiveSessionView(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.md,
                AppSpacing.lg,
              ),
              sliver: SliverList.separated(
                itemCount: _sessions.length,
                separatorBuilder:
                    (_, __) => const SizedBox(height: AppSpacing.lg),
                itemBuilder:
                    (_, i) => _StudentSessionCard(
                      model: _sessions[i],
                      initialStatus:
                          widget.initialStatus == 'pending'
                              ? _AttendanceStatus.pending
                              : _AttendanceStatus.initial,
                    ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: _BottomAdSlot(isVisible: _isAdVisible),
    );
  }
}

class _StudentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final VoidCallback onHistoryTap;
  final VoidCallback onNameTap; // 1. Add this

  const _StudentAppBar({
    required this.name,
    required this.onHistoryTap,
    required this.onNameTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(78);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 78,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.md,
          AppSpacing.xl,
          AppSpacing.md,
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: const AssetImage(
                AppAssets.dashboardAvatarPlaceholder,
              ),
              backgroundColor: AppColors.primary.withOpacity(0.06),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome back',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary.withOpacity(0.65),
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 2),
                // 3. THE SECRET AD TRIGGER
                GestureDetector(
                  onTap: onNameTap,
                  behavior: HitTestBehavior.opaque, // Makes it easier to tap
                  child: Text(
                    name,
                    style: AppTextStyles.h2.copyWith(
                      fontSize: 20,
                      color: AppColors.primary,
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: Icon(
                Icons.history_rounded,
                color: AppColors.primary,
                size: 28,
              ),
              onPressed: onHistoryTap,
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppColors.primary.withOpacity(0.06)),
      ),
    );
  }
}

class _StudentSessionUiModel {
  final String sessionId;
  final String code;
  final String title;
  final String lecturer;
  final String venue;
  final String endsIn;
  final bool isLive;

  const _StudentSessionUiModel({
    required this.sessionId,
    required this.code,
    required this.title,
    required this.lecturer,
    required this.venue,
    required this.endsIn,
    required this.isLive,
  });
}

enum _AttendanceStatus { initial, pending, marked }

class _StudentSessionCard extends StatefulWidget {
  final _StudentSessionUiModel model;
  final _AttendanceStatus initialStatus;

  const _StudentSessionCard({
    required this.model,
    this.initialStatus = _AttendanceStatus.initial,
  });

  @override
  State<_StudentSessionCard> createState() => _StudentSessionCardState();
}

class _StudentSessionCardState extends State<_StudentSessionCard> {
  late Duration _remainingTime;
  Timer? _timer;
  late _AttendanceStatus _status;

  // NEW: Track the attendance state for this specific card
  // _AttendanceStatus _status = _AttendanceStatus.initial;

  @override
  void initState() {
    super.initState();
    _status = widget.initialStatus;
    _remainingTime = _parseTimeString(widget.model.endsIn);
    _startTimer();
  }

  Duration _parseTimeString(String timeString) {
    final parts = timeString.split(':');
    if (parts.length == 2) {
      final minutes = int.tryParse(parts[0]) ?? 0;
      final seconds = int.tryParse(parts[1]) ?? 0;
      return Duration(minutes: minutes, seconds: seconds);
    }
    return Duration.zero;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.inSeconds > 0) {
        setState(() {
          _remainingTime = _remainingTime - const Duration(seconds: 1);
        });
      } else {
        timer.cancel();
        // Optionally handle session expiry
      }
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final liveColor =
        widget.model.isLive ? AppColors.success : AppColors.warning;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top row: course + live pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model.code,
                      style: AppTextStyles.h2.copyWith(
                        fontSize: 20,
                        color: AppColors.primary,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      widget.model.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 14.5,
                        color: AppColors.textPrimary.withOpacity(0.85),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.model.lecturer} • ${widget.model.venue}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary.withOpacity(0.68),
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // TRIGGER 1: Live Pill -> Marked
              GestureDetector(
                onTap: () => setState(() => _status = _AttendanceStatus.marked),
                child: _LivePill(
                  color: liveColor,
                  text: 'Live • ${_formatDuration(_remainingTime)}',
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // SizedBox(
          //   height: 54,
          //   child: ElevatedButton.icon(
          //     onPressed:
          //         _status == _AttendanceStatus.initial
          //             ? () {
          //               // Original click logic
          //               context.goNamed(
          //                 Routes.markAttendanceName,
          //                 extra: const MarkAttendanceArgs(
          //                   sessionCode: 'CSC 301',
          //                   sessionTitle: 'Data Structures & Algorithms',
          //                   lecturerName: 'Dr. Adebayo',
          //                   venue: 'LH 201',
          //                   simResult: AttendanceSimResult.deviceBlocked,
          //                 ),
          //               );
          //             }
          //             : null, // Disable if marked/pending if you want
          //     icon: Icon(
          //       _status == _AttendanceStatus.marked
          //           ? Icons.check_circle_outline_rounded
          //           : Icons.fingerprint_rounded,
          //       size: 22,
          //     ),
          //     label: Text(
          //       _status == _AttendanceStatus.initial
          //           ? 'Mark attendance'
          //           : _status == _AttendanceStatus.pending
          //           ? 'Awaiting Override Verdict...'
          //           : 'Attendance Marked',
          //       style: AppTextStyles.bodyLarge.copyWith(
          //         fontWeight: FontWeight.w900,
          //         color: AppColors.white,
          //         fontSize: 16,
          //       ),
          //     ),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor:
          //           _status == _AttendanceStatus.marked
          //               ? AppColors.success
          //               : AppColors.primary,
          //       foregroundColor: AppColors.white,
          //       elevation: 0,
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(18),
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 54,
            child: Builder(
              builder: (context) {
                final bool isInitial = _status == _AttendanceStatus.initial;
                final bool isPending = _status == _AttendanceStatus.pending;
                final bool isMarked = _status == _AttendanceStatus.marked;

                final Color bgColor =
                    isMarked
                        ? AppColors.success
                        : isPending
                        ? AppColors.warning
                        : AppColors.primary;

                // Yellow needs dark text/icons. Others can stay white.
                final Color fgColor =
                    isPending ? AppColors.primary : AppColors.white;

                final IconData icon =
                    isMarked
                        ? Icons.check_circle_outline_rounded
                        : isPending
                        ? Icons.hourglass_top_rounded
                        : Icons.fingerprint_rounded;

                final String label =
                    isInitial
                        ? 'Mark attendance'
                        : isPending
                        ? 'Awaiting override verdict...'
                        : 'Attendance marked';

                return ElevatedButton.icon(
                  onPressed:
                      isInitial
                          ? () {
                            context.goNamed(
                              Routes.markAttendanceName,
                              extra: const MarkAttendanceArgs(
                                sessionCode: 'CSC 301',
                                sessionTitle: 'Data Structures & Algorithms',
                                lecturerName: 'Dr. Okafor',
                                venue: '1k Cap',
                                simResult: AttendanceSimResult.deviceBlocked,
                              ),
                            );
                          }
                          : null,
                  icon: Icon(icon, size: 22, color: fgColor),
                  label: Text(
                    label,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w900,
                      color: fgColor,
                      fontSize: 16,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: bgColor,
                    foregroundColor: fgColor,
                    disabledBackgroundColor:
                        bgColor, // keep same color when disabled
                    disabledForegroundColor: fgColor.withOpacity(0.9),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Hint row (calms user + looks intentional)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap:
                    () => setState(() => _status = _AttendanceStatus.pending),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.accent,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  "Mark attendance before the timer ends. You must be in the lecture hall. To avoid unnecessary stress, ensure this is the device already linked to your account. If this is your first time using this app, make sure the very first person to mark attendance on this phone is you, the actual owner.",
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textPrimary.withOpacity(0.75),
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LivePill extends StatelessWidget {
  final Color color;
  final String text;

  const _LivePill({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, color: color, size: 10),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _NoActiveSessionView extends StatelessWidget {
  const _NoActiveSessionView();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        0,
        AppSpacing.xl,
        AppSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
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
            child: Column(
              children: [
                Image.asset(
                  AppAssets.dashboardNoClass,
                  height: 220,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'No active sessions',
                  style: AppTextStyles.h2.copyWith(
                    fontSize: 22,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'When a lecturer starts a session, it will show up here instantly.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 14.8,
                    height: 1.45,
                    color: AppColors.textPrimary.withOpacity(0.85),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.04),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.primary.withOpacity(0.06)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.notifications_active_outlined,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Tip: Keep your internet on during class hours so sessions load fast. If this is your first time using this app, make sure the very first person to mark attendance on this phone is you, the actual owner',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary.withOpacity(0.75),
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomAdSlot extends StatelessWidget {
  final bool isVisible;

  const _BottomAdSlot({required this.isVisible});

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return SafeArea(
      top: false,
      child: Padding(
        // keep your page margin so it matches the app’s layout rhythm
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.xl,
          AppSpacing.sm,
          AppSpacing.xl,
          AppSpacing.md,
        ),
        child: Container(
          height: 62, // your slot height
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.primary.withOpacity(0.06)),
            boxShadow: [
              BoxShadow(
                blurRadius: 16,
                offset: const Offset(0, 10),
                color: AppColors.primary.withOpacity(0.05),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              AppAssets.moniepointAdvert,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }
}
