// lib/bloc/auth_bloc.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tokokita/model/login.dart';
import 'package:tokokita/model/registrasi.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/helpers/user_info.dart';

class AuthBloc {
  // Fungsi untuk Registrasi (POST /registrasi)
  static Future<Registrasi> registrasi(
    String nama,
    String email,
    String password,
  ) async {
    String apiUrl = ApiUrl.registrasi;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "nama": nama,
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return Registrasi.fromJson(body);
    } else {
      throw Exception('Gagal melakukan registrasi. Cek koneksi atau server.');
    }
  }

  // Fungsi untuk Login (POST /login)
  static Future<Login> login(String email, String password) async {
    String apiUrl = ApiUrl.login;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final loginData = Login.fromJson(body);

      // Jika login berhasil, simpan token dan user ID
      if (loginData.status == true && loginData.token != null) {
        await UserInfo.setToken(loginData.token!);
        await UserInfo.setUserId(loginData.userID.toString());
      }
      return loginData;
    } else {
      throw Exception('Gagal melakukan login. Cek koneksi atau server.');
    }
  }
}
