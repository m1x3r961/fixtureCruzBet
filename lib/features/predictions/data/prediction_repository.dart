import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_provider.dart';
import '../domain/prediction_model.dart';

part 'prediction_repository.g.dart';

// ---------------------------------------------------------------------------
// Abstracción
// ---------------------------------------------------------------------------
abstract class IPredictionRepository {
  Future<List<Prediction>> getUserPredictions();
  Future<List<Prediction>> getAllPredictions();
  Future<Prediction?> getPredictionForMatch(String matchId);
  Future<void> savePrediction(PredictionInput input);
  Future<void> updatePrediction(String predictionId, PredictionInput input);
  Future<void> deletePrediction(String predictionId);
}

// ---------------------------------------------------------------------------
// Implementación con Supabase — RLS activo
// ---------------------------------------------------------------------------
class PredictionRepository implements IPredictionRepository {
  final SupabaseClient _client;

  PredictionRepository(this._client);

  User get _requireUser {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw StateError('Se requiere autenticación para acceder a predicciones.');
    }
    return user;
  }

  @override
  Future<List<Prediction>> getUserPredictions() async {
    final user = _requireUser;

    final response = await _client
        .from('predictions')
        .select()
        .eq('user_id', user.id)
        .order('created_at', ascending: false);

    return response.map((row) => Prediction.fromJson(row)).toList();
  }

  @override
  Future<List<Prediction>> getAllPredictions() async {
    _requireUser; // Solo requiere estar autenticado (el RLS bloquea si no es admin)

    final response = await _client
        .from('predictions')
        .select()
        .order('created_at', ascending: false);

    return response.map((row) => Prediction.fromJson(row)).toList();
  }

  @override
  Future<Prediction?> getPredictionForMatch(String matchId) async {
    final user = _requireUser;

    final response = await _client
        .from('predictions')
        .select()
        .eq('match_id', matchId)
        .eq('user_id', user.id)
        .maybeSingle();

    if (response == null) return null;
    return Prediction.fromJson(response);
  }

  @override
  Future<void> savePrediction(PredictionInput input) async {
    final user = _requireUser;

    await _client.from('predictions').insert(
          input.toSupabaseJson(user.id),
        );
  }

  @override
  Future<void> updatePrediction(
    String predictionId,
    PredictionInput input,
  ) async {
    _requireUser;

    await _client.from('predictions').update({
      'home_score': input.homeScore,
      'away_score': input.awayScore,
    }).eq('id', predictionId);
  }

  @override
  Future<void> deletePrediction(String predictionId) async {
    _requireUser;
    await _client.from('predictions').delete().eq('id', predictionId);
  }

  Future<bool> hasPredictionForMatch(String matchId) async {
    final prediction = await getPredictionForMatch(matchId);
    return prediction != null;
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------
@riverpod
PredictionRepository predictionRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return PredictionRepository(client);
}
