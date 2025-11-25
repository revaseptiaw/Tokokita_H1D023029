// lib/helpers/user_info.dart

import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  static Future<String> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String token = pref.getString("token") ?? '';
    return token;
  }

  static Future<void> setToken(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("token", value);
  }

  static Future<void> setUserId(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("userID", value);
  }

  static Future<void> logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove("token");
    await pref.remove("userID");
  }
}
