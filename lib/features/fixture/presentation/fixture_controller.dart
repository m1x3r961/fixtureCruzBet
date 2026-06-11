import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/match_repository.dart';
import '../domain/match_model.dart';

part 'fixture_controller.g.dart';

/// Controller del fixture. Expone los partidos en tiempo real via Supabase Realtime.
@riverpod
class FixtureController extends _$FixtureController {
  @override
  Stream<List<Match>> build() {
    final repo = ref.watch(matchRepositoryProvider);
    return repo.watchMatches();
  }
}

/// Controller filtrado por stage
@riverpod
class MatchesByStageController extends _$MatchesByStageController {
  @override
  Stream<List<Match>> build(String stage) {
    final repo = ref.watch(matchRepositoryProvider);
    return repo.watchMatchesByStage(stage);
  }
}

/// Provider para obtener un partido específico
@riverpod
Future<Match?> matchDetail(Ref ref, String matchId) {
  final repo = ref.watch(matchRepositoryProvider);
  return repo.getMatchById(matchId);
}
