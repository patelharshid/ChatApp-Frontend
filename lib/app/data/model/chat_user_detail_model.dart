class ChatUserDetailModel {
  final int userId;
  final String phoneNumber;
  final String name;
  final String profileUrl;
  final String lastMessage;
  final String lastMessageTime;
  final String messageType;

  ChatUserDetailModel({
    required this.userId,
    required this.phoneNumber,
    required this.name,
    required this.profileUrl,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.messageType,
  });

  factory ChatUserDetailModel.fromJson(Map<String, dynamic> json) {
    return ChatUserDetailModel(
      userId: json['userId'],
      phoneNumber: json['phoneNumber'],
      name: json['name'],
      profileUrl: json['profileUrl'],
      lastMessage: json['lastMessage'],
      lastMessageTime: json['lastMessageTime'],
      messageType: json['messageType'],
    );
  }
}
