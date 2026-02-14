class GroupMessageModel {
  final int groupMessagesId;
  final int senderId;
  final String senderName;
  final String content;
  final String contentType;
  final bool sentByMe;
  final String mediaUrl;
  final String createdAt;

  GroupMessageModel({
    required this.groupMessagesId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.contentType,
    required this.sentByMe,
    required this.mediaUrl,
    required this.createdAt,
  });

  factory GroupMessageModel.fromJson(Map<String, dynamic> json) {
    return GroupMessageModel(
      groupMessagesId: json['groupMessagesId'],
      senderId: json['senderId'],
      senderName: json['senderName'] ?? '',
      content: json['content'] ?? '',
      contentType: json['contentType'] ?? 'TEXT',
      sentByMe: json['sentByMe'] ?? false,
      mediaUrl: json['mediaUrl'] ?? '',
      createdAt: json['createdAt'],
    );
  }
}
