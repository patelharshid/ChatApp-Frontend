import 'package:chatapp/app/UI/chat/chat_detail_screen.dart';
import 'package:chatapp/app/UI/group/groupDetailPage.dart';
import 'package:chatapp/app/core/helper/date_util.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/values/app_constants.dart';
import 'package:chatapp/app/core/widget/profile_avatar.dart';
import 'package:chatapp/app/data/model/chat_user_detail_model.dart';
import 'package:chatapp/app/data/repository/chat_reop.dart';
import 'package:flutter/material.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ChatReop _chatRepository = ChatReop();

  List<ChatUserDetailModel> chatUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChatUsers();
  }

  Future<void> _loadChatUsers() async {
    try {
      final res = await _chatRepository.getChatUsers();

      if (!mounted) return;

      setState(() {
        chatUsers = res;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  Future<void> _openChat(ChatUserDetailModel user) async {
    final isGroup = user.chatType == "GROUP";

    if (isGroup) {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GroupDetailPage(
            groupId: user.groupId!,
            userName: user.name,
            profileUrl: user.profileUrl ?? '',
          ),
        ),
      );
    } else {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChatDetailScreen(
            userId: user.userId!,
            userName: user.name,
            profileUrl: user.profileUrl ?? '',
          ),
        ),
      );
    }

    _loadChatUsers();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (chatUsers.isEmpty) {
      return const Center(
        child: Text(
          "No chats yet",
          style: TextStyle(color: AppColors.lightText),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadChatUsers,
      color: AppColors.primary,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: chatUsers.length,
        itemBuilder: (context, index) {
          final user = chatUsers[index];
          final isGroup = user.chatType == "GROUP";

          return InkWell(
            onTap: () => _openChat(user),
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
                  ProfileAvatar(imageUrl: user.profileUrl),

                  const SizedBox(width: AppConstants.widthMD),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: AppConstants.heightXS),

                        Row(
                          children: [
                            if (!isGroup && user.messageType == "SENT") ...[
                              const Icon(
                                Icons.done_all,
                                size: AppConstants.iconSM,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: AppConstants.widthXS),
                            ],

                            Expanded(
                              child: Text(
                                user.lastMessage ?? '',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.lightText,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: AppConstants.widthXS),

                  Text(
                    user.lastMessageTime != null
                        ? DateUtil.formatTime(user.lastMessageTime!)
                        : '',
                    style: const TextStyle(
                      color: AppColors.lightText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
