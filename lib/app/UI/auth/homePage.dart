import 'package:chatapp/app/UI/auth/login_screen.dart';
import 'package:chatapp/app/UI/auth/profile_setup_screen.dart';
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
  final GlobalKey<TabSectionState> tabKey = GlobalKey<TabSectionState>();

  void logout() {
    CommonService.clearSharedPreferences();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
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
              color: AppColors.white,
            ),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            color: AppColors.surface,
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
                    MaterialPageRoute(builder: (_) => const ProfileSetupScreen()),
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
                  style: TextStyle(color: AppColors.white),
                ),
              ),
              PopupMenuItem(
                value: 'profile',
                child: Text(
                  "Profile",
                  style: TextStyle(color: AppColors.white),
                ),
              ),
              PopupMenuItem(
                value: 'logout',
                child: Text(
                  "Logout",
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
        ],
      ),

      body: TabSection(key: tabKey),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ContactPage()),
          );

          if (result == true) {
            tabKey.currentState?.refreshChats();
          }
        },
        child: const Icon(Icons.chat, color: AppColors.black),
      ),
    );
  }
}
