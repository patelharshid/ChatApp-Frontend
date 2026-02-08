class ChatUserDetailModel {
  final String chatType;
  final int? userId;
  final int? groupId;
  final String? phoneNumber;
  final String name;
  final String? profileUrl;
  final String? lastMessage;
  final String? lastMessageTime;
  final String? messageType;

  ChatUserDetailModel({
    required this.chatType,
    this.userId,
    this.groupId,
    this.phoneNumber,
    required this.name,
    this.profileUrl,
    this.lastMessage,
    this.lastMessageTime,
    this.messageType,
  });

  factory ChatUserDetailModel.fromJson(Map<String, dynamic> json) {
    return ChatUserDetailModel(
      chatType: json['chatType'] ?? '',
      userId: json['userId'],
      groupId: json['groupId'],
      phoneNumber: json['phoneNumber'],
      name: json['name'] ?? '',
      profileUrl: json['profileUrl'],
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'],
      messageType: json['messageType'],
    );
  }
}
