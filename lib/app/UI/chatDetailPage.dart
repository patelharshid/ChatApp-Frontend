import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  final String userName;

  const ChatDetailPage({super.key, required this.userName});

  @override
  State<ChatDetailPage> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const CircleAvatar(radius: 20, child: Icon(Icons.person, size: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.userName, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(icon: const Icon(Icons.videocam), onPressed: () {}),
          IconButton(icon: const Icon(Icons.call), onPressed: () {}),
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(color: Colors.grey[200]),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    return const SizedBox();
                  },
                ),
              ),
              _buildMessageInput(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Icon(Icons.emoji_emotions_outlined, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      onChanged: (value) {
                        setState(() {
                          isTyping = value.trim().isNotEmpty;
                        });
                      },
                    ),
                  ),
                  Icon(Icons.attach_file, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Icon(Icons.camera_alt, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              icon: Icon(
                isTyping ? Icons.send : Icons.mic,
                color: Colors.white,
              ),
              onPressed: () {},
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
