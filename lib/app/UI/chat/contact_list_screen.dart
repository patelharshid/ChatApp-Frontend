import 'dart:io';

import 'package:chatapp/app/UI/chat/chat_detail_screen.dart';
import 'package:chatapp/app/UI/group/groupPage.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/values/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/app/data/model/user_detail_model.dart';
import 'package:chatapp/app/data/repository/login_repo.dart';

class ContactListScreen extends StatefulWidget {
  const ContactListScreen({super.key});

  @override
  State<ContactListScreen> createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  final LoginRepo _repo = LoginRepo();

  bool isLoading = true;
  List<UserDetailModel> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final res = await _repo.getAllUser();

      if (!mounted) return;

      setState(() {
        users = res;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.white),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text(
          "Select contact",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : RefreshIndicator(
              onRefresh: _loadUsers,
              color: AppColors.primary,
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: users.length + 2,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildTile(
                      title: "New group",
                      isGroup: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GroupPage(),
                          ),
                        );
                      },
                    );
                  }

                  if (index == 1) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingMD,
                        vertical: AppConstants.paddingSM,
                      ),
                      child: Text(
                        "Contacts on WhatsApp",
                        style: TextStyle(
                          color: AppColors.lightText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }

                  final user = users[index - 2];

                  return _buildTile(
                    title: user.username ?? "",
                    subtitle: user.about ?? "",
                    imageUrl: user.profileUrl,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatDetailScreen(
                            userId: user.userId,
                            userName: user.username ?? '',
                            profileUrl: user.profileUrl,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }

  Widget _buildTile({
    required String title,
    String? subtitle,
    String? imageUrl,
    bool isGroup = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMD,
          vertical: AppConstants.paddingSM,
        ),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.grey, width: 0.3),
          ),
        ),
        child: Row(
          children: [
            /// 🔹 Avatar
            CircleAvatar(
              radius: 24,
              backgroundColor: isGroup ? AppColors.primary : AppColors.grey,
              backgroundImage: (!isGroup &&
                      imageUrl != null &&
                      imageUrl.isNotEmpty)
                  ? (imageUrl.startsWith("http")
                          ? NetworkImage(imageUrl)
                          : FileImage(File(imageUrl))) as ImageProvider
                  : null,
              child: isGroup
                  ? const Icon(Icons.group_add, color: AppColors.black)
                  : (imageUrl == null || imageUrl.isEmpty)
                      ? const Icon(Icons.person, color: AppColors.lightText)
                      : null,
            ),

            const SizedBox(width: AppConstants.widthMD),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  if (subtitle != null && subtitle.isNotEmpty) ...[
                    const SizedBox(height: AppConstants.heightXS),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.lightText,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}