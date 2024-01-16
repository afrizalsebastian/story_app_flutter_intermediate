import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app_flutter_intermediate/api/api_services.dart';
import 'package:story_app_flutter_intermediate/model/detail_story.dart';
import 'package:story_app_flutter_intermediate/provider/api_enum.dart';

class ListStoryProvider extends ChangeNotifier {
  final ApiServices apiServices;

  ListStoryProvider({required this.apiServices}) {
    _fetchData();
  }

  List<Story> _listStory = [];
  late ResultState _state;
  String _message = '';
  int page = 1;
  int size = 10;

  String get message => _message;
  List<Story> get listStory => _listStory;
  ResultState get state => _state;

  Future<dynamic> updateList() async {
    return await _fetchData();
  }

  Future<dynamic> _fetchData() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final listStoryData = await apiServices.getListStory(page, size);
      if (listStoryData.isEmpty) {
        _state = ResultState.noData;
        _listStory = [];
        notifyListeners();
        return _message = 'There is no Story Posted';
      } else {
        _state = ResultState.hasData;
        _listStory = listStoryData;
        notifyListeners();
        return listStory;
      }
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

  Future<dynamic> prevoiusPage() async {
    page--;
    _fetchData();
  }

  Future<dynamic> nextPage() async {
    page++;
    _fetchData();
  }
}
