import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../fixture/presentation/fixture_controller.dart';
import '../domain/admin_models.dart';

class AdminUserDetailScreen extends ConsumerWidget {
  final UserSummary userSummary;

  const AdminUserDetailScreen({
    super.key,
    required this.userSummary,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          userSummary.profile.email ?? 'Detalle del Usuario',
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: const Color(0xFF3D3D3D),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.8),
            radius: 1.5,
            colors: [
              const Color(0xFF1A2630),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Resumen superior
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    child: const Icon(Icons.person, size: 30, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userSummary.profile.email ?? 'Anónimo',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rol: ${userSummary.profile.role.toUpperCase()}',
                          style: const TextStyle(color: Colors.white54),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        '${userSummary.totalPredictions}',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF00E5FF),
                        ),
                      ),
                      const Text(
                        'Predicciones',
                        style: TextStyle(fontSize: 12, color: Colors.white54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            const Text(
              'Predicciones Exactas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            if (userSummary.predictions.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text('Este usuario no ha hecho predicciones.', style: TextStyle(color: Colors.white54)),
                ),
              )
            else
              ...userSummary.predictions.map((pred) {
                return _PredictionDetailCard(
                  matchId: pred.matchId,
                  homeScore: pred.homeScore,
                  awayScore: pred.awayScore,
                  createdAt: pred.createdAt,
                );
              }).toList(),
          ],
        ),
      ),
    );
  }
}

class _PredictionDetailCard extends ConsumerWidget {
  final String matchId;
  final int homeScore;
  final int awayScore;
  final DateTime? createdAt;

  const _PredictionDetailCard({
    required this.matchId,
    required this.homeScore,
    required this.awayScore,
    this.createdAt,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchAsync = ref.watch(matchDetailProvider(matchId));

    return Card(
      color: Colors.black38,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: matchAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text('Error al cargar partido', style: TextStyle(color: Colors.red[300])),
          data: (match) {
            if (match == null) return const Text('Partido no encontrado');

            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      match.groupName ?? 'Fase de Grupos',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF00E5FF), fontWeight: FontWeight.bold),
                    ),
                    if (createdAt != null)
                      Text(
                        DateFormat('dd/MM HH:mm').format(createdAt!.toLocal()),
                        style: const TextStyle(fontSize: 10, color: Colors.white38),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    // Home
                    Expanded(
                      child: Column(
                        children: [
                          if (match.homeFlag != null)
                            Image.network(match.homeFlag!, width: 30, height: 30),
                          const SizedBox(height: 4),
                          Text(match.homeTeam, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    
                    // Score
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                      ),
                      child: Text(
                        '$homeScore - $awayScore',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                      ),
                    ),

                    // Away
                    Expanded(
                      child: Column(
                        children: [
                          if (match.awayFlag != null)
                            Image.network(match.awayFlag!, width: 30, height: 30),
                          const SizedBox(height: 4),
                          Text(match.awayTeam, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
