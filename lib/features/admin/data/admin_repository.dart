import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_provider.dart';
import '../../auth/domain/profile_model.dart';
import '../../predictions/data/prediction_repository.dart';
import '../domain/admin_models.dart';

part 'admin_repository.g.dart';

class AdminRepository {
  final SupabaseClient _client;
  final PredictionRepository _predictionRepo;

  AdminRepository(this._client, this._predictionRepo);

  Future<AdminDashboardData> getDashboardData() async {
    // 1. Obtener todos los perfiles
    final profilesResponse = await _client.from('profiles').select();
    final profiles = profilesResponse.map((p) => Profile.fromJson(p)).toList();

    // 2. Obtener TODAS las predicciones
    final allPredictions = await _predictionRepo.getAllPredictions();

    // 3. Agrupar predicciones por usuario
    final Map<String, UserSummary> summaryMap = {};
    
    for (final profile in profiles) {
      summaryMap[profile.id] = UserSummary(
        profile: profile,
        totalPredictions: 0,
        predictions: [],
      );
    }

    for (final pred in allPredictions) {
      if (summaryMap.containsKey(pred.userId)) {
        final current = summaryMap[pred.userId]!;
        summaryMap[pred.userId] = current.copyWith(
          totalPredictions: current.totalPredictions + 1,
          predictions: [...current.predictions, pred],
        );
      }
    }

    final leaderboard = summaryMap.values.toList()
      ..sort((a, b) => b.totalPredictions.compareTo(a.totalPredictions));

    return AdminDashboardData(
      totalUsers: profiles.length,
      totalPredictions: allPredictions.length,
      leaderboard: leaderboard,
    );
  }
}

@riverpod
AdminRepository adminRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  final predictionRepo = ref.watch(predictionRepositoryProvider);
  return AdminRepository(client, predictionRepo);
}

@riverpod
Future<AdminDashboardData> adminDashboardData(Ref ref) {
  final repo = ref.watch(adminRepositoryProvider);
  return repo.getDashboardData();
}
