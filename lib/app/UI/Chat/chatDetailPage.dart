import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/data/model/message_model.dart';
import 'package:chatapp/app/data/repository/chat_reop.dart';
import 'package:flutter/material.dart';

class ChatDetailPage extends StatefulWidget {
  final int userId;
  final String userName;
  final String? profileUrl;

  const ChatDetailPage({
    super.key,
    required this.userId,
    required this.userName,
    this.profileUrl,
  });

  @override
  State<ChatDetailPage> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetailPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final ChatReop _repo = ChatReop();

  List<MessageModel> messages = [];
  bool isLoading = true;
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      final res = await _repo.getMessageList(widget.userId);
      setState(() {
        messages = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.colorWhite),
        title: Text(
          widget.userName,
          style: const TextStyle(color: AppColors.colorWhite),
        ),
        actions: const [
          Icon(Icons.videocam),
          SizedBox(width: 12),
          Icon(Icons.call),
          SizedBox(width: 12),
          Icon(Icons.more_vert),
          SizedBox(width: 8),
        ],
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final bool isMe = msg.sentByMe;

                      return Align(
                        alignment: isMe
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isMe ? AppColors.primary : AppColors.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            msg.content,
                            style: TextStyle(
                              color: isMe
                                  ? AppColors.colorBlack
                                  : AppColors.colorWhite,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _buildMessageInput(),
              ],
            ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.colorBlack12,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: AppColors.colorWhite),
                decoration: const InputDecoration(
                  hintText: "Type a message",
                  hintStyle: TextStyle(color: AppColors.lightText),
                  border: InputBorder.none,
                ),
                onChanged: (v) {
                  setState(() => isTyping = v.trim().isNotEmpty);
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon: Icon(
                isTyping ? Icons.send : Icons.mic,
                color: AppColors.colorBlack,
              ),
              onPressed: isTyping ? sendMessage : null,
            ),
          ),
        ],
      ),
    );
  }
}
