class StatusDetailModel {
  final int statusId;
  final int userId;
  final String userName;
  final String contentUrl;
  final String contentType;
  final String caption;
  final String createdDate;
  final String expiresDate;
  final bool isViewed;
  final bool isMe;

  StatusDetailModel({
    required this.statusId,
    required this.userId,
    required this.userName,
    required this.contentUrl,
    required this.contentType,
    required this.caption,
    required this.createdDate,
    required this.expiresDate,
    required this.isViewed,
    required this.isMe,
  });

  factory StatusDetailModel.fromJson(Map<String, dynamic> json) {
    return StatusDetailModel(
      statusId: json['statusId'],
      userId: json['userId'],
      userName: json['userName'],
      contentUrl: json['contentUrl'],
      contentType: json['contentType'],
      caption: json['caption'] ?? '',
      createdDate: json['createdDate'],
      expiresDate: json['expiresDate'],
      isViewed: json['viewed'] ?? false,
      isMe: json['sentByMe'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "statusId": statusId,
      "userId": userId,
      "userName": userName,
      "contentUrl": contentUrl,
      "contentType": contentType,
      "caption": caption,
      "createdDate": createdDate,
      "expiresDate": expiresDate,
      "viewed": isViewed,
      "sentByMe": isMe,
    };
  }
}
