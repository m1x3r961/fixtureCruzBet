import 'package:freezed_annotation/freezed_annotation.dart';

part 'match_model.freezed.dart';
part 'match_model.g.dart';

/// Representa un partido del Mundial.
/// Corresponde a la tabla `matches` en Supabase.
///
/// Esquema asumido:
/// - id: uuid (PK)
/// - home_team: text
/// - away_team: text
/// - home_score: int? (null si no ha iniciado)
/// - away_score: int? (null si no ha iniciado)
/// - match_time: timestamptz
/// - status: text ('scheduled' | 'live' | 'finished')
/// - stage: text? ('group' | 'round_of_16' | 'quarter' | 'semi' | 'final')
/// - group_name: text? (ej. 'Grupo A')
/// - api_football_id: int? (ID del partido en API-Football para sincronización)
@freezed
class Match with _$Match {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Match({
    required String id,
    required String homeTeam,
    required String awayTeam,
    int? homeScore,
    int? awayScore,
    required DateTime matchTime,
    required String status,
    String? stage,
    String? groupName,
    int? apiFootballId,
    // Banderas (emoji o código de país para la UI)
    String? homeFlag,
    String? awayFlag,
  }) = _Match;

  /// Deserializa desde el JSON de Supabase (snake_case → camelCase).
  factory Match.fromJson(Map<String, dynamic> json) => _$MatchFromJson(json);
}

/// Extensión para lógica de dominio sobre el modelo Match.
extension MatchX on Match {
  bool get isLive =>
      status.toUpperCase() == 'LIVE' || status.toUpperCase() == 'IN_PLAY';

  bool get isFinished => status.toUpperCase() == 'FINISHED' ||
      status.toUpperCase() == 'FT';

  bool get isScheduled => !isLive && !isFinished;

  String get scoreDisplay {
    if (homeScore != null && awayScore != null) {
      return '$homeScore - $awayScore';
    }
    return 'vs';
  }
}
