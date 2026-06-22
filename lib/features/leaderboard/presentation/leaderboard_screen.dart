import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/leaderboard_repository.dart';
import '../domain/leaderboard_model.dart';
import '../../../core/providers/supabase_provider.dart';

/// Pantalla pública de ranking de puntos del Mundial CruzBet.
/// Accesible para todos los usuarios autenticados.
class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);
    final currentUser = ref.watch(supabaseClientProvider).auth.currentUser;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0A1628),
              Color(0xFF0D1F3C),
              Color(0xFF0A1628),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──────────────────────────────────────────────────
              _LeaderboardHeader(),

              // ── Content ─────────────────────────────────────────────────
              Expanded(
                child: leaderboardAsync.when(
                  loading: () => const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  error: (e, _) => Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            color: Color(0xFFFF3D57), size: 48),
                        const SizedBox(height: 12),
                        Text(
                          'Error al cargar el ranking\n$e',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white54),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => ref.invalidate(leaderboardProvider),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  ),
                  data: (entries) {
                    if (entries.isEmpty) {
                      return const _EmptyLeaderboard();
                    }

                    return RefreshIndicator(
                      color: const Color(0xFFFFD700),
                      backgroundColor: const Color(0xFF1A2E4A),
                      onRefresh: () async {
                        ref.invalidate(leaderboardProvider);
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 100),
                        itemCount: entries.length,
                        itemBuilder: (context, index) {
                          final entry = entries[index];
                          final isCurrentUser =
                              entry.userId == currentUser?.id;
                          return _LeaderboardRow(
                            entry: entry,
                            rank: index + 1,
                            isCurrentUser: isCurrentUser,
                          )
                              .animate()
                              .fadeIn(
                                duration: 400.ms,
                                delay: Duration(milliseconds: index * 40),
                              )
                              .slideX(
                                begin: 0.08,
                                curve: Curves.easeOutQuad,
                              );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Header con podio para top 3
// ─────────────────────────────────────────────────────────────────────────────
class _LeaderboardHeader extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardAsync = ref.watch(leaderboardProvider);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A2E4A),
            Color(0xFF0F1E35),
          ],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Título + botón volver
          Row(
            children: [
              // ── Botón volver ────────────────────────────────────────
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.arrow_back_ios_new_rounded,
                          color: Colors.white70, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Volver',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // ── Ícono trofeo ─────────────────────────────────────────
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFFD700).withValues(alpha: 0.4),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Icon(Icons.emoji_events,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),

              // ── Título ───────────────────────────────────────────────
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'RANKING MUNDIAL',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    'CruzBet 2026',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFFFD700),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ],
          ).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),

          const SizedBox(height: 20),

          // Leyenda de puntos
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _PointBadge(
                  points: 3,
                  label: 'Exacto',
                  icon: Icons.star,
                  color: Color(0xFFFFD700),
                ),
                _DividerDot(),
                _PointBadge(
                  points: 1,
                  label: 'Acierto',
                  icon: Icons.check_circle,
                  color: Color(0xFF22C55E),
                ),
                _DividerDot(),
                _PointBadge(
                  points: 0,
                  label: 'Fallo',
                  icon: Icons.cancel,
                  color: Color(0xFFFF3D57),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 500.ms, delay: 150.ms),

          // Podio top 3
          leaderboardAsync.maybeWhen(
            data: (entries) {
              if (entries.length >= 3) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: _Podium(entries: entries.take(3).toList()),
                );
              }
              return const SizedBox.shrink();
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Podio top 3
// ─────────────────────────────────────────────────────────────────────────────
class _Podium extends StatelessWidget {
  final List<LeaderboardEntry> entries;
  const _Podium({required this.entries});

  @override
  Widget build(BuildContext context) {
    // Orden visual: 2do, 1ro, 3ro
    final first = entries[0];
    final second = entries[1];
    final third = entries[2];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _PodiumSlot(entry: second, rank: 2, height: 72)
            .animate()
            .fadeIn(duration: 500.ms, delay: 200.ms)
            .slideY(begin: 0.3),
        const SizedBox(width: 12),
        _PodiumSlot(entry: first, rank: 1, height: 96)
            .animate()
            .fadeIn(duration: 500.ms, delay: 100.ms)
            .slideY(begin: 0.3),
        const SizedBox(width: 12),
        _PodiumSlot(entry: third, rank: 3, height: 56)
            .animate()
            .fadeIn(duration: 500.ms, delay: 300.ms)
            .slideY(begin: 0.3),
      ],
    );
  }
}

class _PodiumSlot extends StatelessWidget {
  final LeaderboardEntry entry;
  final int rank;
  final double height;

  const _PodiumSlot({
    required this.entry,
    required this.rank,
    required this.height,
  });

  Color get _rankColor {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      default:
        return const Color(0xFFCD7F32);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar con corona
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: rank == 1 ? 64 : 52,
              height: rank == 1 ? 64 : 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    _rankColor.withValues(alpha: 0.3),
                    _rankColor.withValues(alpha: 0.1),
                  ],
                ),
                border: Border.all(color: _rankColor, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: _rankColor.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  entry.displayName.isNotEmpty
                      ? entry.displayName[0].toUpperCase()
                      : '?',
                  style: TextStyle(
                    fontSize: rank == 1 ? 26 : 20,
                    fontWeight: FontWeight.w900,
                    color: _rankColor,
                  ),
                ),
              ),
            ),
            if (rank == 1)
              Positioned(
                top: -14,
                left: 0,
                right: 0,
                child: const Icon(
                  Icons.emoji_events,
                  color: Color(0xFFFFD700),
                  size: 22,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          entry.displayName,
          style: TextStyle(
            fontSize: rank == 1 ? 13 : 11,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${entry.totalPoints} pts',
          style: TextStyle(
            fontSize: rank == 1 ? 16 : 13,
            fontWeight: FontWeight.w900,
            color: _rankColor,
          ),
        ),
        const SizedBox(height: 6),
        // Base del podio
        Container(
          width: rank == 1 ? 90 : 72,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                _rankColor.withValues(alpha: 0.25),
                _rankColor.withValues(alpha: 0.08),
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            border: Border.all(
              color: _rankColor.withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: TextStyle(
                color: _rankColor,
                fontWeight: FontWeight.w900,
                fontSize: rank == 1 ? 22 : 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Fila de cada participante (posición 4 en adelante)
// ─────────────────────────────────────────────────────────────────────────────
class _LeaderboardRow extends StatefulWidget {
  final LeaderboardEntry entry;
  final int rank;
  final bool isCurrentUser;

  const _LeaderboardRow({
    required this.entry,
    required this.rank,
    required this.isCurrentUser,
  });

  @override
  State<_LeaderboardRow> createState() => _LeaderboardRowState();
}

class _LeaderboardRowState extends State<_LeaderboardRow> {
  bool _expanded = false;

  Color get _rankColor {
    switch (widget.rank) {
      case 1:
        return const Color(0xFFFFD700);
      case 2:
        return const Color(0xFFC0C0C0);
      case 3:
        return const Color(0xFFCD7F32);
      default:
        return const Color(0xFF00E5FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;

    return GestureDetector(
      onTap: () => setState(() => _expanded = !_expanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: widget.isCurrentUser
                ? [
                    const Color(0xFFFFD700).withValues(alpha: 0.15),
                    const Color(0xFFFFD700).withValues(alpha: 0.05),
                  ]
                : [
                    const Color(0xFF1A2840),
                    const Color(0xFF121D2E),
                  ],
          ),
          border: Border.all(
            color: widget.isCurrentUser
                ? const Color(0xFFFFD700).withValues(alpha: 0.5)
                : _rankColor.withValues(alpha: widget.rank <= 3 ? 0.3 : 0.08),
            width: widget.isCurrentUser || widget.rank <= 3 ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
            if (widget.isCurrentUser)
              BoxShadow(
                color: const Color(0xFFFFD700).withValues(alpha: 0.1),
                blurRadius: 16,
                spreadRadius: 1,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                children: [
                  // ── Fila principal ──────────────────────────────────────
                  Row(
                    children: [
                      // Posición
                      SizedBox(
                        width: 36,
                        child: widget.rank <= 3
                            ? Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _rankColor.withValues(alpha: 0.2),
                                  border:
                                      Border.all(color: _rankColor, width: 1.5),
                                ),
                                child: Center(
                                  child: Text(
                                    '${widget.rank}',
                                    style: TextStyle(
                                      color: _rankColor,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              )
                            : Text(
                                '${widget.rank}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white38,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),

                      // Avatar
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              _rankColor.withValues(alpha: 0.3),
                              _rankColor.withValues(alpha: 0.1),
                            ],
                          ),
                          border: Border.all(
                              color: _rankColor.withValues(alpha: 0.5)),
                        ),
                        child: Center(
                          child: Text(
                            entry.displayName.isNotEmpty
                                ? entry.displayName[0].toUpperCase()
                                : '?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: _rankColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Nombre
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    entry.displayName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (widget.isCurrentUser) ...[
                                  const SizedBox(width: 6),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFD700)
                                          .withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: const Color(0xFFFFD700)
                                              .withValues(alpha: 0.5)),
                                    ),
                                    child: const Text(
                                      'TÚ',
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFFFFD700),
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            Text(
                              '${entry.totalPredictions} predicciones jugadas',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white38,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Puntos
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${entry.totalPoints}',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: widget.rank == 1
                                  ? const Color(0xFFFFD700)
                                  : Colors.white,
                              height: 1,
                            ),
                          ),
                          const Text(
                            'PTS',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.white38,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),

                      // Indicador expandir
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: AnimatedRotation(
                          turns: _expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 250),
                          child: const Icon(
                            Icons.keyboard_arrow_down,
                            size: 20,
                            color: Colors.white38,
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ── Detalles expandibles ────────────────────────────────
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: _expanded
                        ? Padding(
                            padding: const EdgeInsets.only(top: 14),
                            child: Column(
                              children: [
                                const Divider(color: Colors.white10),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _StatChip(
                                      icon: Icons.star,
                                      value: entry.exactResults,
                                      label: 'Exactos',
                                      color: const Color(0xFFFFD700),
                                      points: '× 3 pts',
                                    ),
                                    _StatChip(
                                      icon: Icons.check_circle,
                                      value: entry.correctOutcomes,
                                      label: 'Aciertos',
                                      color: const Color(0xFF22C55E),
                                      points: '× 1 pt',
                                    ),
                                    _StatChip(
                                      icon: Icons.cancel,
                                      value: entry.misses,
                                      label: 'Fallos',
                                      color: const Color(0xFFFF3D57),
                                      points: '× 0 pts',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Chips de estadísticas detalladas
// ─────────────────────────────────────────────────────────────────────────────
class _StatChip extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final Color color;
  final String points;

  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(
            '$value',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          Text(
            points,
            style: TextStyle(
              color: color.withValues(alpha: 0.7),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Badge de puntos en la leyenda del header
// ─────────────────────────────────────────────────────────────────────────────
class _PointBadge extends StatelessWidget {
  final int points;
  final String label;
  final IconData icon;
  final Color color;

  const _PointBadge({
    required this.points,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(
          '$points ${points == 1 ? 'pt' : 'pts'}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w900,
            fontSize: 15,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white54, fontSize: 11),
        ),
      ],
    );
  }
}

class _DividerDot extends StatelessWidget {
  const _DividerDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 4,
      height: 4,
      decoration: const BoxDecoration(
        color: Colors.white12,
        shape: BoxShape.circle,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Estado vacío
// ─────────────────────────────────────────────────────────────────────────────
class _EmptyLeaderboard extends StatelessWidget {
  const _EmptyLeaderboard();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.sports_soccer,
            size: 64,
            color: Colors.white12,
          ),
          const SizedBox(height: 16),
          const Text(
            'El ranking estará disponible\ncuando terminen los primeros partidos.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              fontSize: 16,
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms);
  }
}
