import 'package:chatapp/app/UI/auth/loginPage.dart';
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
  final GlobalKey<TabSectionState> tabKey = GlobalKey<TabSectionState>();

  void logout() {
    CommonService.clearSharedPreferences();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
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
        title: const Text(
          "ChatConnect",
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
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

      body: TabSection(key: tabKey),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ContactPage()),
          );

          if (result == true) {
            // 🔥 Refresh ChatPage
            tabKey.currentState?.refreshChats();
          }
        },
        child: const Icon(Icons.chat, color: AppColors.colorBlack),
      ),
    );
  }
}
