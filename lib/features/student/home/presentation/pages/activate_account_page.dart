import 'dart:io';

import 'package:attend/features/student/home/presentation/widgets/level_button_widget.dart';
import 'package:attend/global/components/app_dialog.dart';
import 'package:attend/global/components/loading_overlay.dart';
import 'package:attend/global/constants/assets.dart';
import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/spacing.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ActivateAccountPage extends StatefulWidget {
  final VoidCallback onActivated;
  final String userEmail;

  const ActivateAccountPage({
    super.key,
    required this.onActivated,
    required this.userEmail,
  });

  @override
  State<ActivateAccountPage> createState() => _ActivateAccountPageState();
}

class _ActivateAccountPageState extends State<ActivateAccountPage> {
  String? _selectedLevel;
  XFile? _pickedImage;

  Future<void> _pickAndCropImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Document',
          toolbarColor: AppColors.primary,
          toolbarWidgetColor: Colors.white,
          backgroundColor: AppColors.white,
          activeControlsWidgetColor: AppColors.accent,
          cropFrameColor: AppColors.accent,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Document'),
      ],
    );

    if (cropped != null && mounted) {
      setState(() => _pickedImage = XFile(cropped.path));
      _simulateExtraction();
    }
  }

  Future<void> _simulateExtraction() async {
    LoadingOverlay.show(context);
    await Future.delayed(const Duration(seconds: 3));
    LoadingOverlay.hide();

    if (!mounted) return;

    final confirmed = await AppDialog.confirm(
      context: context,
      title: "Is this correct?",
      message:
          _selectedLevel == "100L"
              ? "Extracted from Course Form:\n\nName: Elijah Chibueze\nMatric No: 22/SCI/00817\nLevel: 100 Level\nDepartment: Computer Science"
              : "Extracted from Results:\n\nName: Elijah Chibueze\nMatric No: 19/ENG/00421\nLevel: 400 Level\nDepartment: Software Engineering",
      confirmText: "Yes, Activate",
      cancelText: "Retake Photo",
    );

    if (confirmed == true) {
      widget.onActivated();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Hello👋, ',
              style: AppTextStyles.h2.copyWith(
                fontSize: 20,
                color: AppColors.primary,
              ),
            ),
            Text(
              widget.userEmail,
              style: AppTextStyles.h2.copyWith(
                fontSize: 18,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
          child: Column(
            children: [
              SizedBox(height: AppSpacing.md),

              // Hero illustration
              Center(
                child: Image.asset(AppAssets.signupStudentHero, height: 240),
              ),

              SizedBox(height: AppSpacing.xxl),

              // Headline
              Text(
                'Activate Your Account',
                style: AppTextStyles.h1.copyWith(
                  fontSize: 38,
                  color: AppColors.primary,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: AppSpacing.lg),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                child: Text(
                  'Verify your student status to start marking attendance',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 17,
                    height: 1.5,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: AppSpacing.xxl),

              // Level Selection
              Text(
                "What's your current level?",
                style: AppTextStyles.bodyLarge.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),

              SizedBox(height: AppSpacing.md),

              Row(
                children: [
                  Expanded(
                    child: LevelButtonWidget(
                      label: "100L",
                      isSelected: _selectedLevel == "100L",
                      onTap: () => setState(() => _selectedLevel = "100L"),
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: LevelButtonWidget(
                      label: "200L–600L",
                      isSelected: _selectedLevel == "200L+",
                      onTap: () => setState(() => _selectedLevel = "200L+"),
                    ),
                  ),
                ],
              ),

              SizedBox(height: AppSpacing.xl),

              // Document Upload Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(AppSpacing.xl),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.15),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.08),
                      blurRadius: 30,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Icon + Title
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.school_rounded,
                        size: 48,
                        color: AppColors.accent,
                      ),
                    ),

                    SizedBox(height: AppSpacing.xl),

                    Text(
                      _selectedLevel == "100L"
                          ? "Upload your Course Form"
                          : _selectedLevel == "200L+"
                          ? "Upload last semester Results"
                          : "Select your level first",
                      style: AppTextStyles.h2.copyWith(
                        fontSize: 22,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),

                    SizedBox(height: AppSpacing.xl),

                    // Image Preview
                    GestureDetector(
                      onTap: _selectedLevel != null ? _pickAndCropImage : null,
                      child: Container(
                        height: 220,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child:
                            _pickedImage != null
                                ? ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.file(
                                    File(_pickedImage!.path),
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (_, __, ___) => Icon(
                                          Icons.error,
                                          size: 60,
                                          color: AppColors.error,
                                        ),
                                  ),
                                )
                                : Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.cloud_upload_outlined,
                                      size: 64,
                                      color: AppColors.primary.withOpacity(0.4),
                                    ),
                                    SizedBox(height: AppSpacing.md),
                                    Text(
                                      'Tap the button below to upload',
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: AppColors.primary.withOpacity(
                                          0.6,
                                        ),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: AppSpacing.xxl),

              // Activate Button
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  onPressed:
                      _selectedLevel != null && _pickedImage != null
                          ? _simulateExtraction
                          : _selectedLevel != null
                          ? _pickAndCropImage
                          : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 12,
                    shadowColor: AppColors.primary.withOpacity(0.4),
                  ),
                  child: Text(
                    _pickedImage != null
                        ? "Verify & Activate"
                        : "Upload Document",
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}
