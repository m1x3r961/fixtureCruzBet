// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Match _$MatchFromJson(Map<String, dynamic> json) {
  return _Match.fromJson(json);
}

/// @nodoc
mixin _$Match {
  String get id => throw _privateConstructorUsedError;
  String get homeTeam => throw _privateConstructorUsedError;
  String get awayTeam => throw _privateConstructorUsedError;
  int? get homeScore => throw _privateConstructorUsedError;
  int? get awayScore => throw _privateConstructorUsedError;
  DateTime get matchTime => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get stage => throw _privateConstructorUsedError;
  String? get groupName => throw _privateConstructorUsedError;
  int? get apiFootballId =>
      throw _privateConstructorUsedError; // Banderas (emoji o código de país para la UI)
  String? get homeFlag => throw _privateConstructorUsedError;
  String? get awayFlag => throw _privateConstructorUsedError;

  /// Serializes this Match to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MatchCopyWith<Match> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MatchCopyWith<$Res> {
  factory $MatchCopyWith(Match value, $Res Function(Match) then) =
      _$MatchCopyWithImpl<$Res, Match>;
  @useResult
  $Res call(
      {String id,
      String homeTeam,
      String awayTeam,
      int? homeScore,
      int? awayScore,
      DateTime matchTime,
      String status,
      String? stage,
      String? groupName,
      int? apiFootballId,
      String? homeFlag,
      String? awayFlag});
}

/// @nodoc
class _$MatchCopyWithImpl<$Res, $Val extends Match>
    implements $MatchCopyWith<$Res> {
  _$MatchCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? homeTeam = null,
    Object? awayTeam = null,
    Object? homeScore = freezed,
    Object? awayScore = freezed,
    Object? matchTime = null,
    Object? status = null,
    Object? stage = freezed,
    Object? groupName = freezed,
    Object? apiFootballId = freezed,
    Object? homeFlag = freezed,
    Object? awayFlag = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      homeTeam: null == homeTeam
          ? _value.homeTeam
          : homeTeam // ignore: cast_nullable_to_non_nullable
              as String,
      awayTeam: null == awayTeam
          ? _value.awayTeam
          : awayTeam // ignore: cast_nullable_to_non_nullable
              as String,
      homeScore: freezed == homeScore
          ? _value.homeScore
          : homeScore // ignore: cast_nullable_to_non_nullable
              as int?,
      awayScore: freezed == awayScore
          ? _value.awayScore
          : awayScore // ignore: cast_nullable_to_non_nullable
              as int?,
      matchTime: null == matchTime
          ? _value.matchTime
          : matchTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      stage: freezed == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as String?,
      groupName: freezed == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String?,
      apiFootballId: freezed == apiFootballId
          ? _value.apiFootballId
          : apiFootballId // ignore: cast_nullable_to_non_nullable
              as int?,
      homeFlag: freezed == homeFlag
          ? _value.homeFlag
          : homeFlag // ignore: cast_nullable_to_non_nullable
              as String?,
      awayFlag: freezed == awayFlag
          ? _value.awayFlag
          : awayFlag // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MatchImplCopyWith<$Res> implements $MatchCopyWith<$Res> {
  factory _$$MatchImplCopyWith(
          _$MatchImpl value, $Res Function(_$MatchImpl) then) =
      __$$MatchImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String homeTeam,
      String awayTeam,
      int? homeScore,
      int? awayScore,
      DateTime matchTime,
      String status,
      String? stage,
      String? groupName,
      int? apiFootballId,
      String? homeFlag,
      String? awayFlag});
}

/// @nodoc
class __$$MatchImplCopyWithImpl<$Res>
    extends _$MatchCopyWithImpl<$Res, _$MatchImpl>
    implements _$$MatchImplCopyWith<$Res> {
  __$$MatchImplCopyWithImpl(
      _$MatchImpl _value, $Res Function(_$MatchImpl) _then)
      : super(_value, _then);

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? homeTeam = null,
    Object? awayTeam = null,
    Object? homeScore = freezed,
    Object? awayScore = freezed,
    Object? matchTime = null,
    Object? status = null,
    Object? stage = freezed,
    Object? groupName = freezed,
    Object? apiFootballId = freezed,
    Object? homeFlag = freezed,
    Object? awayFlag = freezed,
  }) {
    return _then(_$MatchImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      homeTeam: null == homeTeam
          ? _value.homeTeam
          : homeTeam // ignore: cast_nullable_to_non_nullable
              as String,
      awayTeam: null == awayTeam
          ? _value.awayTeam
          : awayTeam // ignore: cast_nullable_to_non_nullable
              as String,
      homeScore: freezed == homeScore
          ? _value.homeScore
          : homeScore // ignore: cast_nullable_to_non_nullable
              as int?,
      awayScore: freezed == awayScore
          ? _value.awayScore
          : awayScore // ignore: cast_nullable_to_non_nullable
              as int?,
      matchTime: null == matchTime
          ? _value.matchTime
          : matchTime // ignore: cast_nullable_to_non_nullable
              as DateTime,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      stage: freezed == stage
          ? _value.stage
          : stage // ignore: cast_nullable_to_non_nullable
              as String?,
      groupName: freezed == groupName
          ? _value.groupName
          : groupName // ignore: cast_nullable_to_non_nullable
              as String?,
      apiFootballId: freezed == apiFootballId
          ? _value.apiFootballId
          : apiFootballId // ignore: cast_nullable_to_non_nullable
              as int?,
      homeFlag: freezed == homeFlag
          ? _value.homeFlag
          : homeFlag // ignore: cast_nullable_to_non_nullable
              as String?,
      awayFlag: freezed == awayFlag
          ? _value.awayFlag
          : awayFlag // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _$MatchImpl implements _Match {
  const _$MatchImpl(
      {required this.id,
      required this.homeTeam,
      required this.awayTeam,
      this.homeScore,
      this.awayScore,
      required this.matchTime,
      required this.status,
      this.stage,
      this.groupName,
      this.apiFootballId,
      this.homeFlag,
      this.awayFlag});

  factory _$MatchImpl.fromJson(Map<String, dynamic> json) =>
      _$$MatchImplFromJson(json);

  @override
  final String id;
  @override
  final String homeTeam;
  @override
  final String awayTeam;
  @override
  final int? homeScore;
  @override
  final int? awayScore;
  @override
  final DateTime matchTime;
  @override
  final String status;
  @override
  final String? stage;
  @override
  final String? groupName;
  @override
  final int? apiFootballId;
// Banderas (emoji o código de país para la UI)
  @override
  final String? homeFlag;
  @override
  final String? awayFlag;

  @override
  String toString() {
    return 'Match(id: $id, homeTeam: $homeTeam, awayTeam: $awayTeam, homeScore: $homeScore, awayScore: $awayScore, matchTime: $matchTime, status: $status, stage: $stage, groupName: $groupName, apiFootballId: $apiFootballId, homeFlag: $homeFlag, awayFlag: $awayFlag)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MatchImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.homeTeam, homeTeam) ||
                other.homeTeam == homeTeam) &&
            (identical(other.awayTeam, awayTeam) ||
                other.awayTeam == awayTeam) &&
            (identical(other.homeScore, homeScore) ||
                other.homeScore == homeScore) &&
            (identical(other.awayScore, awayScore) ||
                other.awayScore == awayScore) &&
            (identical(other.matchTime, matchTime) ||
                other.matchTime == matchTime) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.stage, stage) || other.stage == stage) &&
            (identical(other.groupName, groupName) ||
                other.groupName == groupName) &&
            (identical(other.apiFootballId, apiFootballId) ||
                other.apiFootballId == apiFootballId) &&
            (identical(other.homeFlag, homeFlag) ||
                other.homeFlag == homeFlag) &&
            (identical(other.awayFlag, awayFlag) ||
                other.awayFlag == awayFlag));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      homeTeam,
      awayTeam,
      homeScore,
      awayScore,
      matchTime,
      status,
      stage,
      groupName,
      apiFootballId,
      homeFlag,
      awayFlag);

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      __$$MatchImplCopyWithImpl<_$MatchImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MatchImplToJson(
      this,
    );
  }
}

abstract class _Match implements Match {
  const factory _Match(
      {required final String id,
      required final String homeTeam,
      required final String awayTeam,
      final int? homeScore,
      final int? awayScore,
      required final DateTime matchTime,
      required final String status,
      final String? stage,
      final String? groupName,
      final int? apiFootballId,
      final String? homeFlag,
      final String? awayFlag}) = _$MatchImpl;

  factory _Match.fromJson(Map<String, dynamic> json) = _$MatchImpl.fromJson;

  @override
  String get id;
  @override
  String get homeTeam;
  @override
  String get awayTeam;
  @override
  int? get homeScore;
  @override
  int? get awayScore;
  @override
  DateTime get matchTime;
  @override
  String get status;
  @override
  String? get stage;
  @override
  String? get groupName;
  @override
  int? get apiFootballId; // Banderas (emoji o código de país para la UI)
  @override
  String? get homeFlag;
  @override
  String? get awayFlag;

  /// Create a copy of Match
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MatchImplCopyWith<_$MatchImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
