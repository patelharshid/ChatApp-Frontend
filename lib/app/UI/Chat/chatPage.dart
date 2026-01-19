import 'package:chatapp/app/UI/chat/chatDetailPage.dart';
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
    fetchChatUsers(); // ✅ only first time
  }

  Future<void> fetchChatUsers() async {
    try {
      final res = await _repo.getChatUsers();
      if (!mounted) return;
      setState(() {
        chatUsers = res;
        isLoading = false;
      });
    } catch (_) {
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

    return ListView.builder(
      itemCount: chatUsers.length,
      itemBuilder: (context, index) {
        final user = chatUsers[index];

        return InkWell(
          onTap: () async {
            // ✅ WAIT until ChatDetailPage is popped
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChatDetailPage(
                  userId: user.userId,
                  userName: user.name,
                  profileUrl: user.profileUrl,
                ),
              ),
            );

            // ✅ CALL API ONLY AFTER BACK
            fetchChatUsers();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.colorGrey, width: 0.3),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: NetworkImage(user.profileUrl),
                  backgroundColor: AppColors.colorGrey,
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: AppColors.colorWhite,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Row(
                        children: [
                          if (user.messageType == "SENT")
                            const Icon(
                              Icons.done_all,
                              size: 18,
                              color: AppColors.primary,
                            ),

                          if (user.messageType == "SENT")
                            const SizedBox(width: 4),

                          Expanded(
                            child: Text(
                              user.lastMessage,
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
                  DateUtil.formatTime(user.lastMessageTime),
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
    );
  }
}
