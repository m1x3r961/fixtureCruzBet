// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$UserSummary {
  Profile get profile => throw _privateConstructorUsedError;
  int get totalPredictions => throw _privateConstructorUsedError;
  List<Prediction> get predictions => throw _privateConstructorUsedError;

  /// Create a copy of UserSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSummaryCopyWith<UserSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSummaryCopyWith<$Res> {
  factory $UserSummaryCopyWith(
          UserSummary value, $Res Function(UserSummary) then) =
      _$UserSummaryCopyWithImpl<$Res, UserSummary>;
  @useResult
  $Res call(
      {Profile profile, int totalPredictions, List<Prediction> predictions});

  $ProfileCopyWith<$Res> get profile;
}

/// @nodoc
class _$UserSummaryCopyWithImpl<$Res, $Val extends UserSummary>
    implements $UserSummaryCopyWith<$Res> {
  _$UserSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = null,
    Object? totalPredictions = null,
    Object? predictions = null,
  }) {
    return _then(_value.copyWith(
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile,
      totalPredictions: null == totalPredictions
          ? _value.totalPredictions
          : totalPredictions // ignore: cast_nullable_to_non_nullable
              as int,
      predictions: null == predictions
          ? _value.predictions
          : predictions // ignore: cast_nullable_to_non_nullable
              as List<Prediction>,
    ) as $Val);
  }

  /// Create a copy of UserSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProfileCopyWith<$Res> get profile {
    return $ProfileCopyWith<$Res>(_value.profile, (value) {
      return _then(_value.copyWith(profile: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserSummaryImplCopyWith<$Res>
    implements $UserSummaryCopyWith<$Res> {
  factory _$$UserSummaryImplCopyWith(
          _$UserSummaryImpl value, $Res Function(_$UserSummaryImpl) then) =
      __$$UserSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Profile profile, int totalPredictions, List<Prediction> predictions});

  @override
  $ProfileCopyWith<$Res> get profile;
}

/// @nodoc
class __$$UserSummaryImplCopyWithImpl<$Res>
    extends _$UserSummaryCopyWithImpl<$Res, _$UserSummaryImpl>
    implements _$$UserSummaryImplCopyWith<$Res> {
  __$$UserSummaryImplCopyWithImpl(
      _$UserSummaryImpl _value, $Res Function(_$UserSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? profile = null,
    Object? totalPredictions = null,
    Object? predictions = null,
  }) {
    return _then(_$UserSummaryImpl(
      profile: null == profile
          ? _value.profile
          : profile // ignore: cast_nullable_to_non_nullable
              as Profile,
      totalPredictions: null == totalPredictions
          ? _value.totalPredictions
          : totalPredictions // ignore: cast_nullable_to_non_nullable
              as int,
      predictions: null == predictions
          ? _value._predictions
          : predictions // ignore: cast_nullable_to_non_nullable
              as List<Prediction>,
    ));
  }
}

/// @nodoc

class _$UserSummaryImpl implements _UserSummary {
  const _$UserSummaryImpl(
      {required this.profile,
      required this.totalPredictions,
      required final List<Prediction> predictions})
      : _predictions = predictions;

  @override
  final Profile profile;
  @override
  final int totalPredictions;
  final List<Prediction> _predictions;
  @override
  List<Prediction> get predictions {
    if (_predictions is EqualUnmodifiableListView) return _predictions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_predictions);
  }

  @override
  String toString() {
    return 'UserSummary(profile: $profile, totalPredictions: $totalPredictions, predictions: $predictions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSummaryImpl &&
            (identical(other.profile, profile) || other.profile == profile) &&
            (identical(other.totalPredictions, totalPredictions) ||
                other.totalPredictions == totalPredictions) &&
            const DeepCollectionEquality()
                .equals(other._predictions, _predictions));
  }

  @override
  int get hashCode => Object.hash(runtimeType, profile, totalPredictions,
      const DeepCollectionEquality().hash(_predictions));

  /// Create a copy of UserSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSummaryImplCopyWith<_$UserSummaryImpl> get copyWith =>
      __$$UserSummaryImplCopyWithImpl<_$UserSummaryImpl>(this, _$identity);
}

abstract class _UserSummary implements UserSummary {
  const factory _UserSummary(
      {required final Profile profile,
      required final int totalPredictions,
      required final List<Prediction> predictions}) = _$UserSummaryImpl;

  @override
  Profile get profile;
  @override
  int get totalPredictions;
  @override
  List<Prediction> get predictions;

  /// Create a copy of UserSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSummaryImplCopyWith<_$UserSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$AdminDashboardData {
  int get totalUsers => throw _privateConstructorUsedError;
  int get totalPredictions => throw _privateConstructorUsedError;
  List<UserSummary> get leaderboard => throw _privateConstructorUsedError;

  /// Create a copy of AdminDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AdminDashboardDataCopyWith<AdminDashboardData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AdminDashboardDataCopyWith<$Res> {
  factory $AdminDashboardDataCopyWith(
          AdminDashboardData value, $Res Function(AdminDashboardData) then) =
      _$AdminDashboardDataCopyWithImpl<$Res, AdminDashboardData>;
  @useResult
  $Res call(
      {int totalUsers, int totalPredictions, List<UserSummary> leaderboard});
}

/// @nodoc
class _$AdminDashboardDataCopyWithImpl<$Res, $Val extends AdminDashboardData>
    implements $AdminDashboardDataCopyWith<$Res> {
  _$AdminDashboardDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AdminDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? totalPredictions = null,
    Object? leaderboard = null,
  }) {
    return _then(_value.copyWith(
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      totalPredictions: null == totalPredictions
          ? _value.totalPredictions
          : totalPredictions // ignore: cast_nullable_to_non_nullable
              as int,
      leaderboard: null == leaderboard
          ? _value.leaderboard
          : leaderboard // ignore: cast_nullable_to_non_nullable
              as List<UserSummary>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AdminDashboardDataImplCopyWith<$Res>
    implements $AdminDashboardDataCopyWith<$Res> {
  factory _$$AdminDashboardDataImplCopyWith(_$AdminDashboardDataImpl value,
          $Res Function(_$AdminDashboardDataImpl) then) =
      __$$AdminDashboardDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalUsers, int totalPredictions, List<UserSummary> leaderboard});
}

/// @nodoc
class __$$AdminDashboardDataImplCopyWithImpl<$Res>
    extends _$AdminDashboardDataCopyWithImpl<$Res, _$AdminDashboardDataImpl>
    implements _$$AdminDashboardDataImplCopyWith<$Res> {
  __$$AdminDashboardDataImplCopyWithImpl(_$AdminDashboardDataImpl _value,
      $Res Function(_$AdminDashboardDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of AdminDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalUsers = null,
    Object? totalPredictions = null,
    Object? leaderboard = null,
  }) {
    return _then(_$AdminDashboardDataImpl(
      totalUsers: null == totalUsers
          ? _value.totalUsers
          : totalUsers // ignore: cast_nullable_to_non_nullable
              as int,
      totalPredictions: null == totalPredictions
          ? _value.totalPredictions
          : totalPredictions // ignore: cast_nullable_to_non_nullable
              as int,
      leaderboard: null == leaderboard
          ? _value._leaderboard
          : leaderboard // ignore: cast_nullable_to_non_nullable
              as List<UserSummary>,
    ));
  }
}

/// @nodoc

class _$AdminDashboardDataImpl implements _AdminDashboardData {
  const _$AdminDashboardDataImpl(
      {required this.totalUsers,
      required this.totalPredictions,
      required final List<UserSummary> leaderboard})
      : _leaderboard = leaderboard;

  @override
  final int totalUsers;
  @override
  final int totalPredictions;
  final List<UserSummary> _leaderboard;
  @override
  List<UserSummary> get leaderboard {
    if (_leaderboard is EqualUnmodifiableListView) return _leaderboard;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_leaderboard);
  }

  @override
  String toString() {
    return 'AdminDashboardData(totalUsers: $totalUsers, totalPredictions: $totalPredictions, leaderboard: $leaderboard)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AdminDashboardDataImpl &&
            (identical(other.totalUsers, totalUsers) ||
                other.totalUsers == totalUsers) &&
            (identical(other.totalPredictions, totalPredictions) ||
                other.totalPredictions == totalPredictions) &&
            const DeepCollectionEquality()
                .equals(other._leaderboard, _leaderboard));
  }

  @override
  int get hashCode => Object.hash(runtimeType, totalUsers, totalPredictions,
      const DeepCollectionEquality().hash(_leaderboard));

  /// Create a copy of AdminDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AdminDashboardDataImplCopyWith<_$AdminDashboardDataImpl> get copyWith =>
      __$$AdminDashboardDataImplCopyWithImpl<_$AdminDashboardDataImpl>(
          this, _$identity);
}

abstract class _AdminDashboardData implements AdminDashboardData {
  const factory _AdminDashboardData(
      {required final int totalUsers,
      required final int totalPredictions,
      required final List<UserSummary> leaderboard}) = _$AdminDashboardDataImpl;

  @override
  int get totalUsers;
  @override
  int get totalPredictions;
  @override
  List<UserSummary> get leaderboard;

  /// Create a copy of AdminDashboardData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AdminDashboardDataImplCopyWith<_$AdminDashboardDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
