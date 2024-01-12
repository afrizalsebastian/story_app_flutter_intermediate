import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_app_flutter_intermediate/model/login.dart';

class ApiServices {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<void> register(String name, String email, String password) async {
    Uri url = Uri.parse("$_baseUrl/register");

    var data = {
      "name": name,
      "email": email,
      "password": password,
    };

    final body = json.encode(data);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    if (response.statusCode != 201) {
      throw Exception('Registration Failed');
    }
  }

  Future<LoginData> login(String email, String password) async {
    Uri url = Uri.parse("$_baseUrl/login");

    var data = {
      "email": email,
      "password": password,
    };

    final body = json.encode(data);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return loginDataFromJson(response.body);
    } else {
      throw Exception('Login Failed');
    }
  }
}
