import 'package:chatapp/app/UI/chat/chat_list_screen.dart';
import 'package:chatapp/app/UI/status/status_list_screen.dart';
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

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      setState(() {});
    });
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
            tabs: const [
              Tab(text: "Chats"),
              Tab(text: "Status"),
              Tab(text: "Calls"),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: controller,
            children: [
              ChatListScreen(),
              StatusListScreen(),
              const Center(
                child: Text(
                  "Calls page",
                  style: TextStyle(color: AppColors.lightText),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
