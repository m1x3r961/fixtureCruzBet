import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/app_router.dart';
import '../../../core/widgets/common_widgets.dart';
import '../data/admin_repository.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(adminDashboardDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF3D3D3D),
        elevation: 0,
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
        child: dataAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e', style: const TextStyle(color: Colors.redAccent))),
          data: (data) {
            return RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(adminDashboardDataProvider);
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Métricas Principales
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          title: 'Total Usuarios',
                          value: data.totalUsers.toString(),
                          icon: Icons.people_alt,
                          color: Colors.blueAccent,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _StatCard(
                          title: 'Predicciones',
                          value: data.totalPredictions.toString(),
                          icon: Icons.sports_soccer,
                          color: const Color(0xFF22C55E),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Título de la tabla
                  const Text(
                    'Leaderboard',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Tabla de posiciones
                  if (data.leaderboard.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('Aún no hay predicciones.', style: TextStyle(color: Colors.white54)),
                      ),
                    )
                  else
                    ...data.leaderboard.asMap().entries.map((entry) {
                      final index = entry.key;
                      final userSummary = entry.value;

                      return Card(
                        color: Colors.black26,
                        margin: const EdgeInsets.only(bottom: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.white.withOpacity(0.05)),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: index == 0
                                ? const Color(0xFFFFD700)
                                : index == 1
                                    ? const Color(0xFFC0C0C0)
                                    : index == 2
                                        ? const Color(0xFFCD7F32)
                                        : Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                color: index < 3 ? Colors.black87 : Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            userSummary.profile.email ?? 'Usuario Anónimo',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('Rol: ${userSummary.profile.role.toUpperCase()}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${userSummary.totalPredictions}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF00E5FF),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white38),
                            ],
                          ),
                          onTap: () {
                            // Navegar al detalle del usuario pasando su ID como extra o en la ruta
                            context.push(
                              '${AppRoutes.admin}/user/${userSummary.profile.id}',
                              extra: userSummary,
                            );
                          },
                        ),
                      );
                    }).toList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white54,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
