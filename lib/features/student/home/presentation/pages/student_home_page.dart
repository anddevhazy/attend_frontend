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
  const StudentHomePage({super.key});

  @override
  State<StudentHomePage> createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  // SIMULATION STATE — In real app, store this in secure storage
  bool _isAccountActivated = true;

  // Simulate multiple sessions. Empty list = no active sessions.
  final List<_StudentSessionUiModel> _sessions = const [
    _StudentSessionUiModel(
      sessionId: 'sess_001',
      code: 'CSC 301',
      title: 'Data Structures & Algorithms',
      lecturer: 'Dr. Adebayo',
      venue: 'LH 201',
      endsIn: '14:27',
      isLive: true,
    ),
    // _StudentSessionUiModel(
    //   sessionId: 'sess_002',
    //   code: 'MTH 305',
    //   title: 'Linear Algebra II',
    //   lecturer: 'Dr. Okafor',
    //   venue: 'COLNAS Auditorium',
    //   endsIn: '38:10',
    //   isLive: true,
    // ),
  ];

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
        name: 'Elijah',
        onHistoryTap: () {
          // TODO: go to attendance history
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
                itemBuilder: (_, i) => _StudentSessionCard(model: _sessions[i]),
              ),
            ),
        ],
      ),
    );
  }
}

class _StudentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final VoidCallback onHistoryTap;

  const _StudentAppBar({required this.name, required this.onHistoryTap});

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
                Text(
                  name,
                  style: AppTextStyles.h2.copyWith(
                    fontSize: 20,
                    color: AppColors.primary,
                    height: 1.0,
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

class _StudentSessionCard extends StatelessWidget {
  final _StudentSessionUiModel model;

  const _StudentSessionCard({required this.model});

  @override
  Widget build(BuildContext context) {
    final liveColor = model.isLive ? AppColors.success : AppColors.warning;

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
                      model.code,
                      style: AppTextStyles.h2.copyWith(
                        fontSize: 20,
                        color: AppColors.primary,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      model.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 14.5,
                        color: AppColors.textPrimary.withOpacity(0.85),
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${model.lecturer} • ${model.venue}',
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
              _LivePill(color: liveColor, text: 'Live • ${model.endsIn}'),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // CTA inside the card (per-session)
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                // If mark attendance page needs sessionId, pass via extra/params later.
                context.goNamed(
                  Routes.markAttendanceName,
                  extra: const MarkAttendanceArgs(
                    sessionCode: 'CSC 301',
                    sessionTitle: 'Data Structures & Algorithms',
                    lecturerName: 'Dr. Adebayo',
                    venue: 'LH 201',
                    simResult: AttendanceSimResult.deviceBlocked,
                  ),
                );
              },
              icon: const Icon(Icons.fingerprint_rounded, size: 22),
              label: Text(
                'Mark attendance',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                  fontSize: 16,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Hint row (calms user + looks intentional)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(
                  "Mark before the timer ends. You have to be in the lecture hall. And for you not to experience too much stress, make sure this is the device we've already tied to your account. ",
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
                    'Tip: Keep your internet on during class hours so sessions load fast.',
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
