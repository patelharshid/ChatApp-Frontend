import 'package:chatapp/Splash_Screen.dart';
import 'package:chatapp/app/UI/auth/profileSetupPage.dart';
import 'package:chatapp/app/UI/chat/contactPage.dart';
import 'package:chatapp/app/UI/auth/tabSection.dart';
import 'package:chatapp/app/UI/group/groupPage.dart';
import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<Homepage> {
  void logout() {
    CommonService.clearSharedPreferences();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const SplashScreen()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.surface,
        elevation: 0,
        titleSpacing: 16,
        title: const Text(
          "ChatConnect",
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),
        actions: [
          IconButton(
            splashRadius: 22,
            icon: const Icon(
              Icons.camera_alt_outlined,
              color: AppColors.colorWhite,
            ),
            onPressed: () {},
          ),

          PopupMenuButton<String>(
            color: AppColors.surface,
            splashRadius: 20,
            icon: const Icon(Icons.more_vert, color: AppColors.colorWhite),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            onSelected: (value) {
              switch (value) {
                case 'group':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GroupPage()),
                  );
                  break;

                case 'profile':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ProfileSetupPage()),
                  );
                  break;

                case 'logout':
                  logout();
                  break;
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'group',
                child: Text(
                  "New Group",
                  style: TextStyle(color: AppColors.colorWhite),
                ),
              ),
              PopupMenuItem(
                value: 'profile',
                child: Text(
                  "Profile",
                  style: TextStyle(color: AppColors.colorWhite),
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Text(
                  "Logout",
                  style: TextStyle(color: AppColors.errorColor),
                ),
              ),
            ],
          ),
        ],
      ),

      body: const TabSection(),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        elevation: 4,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ContactPage()),
          );
        },
        child: const Icon(Icons.chat, color: AppColors.colorBlack),
      ),
    );
  }
}
