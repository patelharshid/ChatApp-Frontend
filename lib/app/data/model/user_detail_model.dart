class UserDetailModel {
  final int userId;
  final String phoneNumber;
  final String email;
  final String? otp;
  final String? username;
  final String? about;
  final String? bio;
  final String? profileUrl;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final DateTime? lastSeenTime;

  UserDetailModel({
    required this.userId,
    required this.phoneNumber,
    required this.email,
    this.otp,
    this.username,
    this.about,
    this.bio,
    this.profileUrl,
    this.createdDate,
    this.updatedDate,
    this.lastSeenTime,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) {
    return UserDetailModel(
      userId: json['userId'],
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      otp: json['otp'],
      username: json['username'],
      about: json['about'],
      bio: json['bio'],
      profileUrl: json['profileUrl'],
      createdDate: json['createdDate'] != null
          ? DateTime.parse(json['createdDate'])
          : null,
      updatedDate: json['updatedDate'] != null
          ? DateTime.parse(json['updatedDate'])
          : null,
      lastSeenTime: json['lastSeenTime'] != null
          ? DateTime.parse(json['lastSeenTime'])
          : null,
    );
  }
}
