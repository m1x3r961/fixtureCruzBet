import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_provider.dart';
import '../domain/leaderboard_model.dart';

part 'leaderboard_repository.g.dart';

class LeaderboardRepository {
  final SupabaseClient _client;

  LeaderboardRepository(this._client);

  /// Obtiene el ranking completo desde la vista `public_leaderboard`.
  Future<List<LeaderboardEntry>> getLeaderboard() async {
    final response = await _client
        .from('public_leaderboard')
        .select();

    return (response as List)
        .map((row) => LeaderboardEntry.fromJson(row as Map<String, dynamic>))
        .toList();
  }
}

@riverpod
LeaderboardRepository leaderboardRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return LeaderboardRepository(client);
}

@riverpod
Future<List<LeaderboardEntry>> leaderboard(Ref ref) {
  ref.watch(authStateStreamProvider);
  final repo = ref.watch(leaderboardRepositoryProvider);
  return repo.getLeaderboard();
}
