import 'package:chatapp/app/UI/chatDetailPage.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) {
        final userName = 'User $index';
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatDetailPage(userName: userName),
                ),
              );
            },
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(userName),
            subtitle: const Text('Last message...'),
            trailing: const Text('10:30 AM'),
          ),
        );
      },
    );
  }
}
