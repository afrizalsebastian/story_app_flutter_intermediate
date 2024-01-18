import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:story_app_flutter_intermediate/model/story.dart';

part 'list_story.freezed.dart';
part 'list_story.g.dart';

@freezed
class ListStoryResponse with _$ListStoryResponse {
  const factory ListStoryResponse({
    required bool error,
    required String message,
    required List<Story> listStory,
  }) = _ListStoryResponse;

  factory ListStoryResponse.fromJson(Map<String, dynamic> json) =>
      _$ListStoryResponseFromJson(json);
}
