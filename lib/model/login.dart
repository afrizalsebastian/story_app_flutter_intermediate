import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:story_app_flutter_intermediate/model/login_result.dart';

part 'login.freezed.dart';
part 'login.g.dart';

@freezed
class LoginData with _$LoginData {
  const factory LoginData({
    required bool error,
    required String message,
    required LoginResult loginResult,
  }) = _LoginData;

  factory LoginData.fromJson(Map<String, dynamic> json) =>
      _$LoginDataFromJson(json);
}
