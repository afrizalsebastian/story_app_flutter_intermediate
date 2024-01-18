// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_story.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

ListStoryResponse _$ListStoryResponseFromJson(Map<String, dynamic> json) {
  return _ListStoryResponse.fromJson(json);
}

/// @nodoc
mixin _$ListStoryResponse {
  bool get error => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;
  List<Story> get listStory => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ListStoryResponseCopyWith<ListStoryResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ListStoryResponseCopyWith<$Res> {
  factory $ListStoryResponseCopyWith(
          ListStoryResponse value, $Res Function(ListStoryResponse) then) =
      _$ListStoryResponseCopyWithImpl<$Res, ListStoryResponse>;
  @useResult
  $Res call({bool error, String message, List<Story> listStory});
}

/// @nodoc
class _$ListStoryResponseCopyWithImpl<$Res, $Val extends ListStoryResponse>
    implements $ListStoryResponseCopyWith<$Res> {
  _$ListStoryResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
    Object? listStory = null,
  }) {
    return _then(_value.copyWith(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      listStory: null == listStory
          ? _value.listStory
          : listStory // ignore: cast_nullable_to_non_nullable
              as List<Story>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ListStoryResponseImplCopyWith<$Res>
    implements $ListStoryResponseCopyWith<$Res> {
  factory _$$ListStoryResponseImplCopyWith(_$ListStoryResponseImpl value,
          $Res Function(_$ListStoryResponseImpl) then) =
      __$$ListStoryResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool error, String message, List<Story> listStory});
}

/// @nodoc
class __$$ListStoryResponseImplCopyWithImpl<$Res>
    extends _$ListStoryResponseCopyWithImpl<$Res, _$ListStoryResponseImpl>
    implements _$$ListStoryResponseImplCopyWith<$Res> {
  __$$ListStoryResponseImplCopyWithImpl(_$ListStoryResponseImpl _value,
      $Res Function(_$ListStoryResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? error = null,
    Object? message = null,
    Object? listStory = null,
  }) {
    return _then(_$ListStoryResponseImpl(
      error: null == error
          ? _value.error
          : error // ignore: cast_nullable_to_non_nullable
              as bool,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      listStory: null == listStory
          ? _value._listStory
          : listStory // ignore: cast_nullable_to_non_nullable
              as List<Story>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ListStoryResponseImpl implements _ListStoryResponse {
  const _$ListStoryResponseImpl(
      {required this.error,
      required this.message,
      required final List<Story> listStory})
      : _listStory = listStory;

  factory _$ListStoryResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ListStoryResponseImplFromJson(json);

  @override
  final bool error;
  @override
  final String message;
  final List<Story> _listStory;
  @override
  List<Story> get listStory {
    if (_listStory is EqualUnmodifiableListView) return _listStory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_listStory);
  }

  @override
  String toString() {
    return 'ListStoryResponse(error: $error, message: $message, listStory: $listStory)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ListStoryResponseImpl &&
            (identical(other.error, error) || other.error == error) &&
            (identical(other.message, message) || other.message == message) &&
            const DeepCollectionEquality()
                .equals(other._listStory, _listStory));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, error, message,
      const DeepCollectionEquality().hash(_listStory));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ListStoryResponseImplCopyWith<_$ListStoryResponseImpl> get copyWith =>
      __$$ListStoryResponseImplCopyWithImpl<_$ListStoryResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ListStoryResponseImplToJson(
      this,
    );
  }
}

abstract class _ListStoryResponse implements ListStoryResponse {
  const factory _ListStoryResponse(
      {required final bool error,
      required final String message,
      required final List<Story> listStory}) = _$ListStoryResponseImpl;

  factory _ListStoryResponse.fromJson(Map<String, dynamic> json) =
      _$ListStoryResponseImpl.fromJson;

  @override
  bool get error;
  @override
  String get message;
  @override
  List<Story> get listStory;
  @override
  @JsonKey(ignore: true)
  _$$ListStoryResponseImplCopyWith<_$ListStoryResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
