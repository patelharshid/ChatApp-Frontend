class AppUrls {
  static late String baseUrl;

  // AUTH
  static String login() => "$baseUrl/auth/signUp";
  static String otpverification() => "$baseUrl/auth/verify-otp";

  static String addUser() => "$baseUrl/auth";
  static String getUserById() => "$baseUrl/auth/getUserById";

  static String getAllUser() => "$baseUrl/auth";

  static String getChatUsers() => "$baseUrl/chat";
  static String getMessageList() => "$baseUrl/chat/getMessageList";

  static String createGroup() => "$baseUrl/group";
}
