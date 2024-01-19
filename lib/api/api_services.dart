import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app_flutter_intermediate/model/detail_story.dart';
import 'package:story_app_flutter_intermediate/model/list_story.dart';
import 'package:story_app_flutter_intermediate/model/login.dart';
import 'package:story_app_flutter_intermediate/model/story.dart';
import 'package:story_app_flutter_intermediate/model/upload_response.dart';

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
      throw Exception(json.decode(response.body)['message']);
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
      return LoginData.fromJson(json.decode(response.body));
    } else {
      throw Exception(json.decode(response.body)['message']);
    }
  }

  Future<List<Story>> getListStory(int page, int size) async {
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
      return ListStoryResponse.fromJson(json.decode(response.body)).listStory;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<Story> getDetailStory(String storyId) async {
    Uri url = Uri.parse("$_baseUrl/stories/$storyId");

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
      return DetailStoryResponse.fromJson(json.decode(response.body)).story;
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  Future<UploadResponse> uploadDocument(
    List<int> bytes,
    String fileName,
    String description,
    LatLng? location,
  ) async {
    Uri url = Uri.parse("$_baseUrl/stories");

    final preferences = await SharedPreferences.getInstance();
    final token = preferences.getString("authToken") ?? "";
    String bearerToken = "Bearer $token";

    var request = http.MultipartRequest('POST', url);

    final multiPartFile = http.MultipartFile.fromBytes(
      "photo",
      bytes,
      filename: fileName,
    );

    final Map<String, String> fields = {
      "description": description,
    };

    if (location != null) {
      fields.addAll({
        "lat": location.latitude.toString(),
        "lon": location.longitude.toString(),
      });
    }

    final Map<String, String> headers = {
      "Content-type": "multipart/form-data",
      'Authorization': bearerToken,
    };

    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    if (statusCode == 201) {
      final UploadResponse uploadResponse = UploadResponse.fromJson(
        json.decode(responseData),
      );
      return uploadResponse;
    } else {
      throw Exception("Upload file error");
    }
  }
}
