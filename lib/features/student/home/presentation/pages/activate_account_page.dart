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
  const ActivateAccountPage({super.key, required this.onActivated});

  @override
  State<ActivateAccountPage> createState() => ActivateAccountPageState();
}

class ActivateAccountPageState extends State<ActivateAccountPage> {
  String? _selectedLevel;
  XFile? _pickedImage;

  Future<void> _pickAndCropImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked == null) return;

    final cropped = await ImageCropper().cropImage(
      sourcePath: picked.path,
      // aspectRatioPresets: [CropAspectRatioPreset.ratio4x3],
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

    if (cropped != null) {
      setState(() => _pickedImage = XFile(cropped.path));
      _simulateExtraction();
    }
  }

  Future<void> _simulateExtraction() async {
    LoadingOverlay.show(context);
    await Future.delayed(const Duration(seconds: 3));

    LoadingOverlay.hide();

    if (!mounted) return;

    // Show extracted data confirmation
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: AppSpacing.xl),
                Image.asset(AppAssets.signupStudentHero, height: 260),

                SizedBox(height: AppSpacing.xxl),

                Text(
                  'Activate Your Account',
                  style: AppTextStyles.h1.copyWith(
                    fontSize: 36,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppSpacing.lg),

                Text(
                  'We need to verify your student status before you can mark attendance',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 17,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),

                SizedBox(height: AppSpacing.xxl),

                // Level Selection
                Text(
                  'Select your current level',
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
                    SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: LevelButtonWidget(
                        label: "200L–600L",
                        isSelected: _selectedLevel == "200L+",
                        onTap: () => setState(() => _selectedLevel = "200L+"),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: AppSpacing.xxl),

                // Document Upload Card
                Container(
                  padding: EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.description_rounded,
                        size: 48,
                        color: AppColors.accent,
                      ),
                      SizedBox(height: AppSpacing.md),
                      Text(
                        _selectedLevel == "100L"
                            ? "Upload your Course Form"
                            : _selectedLevel == "200L+"
                            ? "Upload last semester Results"
                            : "Select level first",
                        style: AppTextStyles.h2.copyWith(fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.lg),
                      if (_pickedImage != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(_pickedImage!.path),
                            height: 200,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.primary.withOpacity(0.1),
                                child: Icon(
                                  Icons.error_outline,
                                  color: AppColors.primary,
                                  size: 50,
                                ),
                              );
                            },
                          ),
                        )
                      else
                        Container(
                          height: 180,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.2),
                              // style: BorderStyle.solid,
                            ),
                          ),
                          child: Icon(
                            Icons.add_a_photo_outlined,
                            size: 50,
                            color: AppColors.primary.withOpacity(0.5),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Activate Button
                SizedBox(
                  width: double.infinity,
                  height: 64,
                  child: ElevatedButton(
                    onPressed:
                        _selectedLevel != null ? _pickAndCropImage : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: AppColors.primary.withOpacity(
                        0.3,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      _pickedImage != null
                          ? "Re-upload Document"
                          : "Upload & Activate",
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
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
      ),
    );
  }
}
