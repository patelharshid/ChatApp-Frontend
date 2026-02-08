import 'package:chatapp/app/UI/auth/homePage.dart';
import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/widget/ch_button.dart';
import 'package:chatapp/app/data/repository/login_repo.dart';
import 'package:flutter/material.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key});

  @override
  State<ProfileSetupPage> createState() => ProfileSetupPageState();
}

class ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  final profileUrl =
      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRaAsJaTD22xdCgfrjTCJzLQmODiZ-tYaXisA&s";

  final LoginRepo loginRepo = LoginRepo();
  bool isLoading = false;

  bool get isButtonDisabled =>
      nameController.text.trim().isEmpty &&
      statusController.text.trim().isEmpty;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_onTextChanged);
    statusController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {});
  }

  Future<void> addUser() async {
    setState(() => isLoading = true);
    try {
      final res = await loginRepo.addUser(
        nameController.text.trim(),
        statusController.text.trim(),
        bioController.text.trim(),
        profileUrl,
      );

      CommonService.setUserId(res['data']['userId'].toString());

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Homepage()),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget _fieldContainer({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 14),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
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
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Create Profile",
          style: const TextStyle(
            color: AppColors.colorWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),

            Center(
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.surface,
                  border: Border.all(color: AppColors.primary, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.camera_alt, color: AppColors.primary, size: 32),
                    SizedBox(height: 6),
                    Text(
                      "Add Photo",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            const Text(
              "Name",
              style: TextStyle(
                color: AppColors.colorWhite,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            _fieldContainer(
              child: TextField(
                controller: nameController,
                style: const TextStyle(color: AppColors.colorWhite),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Enter your name",
                  hintStyle: TextStyle(color: AppColors.lightText),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Status Message",
              style: TextStyle(
                color: AppColors.colorWhite,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            _fieldContainer(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: statusController,
                      style: const TextStyle(color: AppColors.colorWhite),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "What's on your mind?",
                        hintStyle: TextStyle(color: AppColors.lightText),
                      ),
                    ),
                  ),
                  const Icon(Icons.emoji_emotions, color: AppColors.primary),
                ],
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Bio",
              style: TextStyle(
                color: AppColors.colorWhite,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            _fieldContainer(
              padding: const EdgeInsets.all(14),
              child: TextField(
                controller: bioController,
                maxLines: 3,
                maxLength: 120,
                style: const TextStyle(color: AppColors.colorWhite),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: "Tell us about yourself...",
                  hintStyle: TextStyle(color: AppColors.lightText),
                ),
              ),
            ),

            const SizedBox(height: 40),

            ChButton(
              title: "Continue",
              isLoading: isLoading,
              onPressed: addUser,
              isDisabled: isButtonDisabled,
              backgroundColor: AppColors.primary,
              textColor: AppColors.colorBlack,
              radius: 14,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
