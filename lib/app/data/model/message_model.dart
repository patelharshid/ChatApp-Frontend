class MessageModel {
  final String messageId;
  final String content;
  final String contentType;
  final int senderId;
  final int receiverId;
  final bool sentByMe;
  final String createdAt;

  MessageModel({
    required this.messageId,
    required this.content,
    required this.contentType,
    required this.senderId,
    required this.receiverId,
    required this.sentByMe,
    required this.createdAt,
  });
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['messageId']?.toString() ?? '',
      content: json['content'] ?? '',
      contentType: json['contentType'] ?? 'text',
      senderId: json['senderId'] ?? 0,
      receiverId: json['receiverId'] ?? 0,
      sentByMe: json['sentByMe'] ?? false,
      createdAt: json['createdAt'] ?? '',
    );
  }
}
