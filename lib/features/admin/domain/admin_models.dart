import 'package:freezed_annotation/freezed_annotation.dart';
import '../../predictions/domain/prediction_model.dart';
import '../../auth/domain/profile_model.dart';

part 'admin_models.freezed.dart';

@freezed
class UserSummary with _$UserSummary {
  const factory UserSummary({
    required Profile profile,
    required int totalPredictions,
    required List<Prediction> predictions,
  }) = _UserSummary;
}

@freezed
class AdminDashboardData with _$AdminDashboardData {
  const factory AdminDashboardData({
    required int totalUsers,
    required int totalPredictions,
    required List<UserSummary> leaderboard,
  }) = _AdminDashboardData;
}
