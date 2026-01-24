import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/data/model/message_model.dart';
import 'package:chatapp/app/data/repository/chat_reop.dart';
import 'package:chatapp/app/core/services/SocketService.dart';
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
  final SocketService _socketService = SocketService();

  List<MessageModel> messages = [];
  bool isLoading = true;
  bool isTyping = false;
  int? loggedInUserId;

  bool isSelectionMode = false;
  Set<String> selectedMessageIds = {};

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final id = await CommonService.getUserId();
    loggedInUserId = int.tryParse(id ?? '');

    await fetchMessages();
    connectSocket();
  }

  void connectSocket() {
    if (loggedInUserId == null) return;

    _socketService.connect(loggedInUserId!);

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
        "createdAt": data["createdAt"] ?? DateTime.now().toIso8601String(),
        "sentByMe": false,
      });

      setState(() {
        messages.add(msg);
      });

      _scrollToBottom();
    });
  }

  Future<void> fetchMessages() async {
    try {
      final res = await _repo.getMessageList(widget.userId);
      setState(() {
        messages = res;
        isLoading = false;
      });
      _scrollToBottom();
    } catch (_) {
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
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        iconTheme: const IconThemeData(color: AppColors.colorWhite),
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.colorGrey,
              backgroundImage: widget.profileUrl != null
                  ? NetworkImage(widget.profileUrl!)
                  : null,
              child: widget.profileUrl == null
                  ? const Icon(Icons.person, color: AppColors.colorWhite)
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                widget.userName,
                style: const TextStyle(
                  color: AppColors.colorWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
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
