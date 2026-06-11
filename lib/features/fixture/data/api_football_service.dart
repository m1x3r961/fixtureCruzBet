import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/config/env_config.dart';
import '../../../core/providers/supabase_provider.dart';
import 'match_repository.dart';
import '../domain/match_model.dart';

part 'api_football_service.g.dart';

/// Servicio que consume la API de API-Football y sincroniza los partidos
/// hacia la tabla `matches` en Supabase.
///
/// ESTRATEGIA: Sincronización una vez al día (guard de 23h en sync_log).
/// RECOMENDADO: Usar la Edge Function `supabase/functions/sync-matches/index.ts`
/// en vez de este servicio en cliente para producción.
class ApiFootballService {
  final http.Client _httpClient;
  final MatchRepository _matchRepo;

  static const String _baseUrl = 'https://v3.football.api-sports.io';

  ApiFootballService({
    required http.Client httpClient,
    required MatchRepository matchRepo,
  })  : _httpClient = httpClient,
        _matchRepo = matchRepo;

  Map<String, String> get _headers => {
        'x-apisports-key': EnvConfig.apiFootballKey,
        'Accept': 'application/json',
      };

  Future<List<Match>> fetchWorldCupMatches() async {
    final leagueId = EnvConfig.worldCupLeagueId;
    final season = EnvConfig.worldCupSeason;

    final uri = Uri.parse(
      '$_baseUrl/fixtures?league=$leagueId&season=$season',
    );

    final response = await _httpClient.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      throw Exception(
        '[ApiFootball] Error ${response.statusCode}: ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final fixtures = data['response'] as List<dynamic>;

    return fixtures.map((fixture) => _parseFixture(fixture)).toList();
  }

  Future<SyncResult> syncMatchesToSupabase() async {
    try {
      final matches = await fetchWorldCupMatches();
      await _matchRepo.upsertMatches(matches);
      return SyncResult.success(matchCount: matches.length);
    } catch (e) {
      return SyncResult.failure(error: e.toString());
    }
  }

  Match _parseFixture(Map<String, dynamic> json) {
    final fixture = json['fixture'] as Map<String, dynamic>;
    final teams = json['teams'] as Map<String, dynamic>;
    final goals = json['goals'] as Map<String, dynamic>?;
    final league = json['league'] as Map<String, dynamic>;

    final home = teams['home'] as Map<String, dynamic>;
    final away = teams['away'] as Map<String, dynamic>;

    final apiStatus =
        (fixture['status'] as Map)['short'] as String? ?? 'TBD';

    return Match(
      id: fixture['id'].toString(),
      homeTeam: home['name'] as String,
      awayTeam: away['name'] as String,
      homeScore: goals?['home'] as int?,
      awayScore: goals?['away'] as int?,
      matchTime: DateTime.parse(fixture['date'] as String),
      status: _mapApiStatus(apiStatus),
      stage: _mapRound(league['round'] as String? ?? ''),
      groupName: league['round'] as String?,
      apiFootballId: fixture['id'] as int?,
      homeFlag: home['logo'] as String?,
      awayFlag: away['logo'] as String?,
    );
  }

  String _mapApiStatus(String apiStatus) {
    return switch (apiStatus) {
      'NS' => 'scheduled',
      '1H' || '2H' || 'HT' || 'ET' || 'P' => 'live',
      'FT' || 'AET' || 'PEN' => 'finished',
      _ => 'scheduled',
    };
  }

  String _mapRound(String round) {
    final lower = round.toLowerCase();
    if (lower.contains('group')) return 'group';
    if (lower.contains('round of 16')) return 'round_of_16';
    if (lower.contains('quarter')) return 'quarter';
    if (lower.contains('semi')) return 'semi';
    if (lower.contains('final')) return 'final';
    return 'group';
  }
}

// ---------------------------------------------------------------------------
// Resultado de la sincronización
// ---------------------------------------------------------------------------
sealed class SyncResult {
  const SyncResult();
  const factory SyncResult.success({required int matchCount}) = SyncSuccess;
  const factory SyncResult.failure({required String error}) = SyncFailure;
}

final class SyncSuccess extends SyncResult {
  final int matchCount;
  const SyncSuccess({required this.matchCount});
}

final class SyncFailure extends SyncResult {
  final String error;
  const SyncFailure({required this.error});
}

// ---------------------------------------------------------------------------
// Provider del servicio
// ---------------------------------------------------------------------------
@riverpod
ApiFootballService apiFootballService(Ref ref) {
  return ApiFootballService(
    httpClient: http.Client(),
    matchRepo: ref.watch(matchRepositoryProvider),
  );
}

/// Controller que verifica si es necesario sincronizar antes de llamar a la API.
@riverpod
class MatchSyncController extends _$MatchSyncController {
  @override
  AsyncValue<SyncResult?> build() => const AsyncValue.data(null);

  Future<void> syncIfNeeded() async {
    final shouldSync = await _shouldSyncToday();
    if (!shouldSync) return;

    state = const AsyncValue.loading();
    try {
      final service = ref.read(apiFootballServiceProvider);
      final result = await service.syncMatchesToSupabase();
      if (result is SyncSuccess) await _recordSync();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> forceSync() async {
    state = const AsyncValue.loading();
    try {
      final service = ref.read(apiFootballServiceProvider);
      final result = await service.syncMatchesToSupabase();
      if (result is SyncSuccess) await _recordSync();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> _shouldSyncToday() async {
    try {
      final response = await ref
          .read(supabaseClientProvider)
          .from('sync_log')
          .select('synced_at')
          .eq('sync_type', 'api_football')
          .order('synced_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null) return true;
      final lastSync = DateTime.parse(response['synced_at'] as String);
      return DateTime.now().difference(lastSync).inHours >= 23;
    } catch (_) {
      return true;
    }
  }

  Future<void> _recordSync() async {
    await ref.read(supabaseClientProvider).from('sync_log').insert({
      'sync_type': 'api_football',
      'synced_at': DateTime.now().toIso8601String(),
    });
  }
}
