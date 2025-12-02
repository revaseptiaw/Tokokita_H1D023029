import 'dart:convert';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/login.dart';

class LoginBloc {
  static Future<Login> login({
    required String email,
    required String password,
  }) async {
    String apiUrl = ApiUrl.login;

    var body = {"email": email, "password": password};

    final response = await Api().post(apiUrl, body);

    final jsonObj = json.decode(response.body);

    return Login.fromJson(jsonObj);
  }
}
