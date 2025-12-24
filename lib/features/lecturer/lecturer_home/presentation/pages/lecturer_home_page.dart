import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LecturerHomePage extends StatelessWidget {
  const LecturerHomePage({super.key});

  // Toggle to test both states
  final bool hasActiveSession = true;

  @override
  Widget build(BuildContext context) {
    final sessions =
        hasActiveSession
            ? <_SessionUiModel>[
              _SessionUiModel(
                codeAndVenue: 'CSC 301 • 1k Cap',
                title: 'Data Structures & Algorithms',
                endsIn: '42:15',
                marked: 47,
                manualRequests: 2,
                isLive: true,
              ),
              // _SessionUiModel(
              //   codeAndVenue: 'CSC 401 • LH 201',
              //   title: 'Operating Systems',
              //   endsIn: '18:02',
              //   marked: 31,
              //   manualRequests: 0,
              //   isLive: true,
              // ),
            ]
            : <_SessionUiModel>[];

    return Scaffold(
      backgroundColor: AppColors.background,

      // ✅ Proper top bar as AppBar (not part of body)
      appBar: _LecturerAppBar(
        initials: 'DO',
        greeting: 'Welcome back sir',
        name: 'Dr. Okafor',
        onHistoryTap: () {
          // TODO: context.goNamed(Routes.pastSessionsName);
        },
      ),

      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),

          if (sessions.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: _NoActiveSessionView(),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.sm,
                120, // room for bottom CTA
              ),
              sliver: SliverList.separated(
                itemCount: sessions.length,
                separatorBuilder:
                    (_, __) => const SizedBox(height: AppSpacing.lg),
                itemBuilder: (_, i) => _SessionCard(model: sessions[i]),
              ),
            ),
        ],
      ),

      // ✅ Bottom pinned CTA (fixes the "off" floating button vibe)
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
              onPressed: () => context.goNamed(Routes.createSessionName),
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
                elevation: 0, // cleaner than FAB shadow
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

  const _LecturerAppBar({
    required this.initials,
    required this.greeting,
    required this.name,
    required this.onHistoryTap,
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
              backgroundColor: AppColors.accent.withOpacity(0.14),
              child: Text(
                initials,
                style: AppTextStyles.h2.copyWith(
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  greeting,
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

      // ✅ subtle divider so header feels “anchored”
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

class _SessionCard extends StatelessWidget {
  final _SessionUiModel model;

  const _SessionCard({required this.model});

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
          // Header row: title + live pill
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.codeAndVenue,
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
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              _LivePill(endsIn: model.endsIn, isLive: model.isLive),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Stats row (inside same card)
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Marked',
                  count: '${model.marked}',
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _StatTile(
                  label: 'Denied',
                  count: '${model.manualRequests}',
                  color: AppColors.accent,
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          // Divider to unify actions with session content (not separate card)
          Container(height: 1, color: AppColors.primary.withOpacity(0.06)),

          const SizedBox(height: AppSpacing.lg),

          Text(
            'Actions',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary.withOpacity(0.65),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          // Actions grid (still within same card)
          Row(
            children: [
              Expanded(
                child: _ActionButton(
                  title: 'End Now',
                  subtitle: 'Close attendance',
                  icon: Icons.stop_circle_rounded,
                  tone: _ActionTone.danger,
                  onTap: () {
                    // TODO: end this session
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _ActionButton(
                  title: 'Extend Time',
                  subtitle: 'Add to the duration',
                  icon: Icons.timer_rounded,
                  tone: _ActionTone.primary,
                  onTap: () {
                    // TODO: extend this session
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
            isLive ? 'Live • $endsIn' : 'Paused',
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
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.xl,
        120, // room for bottom CTA
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top-aligned, not floating in the middle
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
                  'No active sessions',
                  style: AppTextStyles.h2.copyWith(
                    fontSize: 22,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Start a session to begin taking attendance. You can run multiple sessions when needed.',
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

          // A small “hint” block to reduce emptiness and guide usage
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
                    Icons.info_outline_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    'Tip: If you teach back-to-back classes, start each session separately so the attendance lists don’t mix.',
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
