import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/prediction_repository.dart';
import '../domain/prediction_model.dart';
import '../../../core/providers/supabase_provider.dart';

part 'prediction_controller.g.dart';

// ---------------------------------------------------------------------------
// Estado de la UI de predicción
// ---------------------------------------------------------------------------
enum PredictionStatus { idle, loading, saved, error }

// ---------------------------------------------------------------------------
// Controller para GUARDAR predicciones
// ---------------------------------------------------------------------------
@riverpod
class PredictionController extends _$PredictionController {
  @override
  AsyncValue<PredictionStatus> build() =>
      const AsyncValue.data(PredictionStatus.idle);

  Future<void> submitPrediction({
    required String matchId,
    required int homeScore,
    required int awayScore,
    String? existingPredictionId,
  }) async {
    state = const AsyncValue.loading();

    try {
      final repo = ref.read(predictionRepositoryProvider);
      final input = PredictionInput(
        matchId: matchId,
        homeScore: homeScore,
        awayScore: awayScore,
      );

      if (existingPredictionId != null) {
        await repo.updatePrediction(existingPredictionId, input);
      } else {
        await repo.savePrediction(input);
      }

      state = const AsyncValue.data(PredictionStatus.saved);

      ref.invalidate(userPredictionsProvider);
      ref.invalidate(predictionForMatchProvider(matchId));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> deletePrediction(String predictionId, String matchId) async {
    state = const AsyncValue.loading();
    try {
      final repo = ref.read(predictionRepositoryProvider);
      await repo.deletePrediction(predictionId);
      
      state = const AsyncValue.data(PredictionStatus.saved);
      ref.invalidate(userPredictionsProvider);
      ref.invalidate(predictionForMatchProvider(matchId));
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  void reset() => state = const AsyncValue.data(PredictionStatus.idle);
}

// ---------------------------------------------------------------------------
// Providers de lectura
// ---------------------------------------------------------------------------
@riverpod
Future<List<Prediction>> userPredictions(Ref ref) {
  // Invalida la caché automáticamente cuando el estado de autenticación cambia
  ref.watch(authStateStreamProvider);
  
  final repo = ref.watch(predictionRepositoryProvider);
  return repo.getUserPredictions();
}

@riverpod
Future<Prediction?> predictionForMatch(Ref ref, String matchId) {
  // Invalida la caché automáticamente cuando el estado de autenticación cambia
  ref.watch(authStateStreamProvider);
  
  final repo = ref.watch(predictionRepositoryProvider);
  return repo.getPredictionForMatch(matchId);
}
