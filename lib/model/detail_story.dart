import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:story_app_flutter_intermediate/model/story.dart';

part 'detail_story.freezed.dart';
part 'detail_story.g.dart';

@freezed
class DetailStoryResponse with _$DetailStoryResponse {
  const factory DetailStoryResponse({
    required bool error,
    required String message,
    required Story story,
  }) = _DetailStoryResponse;

  factory DetailStoryResponse.fromJson(Map<String, dynamic> json) =>
      _$DetailStoryResponseFromJson(json);
}
