/// Representa la entrada de un usuario en el ranking de puntos.
/// Corresponde a la vista `public_leaderboard` en Supabase.
class LeaderboardEntry {
  final String userId;
  final String? email;
  final int totalPredictions;
  final int exactResults;
  final int correctOutcomes;
  final int misses;
  final int totalPoints;

  const LeaderboardEntry({
    required this.userId,
    this.email,
    required this.totalPredictions,
    required this.exactResults,
    required this.correctOutcomes,
    required this.misses,
    required this.totalPoints,
  });

  /// Nombre para mostrar: parte antes del @ del email
  String get displayName {
    if (email != null && email!.isNotEmpty) {
      return email!.split('@').first;
    }
    return 'Anónimo';
  }

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      userId: json['user_id'] as String,
      email: json['email'] as String?,
      totalPredictions: (json['total_predictions'] as num).toInt(),
      exactResults: (json['exact_results'] as num).toInt(),
      correctOutcomes: (json['correct_outcomes'] as num).toInt(),
      misses: (json['misses'] as num).toInt(),
      totalPoints: (json['total_points'] as num).toInt(),
    );
  }
}
