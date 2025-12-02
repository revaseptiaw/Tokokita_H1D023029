import 'dart:convert';
import 'package:http/http.dart' as http;
import '../helpers/api_url.dart';

class RegistrasiService {
  static Future<Map<String, dynamic>> registrasi({
    required String nama,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(ApiUrl.registrasi),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"nama": nama, "email": email, "password": password}),
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return {"success": true, "data": jsonDecode(response.body)};
      } else {
        return {
          "success": false,
          "message": jsonDecode(response.body)["message"] ?? "Registrasi gagal",
        };
      }
    } catch (e) {
      print("Error registrasi: $e");
      return {"success": false, "message": "Tidak bisa connect ke server"};
    }
  }
}
