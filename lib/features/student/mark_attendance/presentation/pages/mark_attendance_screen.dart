import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:attend/features/student/mark_attendance/attendance_sim_result.dart';
import 'package:attend/global/components/app_toast.dart';
import 'package:attend/global/components/loading_overlay.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class MarkAttendanceScreen extends StatefulWidget {
  const MarkAttendanceScreen({
    super.key,
    required this.sessionCode,
    required this.sessionTitle,
    required this.lecturerName,
    required this.venue,
    this.simResult = AttendanceSimResult.success,
  });

  final String sessionCode;
  final String sessionTitle;
  final String lecturerName;
  final String venue;
  final AttendanceSimResult simResult;

  @override
  State<MarkAttendanceScreen> createState() => _MarkAttendanceScreenState();
}

class _MarkAttendanceScreenState extends State<MarkAttendanceScreen> {
  bool _locationVerified = false;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startFlow());
  }

  Future<void> _startFlow() async {
    if (_busy) return;
    _busy = true;

    final okLocation = await _verifyLocation();
    if (!mounted) return;
    if (!okLocation) {
      _busy = false;
      Navigator.pop(context);
      return;
    }

    final okCamera = await _ensureCameraPermission();
    if (!mounted) return;
    if (!okCamera) {
      _busy = false;
      Navigator.pop(context);
      return;
    }

    // Camera opens immediately — no intermediate explainer UI
    final selfiePath = await Navigator.of(context).push<String?>(
      MaterialPageRoute(
        builder:
            (_) => SelfieCaptureScreen(
              sessionCode: widget.sessionCode,
              sessionTitle: widget.sessionTitle,
              lecturerName: widget.lecturerName,
              venue: widget.venue,
            ),
      ),
    );

    if (!mounted) return;
    if (selfiePath == null) {
      _busy = false;
      Navigator.pop(context);
      return;
    }

    // Preview loop: retake/use
    String currentPath = selfiePath;
    while (mounted) {
      final decision = await Navigator.of(context).push<_PreviewDecision?>(
        MaterialPageRoute(
          builder:
              (_) => SelfiePreviewScreen(
                selfiePath: currentPath,
                sessionCode: widget.sessionCode,
                sessionTitle: widget.sessionTitle,
                lecturerName: widget.lecturerName,
                venue: widget.venue,
              ),
        ),
      );

      if (!mounted) return;

      if (decision == _PreviewDecision.use) {
        await _finalizeAttendance(currentPath);
        break;
      }

      if (decision == _PreviewDecision.retake) {
        final newPath = await Navigator.of(context).push<String?>(
          MaterialPageRoute(
            builder:
                (_) => SelfieCaptureScreen(
                  sessionCode: widget.sessionCode,
                  sessionTitle: widget.sessionTitle,
                  lecturerName: widget.lecturerName,
                  venue: widget.venue,
                ),
          ),
        );

        if (!mounted) return;
        if (newPath == null) {
          _busy = false;
          Navigator.pop(context);
          return;
        }

        currentPath = newPath;
        continue;
      }

      // back pressed on preview
      _busy = false;
      Navigator.pop(context);
      return;
    }

    _busy = false;
  }

  Future<bool> _verifyLocation() async {
    LoadingOverlay.show(context, message: "Verifying your location…");
    try {
      await Future.delayed(const Duration(seconds: 2)); // TODO: real location
      _locationVerified = true;
      return true;
    } catch (_) {
      AppToast.show(
        context: context,
        message: "Couldn’t verify your location",
        type: ToastType.error,
      );
      return false;
    } finally {
      LoadingOverlay.hide();
    }
  }

  Future<bool> _ensureCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      final open = await _showGoToSettingsSheet();
      if (open == true) await openAppSettings();
      return false;
    }

    final proceed = await _showCameraRationaleSheet();
    if (proceed != true) return false;

    final request = await Permission.camera.request();
    if (request.isGranted) return true;

    if (request.isPermanentlyDenied) {
      final open = await _showGoToSettingsSheet();
      if (open == true) await openAppSettings();
    } else {
      AppToast.show(
        context: context,
        message: "Camera permission denied",
        type: ToastType.error,
      );
    }
    return false;
  }

  Future<void> _finalizeAttendance(String selfiePath) async {
    LoadingOverlay.show(context, message: "Finalizing attendance…");
    await Future.delayed(const Duration(seconds: 2));
    LoadingOverlay.hide();

    switch (widget.simResult) {
      case AttendanceSimResult.success:
        AppToast.show(
          context: context,
          message: "Attendance marked successfully!",
          type: ToastType.success,
        );
        await Future.delayed(const Duration(milliseconds: 900));
        if (mounted) context.goNamed(Routes.studentHomeName);
        return;

      case AttendanceSimResult.deviceBlocked:
        AppToast.show(
          context: context,
          message: "This isn't your phone — override required",
          type: ToastType.error,
        );
        await Future.delayed(const Duration(milliseconds: 900));
        if (mounted) context.goNamed(Routes.requestManualOverrideName);
        return;
    }
  }

  Future<bool?> _showCameraRationaleSheet() {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (_) {
        return _RationaleSheet(
          title: "Camera access needed",
          body: "We use a selfie to prevent attendance fraud.",
          primaryText: "Continue",
          secondaryText: "Not now",
          onPrimary: () => Navigator.pop(context, true),
          onSecondary: () => Navigator.pop(context, false),
        );
      },
    );
  }

  Future<bool?> _showGoToSettingsSheet() {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (_) {
        return _RationaleSheet(
          title: "Camera permission blocked",
          body:
              "Camera access is disabled in settings. Enable it to mark attendance.",
          primaryText: "Open settings",
          secondaryText: "Not now",
          onPrimary: () => Navigator.pop(context, true),
          onSecondary: () => Navigator.pop(context, false),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This should be barely seen.
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _SessionAppBar(
        code: widget.sessionCode,
        title: widget.sessionTitle,
        meta: "${widget.venue} • ${widget.lecturerName}",
        onClose: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Container(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.security_rounded, color: AppColors.accent, size: 34),
              const SizedBox(height: AppSpacing.md),
              Text(
                "Preparing attendance…",
                style: AppTextStyles.h2.copyWith(
                  fontSize: 18,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                "Opening your camera now.",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary.withOpacity(0.75),
                  fontWeight: FontWeight.w600,
                  height: 1.35,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// -------------------- CAMERA SCREEN (REAL + MIRROR + OVERLAY + LOW-LIGHT CHECK) --------------------
class SelfieCaptureScreen extends StatefulWidget {
  const SelfieCaptureScreen({
    super.key,
    required this.sessionCode,
    required this.sessionTitle,
    required this.lecturerName,
    required this.venue,
  });

  final String sessionCode;
  final String sessionTitle;
  final String lecturerName;
  final String venue;

  @override
  State<SelfieCaptureScreen> createState() => _SelfieCaptureScreenState();
}

class _SelfieCaptureScreenState extends State<SelfieCaptureScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  bool _initializing = true;
  bool _capturing = false;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null) return;

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    setState(() => _initializing = true);

    try {
      final cameras = await availableCameras();

      final frontList =
          cameras
              .where((c) => c.lensDirection == CameraLensDirection.front)
              .toList();

      final CameraDescription cam =
          frontList.isNotEmpty ? frontList.first : cameras.first;

      _isFront = cam.lensDirection == CameraLensDirection.front;

      final controller = CameraController(
        cam,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await controller.initialize();
      await controller.setFlashMode(FlashMode.off);

      if (!mounted) return;

      await _controller?.dispose();
      setState(() {
        _controller = controller;
        _initializing = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _controller = null;
        _initializing = false;
      });

      AppToast.show(
        context: context,
        message: "Couldn’t open camera",
        type: ToastType.error,
      );
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) Navigator.pop(context, null);
    }
  }

  Future<void> _capture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (_capturing) return;

    setState(() => _capturing = true);

    try {
      final file = await controller.takePicture();

      // Low-light check (real luminance heuristic)
      final isDark = await _isLowLight(file.path);

      if (!mounted) return;

      if (isDark) {
        final useAnyway = await _showLowLightSheet();
        if (!mounted) return;

        if (useAnyway != true) {
          setState(() => _capturing = false);
          return; // retake: stay on camera
        }
      }

      Navigator.pop(context, file.path);
    } catch (_) {
      if (!mounted) return;
      setState(() => _capturing = false);
      AppToast.show(
        context: context,
        message: "Failed to capture selfie",
        type: ToastType.error,
      );
    }
  }

  /// Computes average luminance by decoding the JPEG and sampling pixels.
  /// No extra packages.
  Future<bool> _isLowLight(String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      final ui.Image img = await _decodeUiImage(bytes);

      // Downsample sampling grid (fast)
      final sampleStepX = max(1, img.width ~/ 48);
      final sampleStepY = max(1, img.height ~/ 48);

      final byteData = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) return false;

      final data = byteData.buffer.asUint8List();

      double sum = 0;
      int count = 0;

      for (int y = 0; y < img.height; y += sampleStepY) {
        for (int x = 0; x < img.width; x += sampleStepX) {
          final i = (y * img.width + x) * 4;
          if (i + 3 >= data.length) continue;

          final r = data[i];
          final g = data[i + 1];
          final b = data[i + 2];

          // Perceived luminance (sRGB approx)
          final luma = 0.2126 * r + 0.7152 * g + 0.0722 * b;
          sum += luma;
          count++;
        }
      }

      final avg = count == 0 ? 255.0 : sum / count;

      // Threshold tuned for indoor low-light (adjust if needed)
      return avg < 70.0;
    } catch (_) {
      return false;
    }
  }

  Future<ui.Image> _decodeUiImage(Uint8List bytes) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });
    return completer.future;
  }

  Future<bool?> _showLowLightSheet() {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (_) {
        return _RationaleSheet(
          title: "Low light detected",
          body:
              "Your selfie looks too dark. Retake in better lighting for a smoother verification.",
          primaryText: "Use anyway",
          secondaryText: "Retake",
          onPrimary: () => Navigator.pop(context, true),
          onSecondary: () => Navigator.pop(context, false),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _SessionAppBar(
        code: widget.sessionCode,
        title: widget.sessionTitle,
        meta: "${widget.venue} • ${widget.lecturerName}",
        onClose: () => Navigator.pop(context, null),
        dark: true,
      ),
      body: Stack(
        children: [
          // Preview
          Positioned.fill(
            child:
                _initializing
                    ? Center(
                      child: CircularProgressIndicator(color: AppColors.accent),
                    )
                    : (controller == null
                        ? const SizedBox.shrink()
                        : _MirroredPreview(
                          mirror: _isFront,
                          child: CameraPreview(controller),
                        )),
          ),

          // Face framing overlay
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _FaceGuidePainter()),
            ),
          ),

          // Helper text
          Positioned(
            left: AppSpacing.xl,
            right: AppSpacing.xl,
            top: AppSpacing.lg,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.45),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white.withOpacity(0.12)),
              ),
              child: Text(
                "Center your face and ensure good lighting",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.92),
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.md,
                  AppSpacing.xl,
                  AppSpacing.lg,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 56,
                      height: 56,
                      child: Material(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () => Navigator.pop(context, null),
                          child: Icon(
                            Icons.close_rounded,
                            color: Colors.white.withOpacity(0.92),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: SizedBox(
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              (_initializing || _capturing) ? null : _capture,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.white,
                            disabledBackgroundColor: AppColors.white
                                .withOpacity(0.5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                          child: Text(
                            _capturing ? "Capturing…" : "Capture selfie",
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              fontSize: 16,
                            ),
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
      ),
    );
  }
}

class _MirroredPreview extends StatelessWidget {
  final bool mirror;
  final Widget child;

  const _MirroredPreview({required this.mirror, required this.child});

  @override
  Widget build(BuildContext context) {
    // if (!mirror) return child;
    // return Transform(
    //   alignment: Alignment.center,
    //   transform: Matrix4.identity()..scale(-1.0, 1.0, 1.0),
    //   child: child,
    // );
    return child;
  }
}

/// Subtle face framing: circle + corner ticks.
class _FaceGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) * 0.28;

    final ringPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..color = Colors.white.withOpacity(0.22);

    canvas.drawCircle(center, radius, ringPaint);

    final tickPaint =
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3
          ..strokeCap = StrokeCap.round
          ..color = Colors.white.withOpacity(0.22);

    final rect = Rect.fromCircle(center: center, radius: radius);
    final pad = 18.0;

    // Top-left
    canvas.drawLine(
      Offset(rect.left + pad, rect.top + pad),
      Offset(rect.left + pad + 22, rect.top + pad),
      tickPaint,
    );
    canvas.drawLine(
      Offset(rect.left + pad, rect.top + pad),
      Offset(rect.left + pad, rect.top + pad + 22),
      tickPaint,
    );

    // Top-right
    canvas.drawLine(
      Offset(rect.right - pad, rect.top + pad),
      Offset(rect.right - pad - 22, rect.top + pad),
      tickPaint,
    );
    canvas.drawLine(
      Offset(rect.right - pad, rect.top + pad),
      Offset(rect.right - pad, rect.top + pad + 22),
      tickPaint,
    );

    // Bottom-left
    canvas.drawLine(
      Offset(rect.left + pad, rect.bottom - pad),
      Offset(rect.left + pad + 22, rect.bottom - pad),
      tickPaint,
    );
    canvas.drawLine(
      Offset(rect.left + pad, rect.bottom - pad),
      Offset(rect.left + pad, rect.bottom - pad - 22),
      tickPaint,
    );

    // Bottom-right
    canvas.drawLine(
      Offset(rect.right - pad, rect.bottom - pad),
      Offset(rect.right - pad - 22, rect.bottom - pad),
      tickPaint,
    );
    canvas.drawLine(
      Offset(rect.right - pad, rect.bottom - pad),
      Offset(rect.right - pad, rect.bottom - pad - 22),
      tickPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// -------------------- PREVIEW SCREEN --------------------
enum _PreviewDecision { retake, use }

class SelfiePreviewScreen extends StatelessWidget {
  const SelfiePreviewScreen({
    super.key,
    required this.selfiePath,
    required this.sessionCode,
    required this.sessionTitle,
    required this.lecturerName,
    required this.venue,
  });

  final String selfiePath;
  final String sessionCode;
  final String sessionTitle;
  final String lecturerName;
  final String venue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _SessionAppBar(
        code: sessionCode,
        title: sessionTitle,
        meta: "$venue • $lecturerName",
        onClose: () => Navigator.pop(context, null),
        dark: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.file(File(selfiePath), fit: BoxFit.cover),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.xl,
                  AppSpacing.md,
                  AppSpacing.xl,
                  AppSpacing.lg,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),
                      child: Text(
                        "Make sure your face is clear and well-lit",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withOpacity(0.92),
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: OutlinedButton.icon(
                              onPressed:
                                  () => Navigator.pop(
                                    context,
                                    _PreviewDecision.retake,
                                  ),
                              icon: const Icon(Icons.refresh_rounded),
                              label: Text(
                                "Retake",
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white.withOpacity(0.92),
                                  fontSize: 16,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  color: Colors.white.withOpacity(0.25),
                                ),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: SizedBox(
                            height: 56,
                            child: ElevatedButton.icon(
                              onPressed:
                                  () => Navigator.pop(
                                    context,
                                    _PreviewDecision.use,
                                  ),
                              icon: const Icon(Icons.check_rounded, size: 22),
                              label: Text(
                                "Use this photo",
                                style: AppTextStyles.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.white,
                                foregroundColor: AppColors.primary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// -------------------- SESSION APP BAR --------------------
class _SessionAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String code;
  final String title;
  final String meta;
  final VoidCallback onClose;
  final bool dark;

  const _SessionAppBar({
    required this.code,
    required this.title,
    required this.meta,
    required this.onClose,
    this.dark = false,
  });

  @override
  Size get preferredSize => const Size.fromHeight(86);

  @override
  Widget build(BuildContext context) {
    final bg = dark ? Colors.black : AppColors.background;
    final primaryText = dark ? Colors.white : AppColors.primary;
    final secondaryText =
        dark
            ? Colors.white.withOpacity(0.75)
            : AppColors.textPrimary.withOpacity(0.65);
    final divider =
        dark
            ? Colors.white.withOpacity(0.10)
            : AppColors.primary.withOpacity(0.06);

    return AppBar(
      backgroundColor: bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: IconButton(
        icon: Icon(Icons.close_rounded, color: primaryText),
        onPressed: onClose,
      ),
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(right: AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              code,
              style: AppTextStyles.h2.copyWith(
                fontSize: 18,
                color: primaryText,
                height: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "$title\n$meta",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodyMedium.copyWith(
                color: secondaryText,
                fontWeight: FontWeight.w700,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: divider),
      ),
    );
  }
}

/// -------------------- RATIONALE SHEET --------------------
class _RationaleSheet extends StatelessWidget {
  final String title;
  final String body;
  final String primaryText;
  final String secondaryText;
  final VoidCallback onPrimary;
  final VoidCallback onSecondary;

  const _RationaleSheet({
    required this.title,
    required this.body,
    required this.primaryText,
    required this.secondaryText,
    required this.onPrimary,
    required this.onSecondary,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Column(
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
            body,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary.withOpacity(0.8),
              fontWeight: FontWeight.w600,
              height: 1.35,
              fontSize: 14.8,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: 56,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPrimary,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                primaryText,
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
              onPressed: onSecondary,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary.withOpacity(0.18)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                secondaryText,
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
