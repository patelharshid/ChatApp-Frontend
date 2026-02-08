import 'package:chatapp/app/UI/chat/chatDetailPage.dart';
import 'package:chatapp/app/UI/group/groupDetailPage.dart';
import 'package:chatapp/app/core/helper/date_util.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/data/model/chat_user_detail_model.dart';
import 'package:chatapp/app/data/repository/chat_reop.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatReop _repo = ChatReop();

  List<ChatUserDetailModel> chatUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChatUsers();
  }

  Future<void> _fetchChatUsers() async {
    try {
      final res = await _repo.getChatUsers();
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
      onRefresh: _fetchChatUsers,
      color: AppColors.primary,
      child: ListView.builder(
        itemCount: chatUsers.length,
        itemBuilder: (context, index) {
          final user = chatUsers[index];
          final bool isGroup = user.chatType == "GROUP";

          return InkWell(
            onTap: () async {
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
                    builder: (_) => ChatDetailPage(
                      userId: user.userId!,
                      userName: user.name,
                      profileUrl: user.profileUrl ?? '',
                    ),
                  ),
                );
              }
              _fetchChatUsers();
            },

            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.colorGrey, width: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.colorGrey,
                    backgroundImage: user.profileUrl?.isNotEmpty == true
                        ? NetworkImage(user.profileUrl!)
                        : null,
                    child: user.profileUrl == null
                        ? const Icon(Icons.person, color: Colors.white70)
                        : null,
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.colorWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Row(
                          children: [
                            if (!isGroup && user.messageType == "SENT")
                              const Icon(
                                Icons.done_all,
                                size: 18,
                                color: AppColors.primary,
                              ),

                            if (!isGroup && user.messageType == "SENT")
                              const SizedBox(width: 4),

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

                  const SizedBox(width: 8),

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
