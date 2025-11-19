import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import '../constants/spacing.dart';

class AttendanceResult {
  static void show({
    required BuildContext context,
    required String title,
    required String emoji,
    required Color color,
    String? subtitle,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder:
          (overlayContext) => _AttendanceResultAnimation(
            title: title,
            emoji: emoji,
            color: color,
            subtitle: subtitle,
            onComplete: () => entry.remove(),
            duration: duration,
          ),
    );

    overlay.insert(entry);
  }

  static void success(BuildContext context) => show(
    context: context,
    title: "You're in!",
    emoji: "✅",
    color: AppColors.success,
    subtitle: "Attendance marked successfully",
  );

  static void pending(BuildContext context) => show(
    context: context,
    title: "Pending",
    emoji: "⏳",
    color: AppColors.warning,
    subtitle: "Waiting for lecturer approval",
  );

  static void failed(BuildContext context) => show(
    context: context,
    title: "Oops!",
    emoji: "🚫",
    color: AppColors.error,
    subtitle: "Device blocked — request override",
  );

  static void party(BuildContext context) => show(
    context: context,
    title: "You're all set!",
    emoji: "🎉",
    color: AppColors.success,
    subtitle: "Account created successfully",
  );
}

class _AttendanceResultAnimation extends StatefulWidget {
  final String title;
  final String emoji;
  final Color color;
  final String? subtitle;
  final VoidCallback onComplete;
  final Duration duration;

  const _AttendanceResultAnimation({
    required this.title,
    required this.emoji,
    required this.color,
    this.subtitle,
    required this.onComplete,
    required this.duration,
  });

  @override
  State<_AttendanceResultAnimation> createState() =>
      _AttendanceResultAnimationState();
}

class _AttendanceResultAnimationState extends State<_AttendanceResultAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _controller.forward();

    Future.delayed(widget.duration, () {
      if (mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: widget.color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.4), blurRadius: 30),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(widget.emoji, style: const TextStyle(fontSize: 120)),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  widget.title,
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 36,
                    color: AppColors.white,
                  ),
                ),
                if (widget.subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.md),
                    child: Text(
                      widget.subtitle!,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
