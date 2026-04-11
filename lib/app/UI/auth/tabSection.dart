import 'package:chatapp/app/UI/chat/chatPage.dart';
import 'package:chatapp/app/UI/status/statusListPage.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:flutter/material.dart';

class TabSection extends StatefulWidget {
  const TabSection({super.key});

  @override
  TabSectionState createState() => TabSectionState();
}

class TabSectionState extends State<TabSection>
    with SingleTickerProviderStateMixin {
  late TabController controller;

  final GlobalKey<ChatPageState> chatPageKey = GlobalKey<ChatPageState>();

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
  }

  void refreshChats() {
    chatPageKey.currentState?.fetchChatUsers();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.surface,
          child: TabBar(
            controller: controller,
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.lightText,
            labelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),

            tabs: const [
              Tab(text: "Chats"),
              Tab(text: "Status"),
              Tab(text: "Calls"),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: AppColors.background,
            child: TabBarView(
              controller: controller,
              children: [
                ChatPage(key: chatPageKey),
                StatusListPage(),
                const Center(
                  child: Text(
                    "Calls page",
                    style: TextStyle(color: AppColors.lightText),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
