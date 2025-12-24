import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:attend/global/components/app_toast.dart';
import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:attend/global/routes/routes.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestManualOverridePage extends StatefulWidget {
  const RequestManualOverridePage({
    super.key,
    this.sessionCode = 'CSC 301',
    this.sessionTitle = 'Data Structures & Algorithms',
    this.lecturerName = 'Dr. Adebayo',
    this.venue = 'LH 201',
  });

  final String sessionCode;
  final String sessionTitle;
  final String lecturerName;
  final String venue;

  @override
  State<RequestManualOverridePage> createState() =>
      _RequestManualOverridePageState();
}

class _RequestManualOverridePageState extends State<RequestManualOverridePage> {
  String? _selfiePath;

  bool get hasSelfie => _selfiePath != null;

  Future<void> _takeSelfie() async {
    final ok = await _ensureCameraPermission();
    if (!mounted) return;
    if (!ok) return;

    final path = await Navigator.of(context).push<String?>(
      MaterialPageRoute(
        builder:
            (_) => OverrideSelfieCaptureScreen(
              sessionCode: widget.sessionCode,
              sessionTitle: widget.sessionTitle,
              lecturerName: widget.lecturerName,
              venue: widget.venue,
            ),
      ),
    );

    if (!mounted) return;
    if (path == null) return;

    setState(() => _selfiePath = path);
  }

  void _retakeSelfie() => setState(() => _selfiePath = null);

  Future<bool> _ensureCameraPermission() async {
    final status = await Permission.camera.status;

    if (status.isGranted) return true;

    if (status.isPermanentlyDenied) {
      final open = await _showGoToSettingsSheet();
      if (open == true) {
        await openAppSettings();
      }
      return false;
    }

    final proceed = await _showCameraRationaleSheet();
    if (proceed != true) return false;

    final request = await Permission.camera.request();
    if (request.isGranted) return true;

    if (request.isPermanentlyDenied) {
      final open = await _showGoToSettingsSheet();
      if (open == true) {
        await openAppSettings();
      }
    } else {
      AppToast.show(
        context: context,
        message: "Camera permission denied",
        type: ToastType.error,
      );
    }

    return false;
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
              "Camera access is disabled in settings. Enable it to request override.",
          primaryText: "Open settings",
          secondaryText: "Not now",
          onPrimary: () => Navigator.pop(context, true),
          onSecondary: () => Navigator.pop(context, false),
        );
      },
    );
  }

  Future<void> _sendRequest() async {
    if (!hasSelfie) return;

    // TODO: call your backend here (await ...)
    // await overrideRepo.sendRequest(...);

    AppToast.show(
      context: context,
      message: "Override request sent",
      type: ToastType.success,
    );

    // Give the toast time to be seen
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    // Go back to homepage and clear this flow
    context.goNamed(Routes.studentHomeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _SessionAppBar(
        code: widget.sessionCode,
        title: widget.sessionTitle,
        meta: '${widget.venue} • ${widget.lecturerName}',
        onClose: () => Navigator.pop(context),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              0,
              AppSpacing.xl,
              140,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // ✅ ONE CARD (status + selfie) to remove “separate card” feeling
                  Container(
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
                        // Header
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.error.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.block_rounded,
                                color: AppColors.error,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Device blocked',
                                    style: AppTextStyles.h2.copyWith(
                                      fontSize: 20,
                                      color: AppColors.primary,
                                      height: 1.1,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "This phone is tied to another student’s account. "
                                    "Take a selfie in class and request an override for this session.",
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.textPrimary.withOpacity(
                                        0.75,
                                      ),
                                      fontWeight: FontWeight.w600,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        Container(
                          height: 1,
                          color: AppColors.primary.withOpacity(0.06),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Selfie section title
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.accent.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                Icons.camera_alt_rounded,
                                color: AppColors.accent,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Text(
                                'Selfie for override',
                                style: AppTextStyles.bodyLarge.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Make sure your face is clear and well-lit.',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary.withOpacity(0.72),
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Preview
                        Container(
                          height: 240,
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color:
                                  hasSelfie
                                      ? AppColors.accent.withOpacity(0.30)
                                      : AppColors.primary.withOpacity(0.10),
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child:
                                hasSelfie
                                    ? Image.file(
                                      File(_selfiePath!),
                                      fit: BoxFit.cover,
                                    )
                                    : Stack(
                                      children: [
                                        Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 10,
                                            ),
                                            decoration: BoxDecoration(
                                              color: AppColors.white
                                                  .withOpacity(0.92),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              border: Border.all(
                                                color: AppColors.primary
                                                    .withOpacity(0.08),
                                              ),
                                            ),
                                            child: Text(
                                              'No selfie yet',
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                    color: AppColors.textPrimary
                                                        .withOpacity(0.75),
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.lg),

                        // Actions inside the card
                        if (!hasSelfie)
                          SizedBox(
                            height: 54,
                            child: OutlinedButton.icon(
                              onPressed: _takeSelfie,
                              icon: Icon(
                                Icons.camera_alt_rounded,
                                color: AppColors.primary,
                              ),
                              label: Text(
                                'Take selfie',
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
                          )
                        else
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 54,
                                  child: OutlinedButton.icon(
                                    onPressed: _takeSelfie, // open camera again
                                    icon: Icon(
                                      Icons.refresh_rounded,
                                      color: AppColors.primary,
                                    ),
                                    label: Text(
                                      'Retake',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primary,
                                        fontSize: 15.5,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(
                                        color: AppColors.primary.withOpacity(
                                          0.18,
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppSpacing.md),
                              Expanded(
                                child: SizedBox(
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: _sendRequest,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: AppColors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: Text(
                                      'Send request',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.white,
                                        fontSize: 15.5,
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
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom CTA: single & consistent
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
              onPressed: hasSelfie ? _sendRequest : null,
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
                hasSelfie
                    ? 'Send override request'
                    : 'Take a selfie to continue',
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w900,
                  color: AppColors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// -------------------- SELFIE CAPTURE SCREEN (reused patterns) --------------------
class OverrideSelfieCaptureScreen extends StatefulWidget {
  const OverrideSelfieCaptureScreen({
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
  State<OverrideSelfieCaptureScreen> createState() =>
      _OverrideSelfieCaptureScreenState();
}

class _OverrideSelfieCaptureScreenState
    extends State<OverrideSelfieCaptureScreen>
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
      final front =
          cameras
              .where((c) => c.lensDirection == CameraLensDirection.front)
              .toList();

      final cam = front.isNotEmpty ? front.first : cameras.first;
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

      final isDark = await _isLowLight(file.path);
      if (!mounted) return;

      if (isDark) {
        final useAnyway = await _showLowLightSheet();
        if (!mounted) return;

        if (useAnyway != true) {
          setState(() => _capturing = false);
          return; // stay on camera, retake
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

  Future<bool> _isLowLight(String path) async {
    try {
      final bytes = await File(path).readAsBytes();
      final img = await _decodeUiImage(bytes);

      final stepX = max(1, img.width ~/ 48);
      final stepY = max(1, img.height ~/ 48);

      final byteData = await img.toByteData(format: ui.ImageByteFormat.rawRgba);
      if (byteData == null) return false;

      final data = byteData.buffer.asUint8List();

      double sum = 0;
      int count = 0;

      for (int y = 0; y < img.height; y += stepY) {
        for (int x = 0; x < img.width; x += stepX) {
          final i = (y * img.width + x) * 4;
          if (i + 3 >= data.length) continue;

          final r = data[i];
          final g = data[i + 1];
          final b = data[i + 2];
          final luma = 0.2126 * r + 0.7152 * g + 0.0722 * b;

          sum += luma;
          count++;
        }
      }

      final avg = count == 0 ? 255.0 : sum / count;
      return avg < 70.0;
    } catch (_) {
      return false;
    }
  }

  Future<ui.Image> _decodeUiImage(Uint8List bytes) {
    final completer = Completer<ui.Image>();
    ui.decodeImageFromList(bytes, (img) => completer.complete(img));
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

          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _FaceGuidePainter()),
            ),
          ),

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
    return child;
  }
}

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

    // top-left
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

    // top-right
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

    // bottom-left
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

    // bottom-right
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
