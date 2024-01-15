import 'dart:convert';

import 'package:story_app_flutter_intermediate/model/detail_story.dart';

ListStoryResponse listStoryResponseFromJson(String str) =>
    ListStoryResponse.fromJson(json.decode(str));

String listStoryResponseToJson(ListStoryResponse data) =>
    json.encode(data.toJson());

class ListStoryResponse {
  bool error;
  String message;
  List<Story> listStory;

  ListStoryResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory ListStoryResponse.fromJson(Map<String, dynamic> json) =>
      ListStoryResponse(
        error: json["error"],
        message: json["message"],
        listStory:
            List<Story>.from(json["listStory"].map((x) => Story.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "message": message,
        "listStory": List<dynamic>.from(listStory.map((x) => x.toJson())),
      };
}
