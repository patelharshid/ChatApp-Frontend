import 'dart:io';

import 'package:chatapp/app/UI/auth/home_screen.dart';
import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/values/app_constants.dart';
import 'package:chatapp/app/core/widget/ch_button.dart';
import 'package:chatapp/app/data/repository/login_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final LoginRepo loginRepo = LoginRepo();

  final profileUrl =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRaAsJaTD22xdCgfrjTCJzLQmODiZ-tYaXisA&s";

  File? selectedImage;
  bool isLoading = false;
  String? errorMessage;

  bool get isButtonDisabled => nameController.text.trim().isEmpty;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_refreshUI);
    statusController.addListener(_refreshUI);
  }

  void _refreshUI() => setState(() {});

  @override
  void dispose() {
    nameController.dispose();
    statusController.dispose();
    bioController.dispose();
    super.dispose();
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  String? validateInputs() {
    if (nameController.text.trim().isEmpty) {
      return "Name is required";
    }
    if (selectedImage == null) {
      return "Profile image is required";
    }
    return null;
  }

  Future<void> createUserProfile() async {
    final validationError = validateInputs();
    if (validationError != null) {
      setState(() => errorMessage = validationError);
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final res = await loginRepo.addUser(
        nameController.text.trim(),
        statusController.text.trim(),
        bioController.text.trim(),
        selectedImage?.path ?? profileUrl,
      );
      await CommonService.setProfileUrl(
        res['data']['profileUrl'] ?? profileUrl,
      );
      await CommonService.setUserId(res['data']['userId'].toString());

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } catch (e) {
      setState(() {
        errorMessage = "Failed to create profile";
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Widget _fieldContainer({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.symmetric(
      horizontal: AppConstants.paddingMD,
    ),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        border: Border.all(color: AppColors.primary),
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Create Profile",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingLG),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppConstants.heightXXL),

            Center(
              child: GestureDetector(
                onTap: pickImage,
                child: Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: selectedImage != null
                      ? ClipOval(
                          child: Image.file(selectedImage!, fit: BoxFit.cover),
                        )
                      : const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.camera_alt,
                              color: AppColors.primary,
                              size: AppConstants.iconMD,
                            ),
                            SizedBox(height: AppConstants.heightXS),
                            Text(
                              "Add Photo",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),

            const SizedBox(height: AppConstants.heightXXL),

            const Text("Name", style: TextStyle(color: AppColors.white)),
            const SizedBox(height: AppConstants.heightXS),
            _fieldContainer(
              child: TextField(
                controller: nameController,
                style: const TextStyle(color: AppColors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter your name",
                  hintStyle: TextStyle(color: AppColors.lightText),
                ),
              ),
            ),

            const SizedBox(height: AppConstants.heightLG),

            const Text("Status", style: TextStyle(color: AppColors.white)),
            const SizedBox(height: AppConstants.heightXS),
            _fieldContainer(
              child: TextField(
                controller: statusController,
                style: const TextStyle(color: AppColors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "What's on your mind?",
                  hintStyle: TextStyle(color: AppColors.lightText),
                ),
              ),
            ),

            const SizedBox(height: AppConstants.heightLG),

            const Text("Bio", style: TextStyle(color: AppColors.white)),
            const SizedBox(height: AppConstants.heightXS),
            _fieldContainer(
              padding: const EdgeInsets.all(AppConstants.paddingMD),
              child: TextField(
                controller: bioController,
                maxLines: 3,
                style: const TextStyle(color: AppColors.white),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Tell us about yourself...",
                  hintStyle: TextStyle(color: AppColors.lightText),
                ),
              ),
            ),

            const SizedBox(height: AppConstants.heightMD),

            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: AppColors.error),
              ),

            const SizedBox(height: AppConstants.heightMD),

            ChButton(
              title: "Continue",
              isLoading: isLoading,
              onPressed: createUserProfile,
              isDisabled: isButtonDisabled,
              textColor: AppColors.black,
            ),

            const SizedBox(height: AppConstants.heightLG),
          ],
        ),
      ),
    );
  }
}
