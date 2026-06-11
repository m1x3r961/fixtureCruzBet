import 'package:freezed_annotation/freezed_annotation.dart';

part 'prediction_model.freezed.dart';
part 'prediction_model.g.dart';

/// Representa la predicción de un usuario para un partido.
/// Corresponde a la tabla `predictions` en Supabase.
@freezed
class Prediction with _$Prediction {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Prediction({
    required String id,
    required String userId,
    required String matchId,
    required int homeScore,
    required int awayScore,
    int? pointsEarned,
    DateTime? createdAt,
  }) = _Prediction;

  factory Prediction.fromJson(Map<String, dynamic> json) =>
      _$PredictionFromJson(json);
}

/// DTO para crear/actualizar una predicción.
/// NO usa freezed para poder tener un método personalizado.
class PredictionInput {
  final String matchId;
  final int homeScore;
  final int awayScore;

  const PredictionInput({
    required this.matchId,
    required this.homeScore,
    required this.awayScore,
  });

  /// Serializa para enviar a Supabase incluyendo el user_id del usuario autenticado.
  /// Con RLS activo, Supabase valida que user_id == auth.uid().
  Map<String, dynamic> toSupabaseJson(String userId) => {
        'user_id': userId,
        'match_id': matchId,
        'home_score': homeScore,
        'away_score': awayScore,
      };
}
