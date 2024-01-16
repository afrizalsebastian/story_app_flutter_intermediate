import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app_flutter_intermediate/api/api_services.dart';
import 'package:story_app_flutter_intermediate/model/detail_story.dart';
import 'package:story_app_flutter_intermediate/provider/api_enum.dart';

class DetailStoryProvider extends ChangeNotifier {
  final ApiServices apiServices;
  String storyId;

  DetailStoryProvider({required this.apiServices, required this.storyId});

  late Story _story;
  late ResultState _state;
  String _message = '';

  String get message => _message;
  Story get story => _story;
  ResultState get state => _state;

  Future<dynamic> upadteStoryId(String newStoryId) async {
    storyId = newStoryId;
    return await _fetchData();
  }

  Future<dynamic> _fetchData() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final storyData = await apiServices.getDetailStory(storyId);
      _state = ResultState.hasData;
      notifyListeners();
      return _story = storyData;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (e is SocketException) {
        _message = 'No Internet Connection';
        return message;
      } else {
        _message = 'Error: $e';
        return message;
      }
    }
  }
}
