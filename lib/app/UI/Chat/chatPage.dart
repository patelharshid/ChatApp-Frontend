import 'package:chatapp/app/UI/chat/chatDetailPage.dart';
import 'package:chatapp/app/core/helper/date_util.dart';
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
    fetchChatUsers();
  }

  Future<void> fetchChatUsers() async {
    try {
      final res = await _repo.getChatUsers();
      setState(() {
        chatUsers = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (chatUsers.isEmpty) {
      return const Center(child: Text("No chats yet"));
    }

    return ListView.builder(
      itemCount: chatUsers.length,
      itemBuilder: (context, index) {
        final user = chatUsers[index];

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChatDetailPage(
                    userName: user.name,
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundImage: user.profileUrl != null
                  ? NetworkImage(user.profileUrl!)
                  : null,
              child: user.profileUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(user.name),
            subtitle: Text(user.lastMessage ?? ""),
            trailing: Text(DateUtil.formatTime(user.lastMessageTime!)),
          ),
        );
      },
    );
  }
}
