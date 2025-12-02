import 'dart:convert';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/registrasi.dart';

class RegistrasiBloc {
  static Future<Registrasi> registrasi({
    required String nama,
    required String email,
    required String password,
  }) async {
    String apiUrl = ApiUrl.registrasi;

    var body = {"nama": nama, "email": email, "password": password};

    final response = await Api().post(apiUrl, body);

    final jsonObj = json.decode(response.body);

    return Registrasi.fromJson(jsonObj);
  }
}
