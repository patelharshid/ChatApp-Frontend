import 'dart:io';

import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/app/core/services/SocketService.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/values/app_constants.dart';
import 'package:chatapp/app/data/model/message_model.dart';
import 'package:chatapp/app/data/repository/chat_reop.dart';
import 'package:flutter/material.dart';

class ChatDetailScreen extends StatefulWidget {
  final int userId;
  final String userName;
  final String? profileUrl;

  const ChatDetailScreen({
    super.key,
    required this.userId,
    required this.userName,
    this.profileUrl,
  });

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final ChatReop _repo = ChatReop();
  final SocketService _socketService = SocketService();

  List<MessageModel> messages = [];
  bool isLoading = true;
  bool isTyping = false;
  int? loggedInUserId;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final id = await CommonService.getUserId();
    loggedInUserId = int.tryParse(id ?? '');
    await fetchMessages();
    _connectSocket();
  }

  void _connectSocket() {
    if (loggedInUserId == null) return;

    _socketService.connectUser(loggedInUserId!);

    _socketService.onMessage((data) {
      if (data['senderId'] == loggedInUserId) return;

      final msg = MessageModel.fromJson({
        "messageId":
            data["messageId"] ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        "content": data["content"] ?? "",
        "contentType": data["contentType"] ?? "text",
        "senderId": data["senderId"],
        "receiverId": data["receiverId"],
        "createdAt": data["createdAt"],
        "sentByMe": false,
      });

      if (!mounted) return;

      setState(() => messages.add(msg));
    });
  }

  Future<void> fetchMessages() async {
    try {
      final res = await _repo.getMessageList(widget.userId);

      if (!mounted) return;

      setState(() {
        messages = res;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  void sendMessage() {
    if (loggedInUserId == null) return;

    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final socketData = {
      "senderId": loggedInUserId,
      "receiverId": widget.userId,
      "content": text,
    };

    _socketService.sendMessage(socketData);

    final localMessage = MessageModel.fromJson({
      "messageId": DateTime.now().millisecondsSinceEpoch.toString(),
      "content": text,
      "contentType": "text",
      "senderId": loggedInUserId,
      "receiverId": widget.userId,
      "createdAt": DateTime.now().toIso8601String(),
      "sentByMe": true,
    });

    setState(() {
      messages.add(localMessage);
      isTyping = false;
    });

    _messageController.clear();
  }

  @override
  void dispose() {
    _socketService.disconnect();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildAvatar() {
    if (widget.profileUrl == null || widget.profileUrl!.isEmpty) {
      return const CircleAvatar(
        radius: 18,
        backgroundColor: AppColors.grey,
        child: Icon(Icons.person, color: AppColors.white),
      );
    }

    final image = widget.profileUrl!.startsWith("http")
        ? NetworkImage(widget.profileUrl!)
        : FileImage(File(widget.profileUrl!)) as ImageProvider;

    return CircleAvatar(
      radius: 18,
      backgroundColor: AppColors.grey,
      backgroundImage: image,
    );
  }

  Widget _buildMessageItem(MessageModel msg) {
    final isMe = msg.sentByMe;

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: AppConstants.paddingXS),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.paddingMD,
          vertical: AppConstants.paddingSM,
        ),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusMD),
        ),
        child: Text(
          msg.content,
          style: TextStyle(color: isMe ? AppColors.black : AppColors.white),
        ),
      ),
    );
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
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: AppConstants.widthXS),
            _buildAvatar(),
            const SizedBox(width: AppConstants.widthSM),
            Expanded(
              child: Text(
                widget.userName,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: const [
          Icon(Icons.videocam, color: AppColors.white),
          SizedBox(width: AppConstants.widthSM),
          Icon(Icons.call, color: AppColors.white),
          SizedBox(width: AppConstants.widthSM),
          Icon(Icons.more_vert, color: AppColors.white),
          SizedBox(width: AppConstants.widthXS),
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
                    padding: const EdgeInsets.all(AppConstants.paddingMD),
                    itemCount: messages.length,
                    itemBuilder: (_, index) =>
                        _buildMessageItem(messages[index]),
                  ),
                ),

                _buildMessageInput(),
              ],
            ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingSM,
        vertical: AppConstants.paddingXS,
      ),
      color: AppColors.surface,
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMD,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppConstants.radiusLG),
              ),
              child: TextField(
                controller: _messageController,
                style: const TextStyle(color: AppColors.white),
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

          const SizedBox(width: AppConstants.widthXS),

          CircleAvatar(
            backgroundColor: AppColors.primary,
            child: IconButton(
              icon: Icon(
                isTyping ? Icons.send : Icons.mic,
                color: AppColors.black,
              ),
              onPressed: isTyping ? sendMessage : null,
            ),
          ),
        ],
      ),
    );
  }
}
