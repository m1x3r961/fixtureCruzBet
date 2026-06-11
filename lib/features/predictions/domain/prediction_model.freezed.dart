// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prediction_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Prediction _$PredictionFromJson(Map<String, dynamic> json) {
  return _Prediction.fromJson(json);
}

/// @nodoc
mixin _$Prediction {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get matchId => throw _privateConstructorUsedError;
  int get homeScore => throw _privateConstructorUsedError;
  int get awayScore => throw _privateConstructorUsedError;
  int? get pointsEarned => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Prediction to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Prediction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PredictionCopyWith<Prediction> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PredictionCopyWith<$Res> {
  factory $PredictionCopyWith(
          Prediction value, $Res Function(Prediction) then) =
      _$PredictionCopyWithImpl<$Res, Prediction>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String matchId,
      int homeScore,
      int awayScore,
      int? pointsEarned,
      DateTime? createdAt});
}

/// @nodoc
class _$PredictionCopyWithImpl<$Res, $Val extends Prediction>
    implements $PredictionCopyWith<$Res> {
  _$PredictionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Prediction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? matchId = null,
    Object? homeScore = null,
    Object? awayScore = null,
    Object? pointsEarned = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      matchId: null == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      homeScore: null == homeScore
          ? _value.homeScore
          : homeScore // ignore: cast_nullable_to_non_nullable
              as int,
      awayScore: null == awayScore
          ? _value.awayScore
          : awayScore // ignore: cast_nullable_to_non_nullable
              as int,
      pointsEarned: freezed == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PredictionImplCopyWith<$Res>
    implements $PredictionCopyWith<$Res> {
  factory _$$PredictionImplCopyWith(
          _$PredictionImpl value, $Res Function(_$PredictionImpl) then) =
      __$$PredictionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String matchId,
      int homeScore,
      int awayScore,
      int? pointsEarned,
      DateTime? createdAt});
}

/// @nodoc
class __$$PredictionImplCopyWithImpl<$Res>
    extends _$PredictionCopyWithImpl<$Res, _$PredictionImpl>
    implements _$$PredictionImplCopyWith<$Res> {
  __$$PredictionImplCopyWithImpl(
      _$PredictionImpl _value, $Res Function(_$PredictionImpl) _then)
      : super(_value, _then);

  /// Create a copy of Prediction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? matchId = null,
    Object? homeScore = null,
    Object? awayScore = null,
    Object? pointsEarned = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(_$PredictionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      matchId: null == matchId
          ? _value.matchId
          : matchId // ignore: cast_nullable_to_non_nullable
              as String,
      homeScore: null == homeScore
          ? _value.homeScore
          : homeScore // ignore: cast_nullable_to_non_nullable
              as int,
      awayScore: null == awayScore
          ? _value.awayScore
          : awayScore // ignore: cast_nullable_to_non_nullable
              as int,
      pointsEarned: freezed == pointsEarned
          ? _value.pointsEarned
          : pointsEarned // ignore: cast_nullable_to_non_nullable
              as int?,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$PredictionImpl implements _Prediction {
  const _$PredictionImpl(
      {required this.id,
      required this.userId,
      required this.matchId,
      required this.homeScore,
      required this.awayScore,
      this.pointsEarned,
      this.createdAt});

  factory _$PredictionImpl.fromJson(Map<String, dynamic> json) =>
      _$$PredictionImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String matchId;
  @override
  final int homeScore;
  @override
  final int awayScore;
  @override
  final int? pointsEarned;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Prediction(id: $id, userId: $userId, matchId: $matchId, homeScore: $homeScore, awayScore: $awayScore, pointsEarned: $pointsEarned, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PredictionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.matchId, matchId) || other.matchId == matchId) &&
            (identical(other.homeScore, homeScore) ||
                other.homeScore == homeScore) &&
            (identical(other.awayScore, awayScore) ||
                other.awayScore == awayScore) &&
            (identical(other.pointsEarned, pointsEarned) ||
                other.pointsEarned == pointsEarned) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, matchId, homeScore,
      awayScore, pointsEarned, createdAt);

  /// Create a copy of Prediction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PredictionImplCopyWith<_$PredictionImpl> get copyWith =>
      __$$PredictionImplCopyWithImpl<_$PredictionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PredictionImplToJson(
      this,
    );
  }
}

abstract class _Prediction implements Prediction {
  const factory _Prediction(
      {required final String id,
      required final String userId,
      required final String matchId,
      required final int homeScore,
      required final int awayScore,
      final int? pointsEarned,
      final DateTime? createdAt}) = _$PredictionImpl;

  factory _Prediction.fromJson(Map<String, dynamic> json) =
      _$PredictionImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get matchId;
  @override
  int get homeScore;
  @override
  int get awayScore;
  @override
  int? get pointsEarned;
  @override
  DateTime? get createdAt;

  /// Create a copy of Prediction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PredictionImplCopyWith<_$PredictionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
