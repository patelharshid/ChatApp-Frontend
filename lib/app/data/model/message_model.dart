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
      messageId: json['messageId'],
      content: json['content'],
      contentType: json['contentType'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      sentByMe: json['sentByMe'],
      createdAt: json['createdAt'],
    );
  }
}
