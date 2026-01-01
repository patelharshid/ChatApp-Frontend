import 'package:shared_preferences/shared_preferences.dart';

class CommonService {
  static Future<void> setToken(String sessionToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('sessionToken', sessionToken);
  }

  static Future<String?> getSessionToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionToken');
  }

  static Future<void> setUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('UserId', userId);
  }

  static Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('UserId');
  }

  static Future<void> clearSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    prefs.remove('sessionToken');
    prefs.remove('UserId');
  }
}
