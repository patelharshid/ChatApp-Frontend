import 'package:chatapp/app/core/services/SocketService.dart';
import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/data/model/group_message_model.dart';
import 'package:chatapp/app/data/repository/group_repo.dart';
import 'package:flutter/material.dart';

class GroupDetailPage extends StatefulWidget {
  final int groupId;
  final String userName;
  final String? profileUrl;

  const GroupDetailPage({
    super.key,
    required this.groupId,
    required this.userName,
    this.profileUrl,
  });

  @override
  State<GroupDetailPage> createState() => _GroupDetailPageState();
}

class _GroupDetailPageState extends State<GroupDetailPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  final GroupRepo _groupRepo = GroupRepo();
  final SocketService _socketService = SocketService();

  bool isLoading = true;
  bool isTyping = false;
  int? loggedInUserId;

  List<GroupMessageModel> messages = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final id = await CommonService.getUserId();
    loggedInUserId = int.tryParse(id ?? '');

    await _fetchMessages();

    if (loggedInUserId != null) {
      _socketService.connectGroup(loggedInUserId!, widget.groupId);
      _listenMessages();
    }
  }

  void _listenMessages() {
    _socketService.onGroupMessage((data) {
      final msg = GroupMessageModel.fromJson(data);
      if (msg.senderId == loggedInUserId) {
        return;
      }

      setState(() {
        messages.add(msg);
      });

      _scrollToBottom();
    });
  }

  Future<void> _fetchMessages() async {
    try {
      final data = await _groupRepo.groupMessage(widget.groupId);

      setState(() {
        messages = data;
        isLoading = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty || loggedInUserId == null) return;

    final messageData = {
      "groupId": widget.groupId,
      "senderId": loggedInUserId,
      "senderName": "You",
      "content": text,
      "contentType": "TEXT",
      "createdAt": DateTime.now().toIso8601String(),
    };

    _socketService.sendGroupMessage(messageData);

    final localMsg = GroupMessageModel.fromJson(messageData);

    setState(() {
      messages.add(localMsg);
    });

    _messageController.clear();
    setState(() => isTyping = false);

    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _socketService.disconnect();
            Navigator.pop(context);
          },
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.colorGrey,
              backgroundImage:
                  widget.profileUrl != null && widget.profileUrl!.isNotEmpty
                  ? NetworkImage(widget.profileUrl!)
                  : null,
              child: widget.profileUrl == null || widget.profileUrl!.isEmpty
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
      ),

      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : messages.isEmpty
                ? const Center(
                    child: Text(
                      "No chat yet",
                      style: TextStyle(
                        color: AppColors.lightText,
                        fontSize: 16,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(12),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final msg = messages[index];
                      final bool isMe = msg.senderId == loggedInUserId;

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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMe)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    msg.senderName,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green,
                                    ),
                                  ),
                                ),
                              Text(
                                msg.content,
                                style: TextStyle(
                                  color: isMe
                                      ? AppColors.colorBlack
                                      : AppColors.colorWhite,
                                ),
                              ),
                            ],
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
      color: const Color.fromARGB(255, 45, 45, 45),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.black45,
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
              onPressed: isTyping ? _sendMessage : null,
            ),
          ),
        ],
      ),
    );
  }
}
