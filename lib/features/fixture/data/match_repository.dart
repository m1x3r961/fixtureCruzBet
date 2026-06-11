import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_provider.dart';
import '../domain/match_model.dart';

part 'match_repository.g.dart';

// ---------------------------------------------------------------------------
// Abstracción (interfaz de dominio)
// ---------------------------------------------------------------------------
abstract class IMatchRepository {
  Stream<List<Match>> watchMatches();
  Stream<List<Match>> watchMatchesByStage(String stage);
  Future<Match?> getMatchById(String id);
}

// ---------------------------------------------------------------------------
// Implementación con Supabase
// ---------------------------------------------------------------------------
class MatchRepository implements IMatchRepository {
  final SupabaseClient _client;

  MatchRepository(this._client);

  /// Stream en tiempo real de partidos usando Supabase Realtime.
  /// Se actualiza automáticamente con INSERT/UPDATE/DELETE en la tabla `matches`.
  ///
  /// REQUISITO: Habilitar `matches` en Database → Replication en Supabase.
  @override
  Stream<List<Match>> watchMatches() {
    return _client
        .from('matches')
        .stream(primaryKey: ['id'])
        .order('match_time', ascending: true)
        .map(
          (rows) => rows.map((row) => Match.fromJson(row)).toList(),
        )
        .handleError((error) {
          // ignore: avoid_print
          print('[MatchRepository] Error en stream: $error');
          return <Match>[];
        });
  }

  @override
  Stream<List<Match>> watchMatchesByStage(String stage) {
    return _client
        .from('matches')
        .stream(primaryKey: ['id'])
        .eq('stage', stage)
        .order('match_time', ascending: true)
        .map((rows) => rows.map((row) => Match.fromJson(row)).toList());
  }

  @override
  Future<Match?> getMatchById(String id) async {
    final response = await _client
        .from('matches')
        .select()
        .eq('id', id)
        .maybeSingle();

    if (response == null) return null;
    return Match.fromJson(response);
  }

  Future<void> updateScore({
    required String matchId,
    required int homeScore,
    required int awayScore,
    String? status,
  }) async {
    await _client.from('matches').update({
      'home_score': homeScore,
      'away_score': awayScore,
      if (status != null) 'status': status,
    }).eq('id', matchId);
  }

  Future<void> upsertMatches(List<Match> matches) async {
    final rows = matches
        .map((m) => {
              'home_team': m.homeTeam,
              'away_team': m.awayTeam,
              'home_score': m.homeScore,
              'away_score': m.awayScore,
              'match_time': m.matchTime.toIso8601String(),
              'status': m.status,
              'stage': m.stage,
              'group_name': m.groupName,
              'api_football_id': m.apiFootballId,
            })
        .toList();

    await _client.from('matches').upsert(rows, onConflict: 'api_football_id');
  }
}

// ---------------------------------------------------------------------------
// Provider del repositorio
// ---------------------------------------------------------------------------
@riverpod
MatchRepository matchRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return MatchRepository(client);
}
