import 'dart:async';

import 'package:attend/features/lecturer/domain/entities/session_entity.dart';
import 'package:attend/features/lecturer/presentation/bloc/lecturer_cubit.dart';
import 'package:attend/global/components/app_dialog.dart';
import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LecturerHomePage extends StatefulWidget {
  const LecturerHomePage({super.key});

  @override
  State<LecturerHomePage> createState() => _LecturerHomePageState();
}

class _LecturerHomePageState extends State<LecturerHomePage> {
  String _name = '';
  SessionEntity? _liveSession;
  bool _isLoadingSession = true;
  bool _isEndingSession = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<LecturerCubit>().fetchName();
      if (mounted) {
        context.read<LecturerCubit>().fetchLiveSession();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LecturerCubit, LecturerState>(
      listener: (context, state) {
        if (state is NameFetched) {
          setState(() => _name = state.name);
        } else if (state is Loading) {
          if (_liveSession != null) {
            setState(() => _isEndingSession = true);
          }
        } else if (state is NoLiveSession || state is Failed) {
          setState(() {
            _liveSession = null;
            _isLoadingSession = false;
            _isEndingSession = false;
          });
        } else if (state is LiveSessionFetched) {
          setState(() {
            _liveSession = (state as LiveSessionFetched).session;
            _isLoadingSession = false;
            _isEndingSession = false;
          });
        } else if (state is Failed) {
          setState(() {
            _isLoadingSession = false;
            _isEndingSession = false;
          });
        }
      },
      child: Builder(
        builder: (context) {
          final state = context.watch<LecturerCubit>().state;

          if (_isLoadingSession) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (_liveSession != null) {
            return _buildLiveSession(context, _liveSession!);
          }

          return _buildNoSession(context);
        },
      ),
    );
  }

  Widget _buildLiveSession(BuildContext context, SessionEntity session) {
    final uiModel = _SessionUiModel(
      codeAndVenue:
          "${session.course.courseCode} • ${session.location.name ?? ""}",
      title: session.course.name,
      endsIn: "15:00",
      marked: session.present ?? 0,
      manualRequests: session.denied ?? 0,
      isLive: session.isLive,
    );
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _LecturerAppBar(
        initials: _name.isNotEmpty ? _name[0] : '',
        greeting: 'Welcome back ',
        name: _name,
        onNameTap: () {},
        onHistoryTap: () async {
          await context.pushNamed(Routes.lecturerHistoryName);
          // Re-fetch when we return from history
          if (mounted) {
            context.read<LecturerCubit>().fetchLiveSession();
          }
        },
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.md,
                  0,
                  AppSpacing.sm,
                  120,
                ),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _SessionCard(model: uiModel, sessionId: session.sessionId),
                  ]),
                ),
              ),
            ],
          ),

          if (_isEndingSession)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.white),
              ),
            ),
        ],
      ),
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
            child: ElevatedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.play_arrow_rounded, size: 26),
              label: Text(
                'Start Session',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
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
        ),
      ),
    );
  }

  Widget _buildNoSession(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _LecturerAppBar(
        initials: _name.isNotEmpty ? _name[0] : '',
        greeting: 'Welcome back ',
        name: _name,
        onNameTap: () {},
        onHistoryTap: () async {
          await context.pushNamed(Routes.lecturerHistoryName);
          // Re-fetch when we return from history
          if (mounted) {
            context.read<LecturerCubit>().fetchLiveSession();
          }
        },
      ),
      body: Stack(
        children: [
          const CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: _NoActiveSessionView(),
              ),
            ],
          ),

          if (_isEndingSession)
            Container(
              color: Colors.black.withOpacity(0.35),
              child: const Center(
                child: CircularProgressIndicator(color: AppColors.white),
              ),
            ),
        ],
      ),
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
            child: ElevatedButton.icon(
              onPressed: () => context.pushNamed(Routes.createSessionName),
              icon: const Icon(Icons.play_arrow_rounded, size: 26),
              label: Text(
                'Start Session',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
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
        ),
      ),
    );
  }
}

class _LecturerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String initials;
  final String greeting;
  final String name;
  final VoidCallback onHistoryTap;
  final VoidCallback onNameTap;

  const _LecturerAppBar({
    required this.initials,
    required this.greeting,
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
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: onNameTap,
              behavior: HitTestBehavior.opaque,
              child: Text(
                name,
                style: AppTextStyles.h2.copyWith(
                  fontSize: 20,
                  color: AppColors.primary,
                ),
              ),
            ),
            const Spacer(),
            PopupMenuButton<String>(
              tooltip: "",
              color: AppColors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              icon: Icon(Icons.more_vert, color: AppColors.primary, size: 28),
              onSelected: (value) {
                switch (value) {
                  case 'history':
                    onHistoryTap();
                    break;
                  case 'logout':
                    // TODO: logout logic
                    break;
                }
              },
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'history',
                      child: Text(
                        'History',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      value: 'logout',
                      child: Text(
                        'Log Out',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.error,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
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

class _SessionUiModel {
  final String codeAndVenue;
  final String title;
  final String endsIn;
  final int marked;
  final int manualRequests;
  final bool isLive;

  const _SessionUiModel({
    required this.codeAndVenue,
    required this.title,
    required this.endsIn,
    required this.marked,
    required this.manualRequests,
    required this.isLive,
  });
}

class _SessionCard extends StatefulWidget {
  final _SessionUiModel model;
  final String sessionId; // add this

  const _SessionCard({required this.model, required this.sessionId});

  @override
  State<_SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<_SessionCard> {
  late Duration _remainingTime;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
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
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            blurRadius: 18,
            offset: const Offset(0, 10),
            color: AppColors.primary.withOpacity(0.06),
          ),
        ],
        border: Border.all(color: AppColors.primary.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.model.codeAndVenue,
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
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              _LivePill(
                endsIn: _formatDuration(_remainingTime),
                isLive: widget.model.isLive,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Marked',
                  count: '${widget.model.marked}',
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatTile(
                  label: 'Denied',
                  count: '${widget.model.manualRequests}',
                  color: AppColors.accent,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          Container(height: 1, color: AppColors.primary.withOpacity(0.06)),

          const SizedBox(height: AppSpacing.lg),

          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  title: 'End Now',
                  subtitle: 'Close attendance',
                  icon: Icons.stop_circle_rounded,
                  tone: _ActionTone.danger,
                  onTap: () async {
                    final cubit = context.read<LecturerCubit>();

                    final confirmed = await AppDialog.confirm(
                      context: context,
                      title: "End Session?",
                      message: "This will close attendance for all students.",
                      confirmText: "End",
                    );

                    if (confirmed == true) {
                      cubit.endSession(widget.sessionId);
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _LivePill extends StatelessWidget {
  final String endsIn;
  final bool isLive;

  const _LivePill({required this.endsIn, required this.isLive});

  @override
  Widget build(BuildContext context) {
    final color = isLive ? AppColors.success : AppColors.warning;

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
            isLive ? 'Live' : 'Paused',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
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
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.sm,
        120,
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
                  AppAssets.lecturerNoSession,
                  height: 220,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  'No active session',
                  style: AppTextStyles.h2.copyWith(
                    fontSize: 22,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Start a session to begin taking attendance. ',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 14.5,
                    height: 1.45,
                    color: AppColors.textPrimary.withOpacity(0.85),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _StatTile({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: AppTextStyles.h2.copyWith(fontSize: 22, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary.withOpacity(0.75),
              fontWeight: FontWeight.w800,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

enum _ActionTone { primary, accent, neutral, danger }

class _ActionButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final _ActionTone tone;
  final VoidCallback onTap;

  const _ActionButton({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.tone,
    required this.onTap,
  });

  Color get _bg {
    switch (tone) {
      case _ActionTone.primary:
        return AppColors.primary.withOpacity(0.08);
      case _ActionTone.accent:
        return AppColors.accent.withOpacity(0.10);
      case _ActionTone.neutral:
        return AppColors.textPrimary.withOpacity(0.06);
      case _ActionTone.danger:
        return AppColors.error.withOpacity(0.10);
    }
  }

  Color get _border {
    switch (tone) {
      case _ActionTone.primary:
        return AppColors.primary.withOpacity(0.16);
      case _ActionTone.accent:
        return AppColors.accent.withOpacity(0.18);
      case _ActionTone.neutral:
        return AppColors.textPrimary.withOpacity(0.10);
      case _ActionTone.danger:
        return AppColors.error.withOpacity(0.18);
    }
  }

  Color get _iconColor {
    switch (tone) {
      case _ActionTone.primary:
        return AppColors.primary;
      case _ActionTone.accent:
        return AppColors.accent;
      case _ActionTone.neutral:
        return AppColors.textPrimary.withOpacity(0.85);
      case _ActionTone.danger:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: _border),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: _iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        fontSize: 14.2,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary.withOpacity(0.65),
                        fontWeight: FontWeight.w700,
                        fontSize: 12.2,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
