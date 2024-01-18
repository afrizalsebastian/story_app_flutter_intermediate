import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app_flutter_intermediate/api/api_services.dart';
import 'package:story_app_flutter_intermediate/model/story.dart';
import 'package:story_app_flutter_intermediate/provider/api_enum.dart';

class ListStoryProvider extends ChangeNotifier {
  final ApiServices apiServices;

  ListStoryProvider({required this.apiServices});

  List<Story> _listStory = [];
  ResultState _state = ResultState.initial;
  String _message = '';
  int? page = 1;
  int size = 10;

  String get message => _message;
  List<Story> get listStory => _listStory;
  ResultState get state => _state;

  Future<void> updateList() async {
    _listStory = [];
    page = 1;
    await _fetchData();
  }

  Future<void> nextList() async {
    await _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      if (page == 1) {
        _state = ResultState.loading;
        notifyListeners();
      }

      final listStoryData = await apiServices.getListStory(page!, size);
      _listStory.addAll(listStoryData);
      _state = ResultState.hasData;

      if (listStoryData.length < size) {
        page = null;
      } else {
        page = page! + 1;
      }

      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (e is SocketException) {
        _message = 'No Internet Connection';
      } else {
        _message = 'Error: $e';
      }
    }
  }
}
