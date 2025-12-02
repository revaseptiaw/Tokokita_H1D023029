import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  // Simpan token
  Future<void> setToken(String value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("token", value);
  }

  // Ambil token
  Future<String?> getToken() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString("token");
  }

  // Simpan User ID
  Future<void> setUserID(int value) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setInt("userID", value);
  }

  // Ambil User ID
  Future<int?> getUserID() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getInt("userID");
  }

  // Logout → hapus semua data user
  Future<void> logout() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
  }
}
