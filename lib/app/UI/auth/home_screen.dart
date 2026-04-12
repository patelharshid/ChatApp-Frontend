import 'package:chatapp/app/UI/auth/login_screen.dart';
import 'package:chatapp/app/UI/auth/profile_setup_screen.dart';
import 'package:chatapp/app/UI/chat/contact_list_screen.dart';
import 'package:chatapp/app/UI/auth/tabSection.dart';
import 'package:chatapp/app/UI/group/groupPage.dart';
import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/values/app_constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<TabSectionState> tabKey = GlobalKey<TabSectionState>();
  int currentTabIndex = 0;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      tabKey.currentState?.controller.addListener(() {
        setState(() {
          currentTabIndex = tabKey.currentState!.controller.index;
        });
      });
    });
  }

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
        titleSpacing: AppConstants.paddingMD,

        title: const Text(
          "ChatConnect",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.3,
          ),
        ),

        actions: [
          IconButton(
            splashRadius: AppConstants.radiusMD,
            icon: const Icon(Icons.camera_alt_outlined, color: AppColors.white),
            onPressed: () {},
          ),

          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.white),
            color: AppColors.surface,
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMD),
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
                    MaterialPageRoute(
                      builder: (_) => const ProfileSetupScreen(),
                    ),
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
                child: Text("Logout", style: TextStyle(color: AppColors.error)),
              ),
            ],
          ),

          const SizedBox(width: AppConstants.paddingSM),
        ],
      ),

      body: TabSection(key: tabKey),

      floatingActionButton: currentTabIndex == 0
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              elevation: 4,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactListScreen()),
                );
              },
              child: const Icon(Icons.chat, color: AppColors.black),
            )
          : null,
    );
  }
}
