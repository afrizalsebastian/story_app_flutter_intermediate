import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app_flutter_intermediate/model/list_story.dart';
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

  Future<List<ListStory>> getListStory(int page, int size) async {
    Uri url = Uri.parse("$_baseUrl/stories?page=$page&size=$size");

    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("authToken") ?? "";
    String bearerToken = "Bearer $token";

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': bearerToken,
      },
    );

    if (response.statusCode == 200) {
      return listStoryResponseFromJson(response.body).listStory;
    } else {
      throw Exception('Failed to fetch data');
    }
  }
}
