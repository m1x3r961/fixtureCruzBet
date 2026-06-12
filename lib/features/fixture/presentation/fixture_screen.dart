import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/router/app_router.dart';
import '../../../core/widgets/common_widgets.dart';
import '../../auth/presentation/auth_controller.dart';
import '../domain/match_model.dart';
import 'fixture_controller.dart';
import 'widgets/score_input_dialog.dart';
import '../../predictions/presentation/prediction_controller.dart';
import '../../predictions/domain/prediction_model.dart';
import '../../auth/data/profile_repository.dart';

/// Pantalla principal del Fixture del Mundial.
/// Muestra todos los partidos en tiempo real via Supabase Realtime con diseño premium.
class FixtureScreen extends ConsumerStatefulWidget {
  const FixtureScreen({super.key});

  @override
  ConsumerState<FixtureScreen> createState() => _FixtureScreenState();
}

class _FixtureScreenState extends ConsumerState<FixtureScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const _tabs = [
    (label: 'Todos', stage: null),
    (label: 'Grupos', stage: 'group'),
    (label: 'Octavos', stage: 'round_of_16'),
    (label: 'Cuartos', stage: 'quarter'),
    (label: 'Semis', stage: 'semi'),
    (label: 'Final', stage: 'final'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 90,
        backgroundColor: const Color(0xFF3D3D3D),
        elevation: 4,
        shadowColor: Colors.black.withValues(alpha: 0.5),
        title: Image.asset(
          'assets/images/logo_app.png',
          height: 150, // Logo más refinado
          fit: BoxFit.contain,
        ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, curve: Curves.easeOutQuad),
        centerTitle: true,
        actions: [
          Consumer(
            builder: (context, ref, child) {
              final profileAsync = ref.watch(currentProfileProvider);
              return profileAsync.maybeWhen(
                data: (profile) {
                  if (profile != null && profile.isAdmin) {
                    return IconButton(
                      icon: const Icon(Icons.admin_panel_settings),
                      tooltip: 'Admin Dashboard',
                      color: const Color(0xFF00E5FF),
                      onPressed: () => context.push(AppRoutes.admin),
                    );
                  }
                  return const SizedBox.shrink();
                },
                orElse: () => const SizedBox.shrink(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined),
            tooltip: 'Cerrar sesión',
            onPressed: () =>
                ref.read(authControllerProvider.notifier).signOut(),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          indicatorPadding: const EdgeInsets.symmetric(horizontal: -10, vertical: 8),
          labelColor: Theme.of(context).colorScheme.primary,
          unselectedLabelColor: Colors.white54,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
          splashBorderRadius: BorderRadius.circular(20),
          dividerColor: Colors.transparent,
          tabs: _tabs.map((t) => Tab(text: t.label)).toList(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.6),
            radius: 1.5,
            colors: [
              const Color(0xFF0F1A24), // Un tono un poco más brillante en el centro
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: TabBarView(
          controller: _tabController,
          children: _tabs.map((tab) {
            return _MatchList(stage: tab.stage);
          }).toList(),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Lista de partidos filtrable por stage
// ---------------------------------------------------------------------------
class _MatchList extends ConsumerStatefulWidget {
  final String? stage;
  const _MatchList({this.stage});

  @override
  ConsumerState<_MatchList> createState() => _MatchListState();
}

class _MatchListState extends ConsumerState<_MatchList> {
  String? _selectedGroup;

  @override
  Widget build(BuildContext context) {
    final matchesAsync = widget.stage == null
        ? ref.watch(fixtureControllerProvider)
        : ref.watch(matchesByStageControllerProvider(widget.stage!));

    return matchesAsync.when(
      loading: () => const MatchListShimmer(),
      error: (e, _) => ErrorRetryWidget(
        message: 'No se pudieron cargar los partidos.\n$e',
        onRetry: () => widget.stage == null
            ? ref.invalidate(fixtureControllerProvider)
            : ref.invalidate(matchesByStageControllerProvider(widget.stage!)),
      ),
      data: (matches) {
        if (matches.isEmpty) {
          return const Center(
            child: Text(
              'No hay partidos en esta etapa aún.',
              style: TextStyle(color: Colors.white38),
            ),
          );
        }

        List<Match> displayMatches = matches;
        Widget? filterWidget;

        if (widget.stage == 'group') {
          final groups = matches
              .map((m) => m.groupName)
              .where((g) => g != null)
              .cast<String>()
              .toSet()
              .toList()
            ..sort();

          if (_selectedGroup != null) {
            displayMatches =
                matches.where((m) => m.groupName == _selectedGroup).toList();
          }

          filterWidget = SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: const Text('Todos'),
                    selected: _selectedGroup == null,
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedGroup = null);
                    },
                    selectedColor: Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.2),
                    side: BorderSide(
                      color: _selectedGroup == null
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white12,
                    ),
                    backgroundColor: Colors.transparent,
                    labelStyle: TextStyle(
                      color: _selectedGroup == null
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...groups.map((g) {
                  final isSelected = _selectedGroup == g;
                  // Extraer solo la letra del grupo para que no ocupe tanto espacio
                  final labelText = g.toUpperCase().replaceAll('GRUPO ', 'G-');
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(labelText),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedGroup = selected ? g : null);
                      },
                      selectedColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.2),
                      side: BorderSide(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white12,
                      ),
                      backgroundColor: Colors.transparent,
                      labelStyle: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white70,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            widget.stage == null
                ? ref.invalidate(fixtureControllerProvider)
                : ref.invalidate(matchesByStageControllerProvider(widget.stage!));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (filterWidget != null) filterWidget,
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 8, bottom: 100),
                  itemCount: displayMatches.length,
                  itemBuilder: (context, index) {
                    return _MatchCard(match: displayMatches[index])
                        .animate()
                        .fadeIn(
                            duration: 400.ms,
                            delay: Duration(milliseconds: index * 20))
                        .slideY(begin: 0.05, curve: Curves.easeOutQuad);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Card de partido individual con predicciones inline y Glassmorphism
// ---------------------------------------------------------------------------
class _MatchCard extends ConsumerStatefulWidget {
  final Match match;
  const _MatchCard({required this.match});

  @override
  ConsumerState<_MatchCard> createState() => _MatchCardState();
}

class _MatchCardState extends ConsumerState<_MatchCard> {
  bool _isHovered = false;

  void _showPredictionDialog(BuildContext context, WidgetRef ref, dynamic existingPrediction) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => ScoreInputDialog(
        match: widget.match,
        existingPrediction: existingPrediction,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM · HH:mm', 'es');
    final predictionAsync = ref.watch(predictionForMatchProvider(widget.match.id));
    final prediction = predictionAsync.valueOrNull;
    final hasPrediction = prediction != null;
    final isLocked = !widget.match.isScheduled || widget.match.matchTime.isBefore(DateTime.now());

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        transform: Matrix4.identity()..scale(_isHovered ? 1.02 : 1.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              hasPrediction
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
                  : const Color(0xFF1A2630),
              hasPrediction
                  ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.02)
                  : const Color(0xFF121C24),
            ],
          ),
          border: Border.all(
            color: hasPrediction
                ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.05),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
            if (hasPrediction && _isHovered)
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                blurRadius: 20,
                spreadRadius: 2,
              ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: isLocked
                  ? null
                  : () => _showPredictionDialog(context, ref, prediction),
              splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    // --- Encabezado: stage / grupo y status ---
                    Row(
                      children: [
                        if (widget.match.groupName != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white10),
                            ),
                            child: Text(
                              widget.match.groupName!.toUpperCase(),
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF00E5FF),
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                        const Spacer(),
                        MatchStatusBadge(status: widget.match.status),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // --- Equipos y marcador ---
                    Row(
                      children: [
                        // Equipo local
                        Expanded(
                          child: Column(
                            children: [
                              _TeamFlag(flag: widget.match.homeFlag, team: widget.match.homeTeam),
                              const SizedBox(height: 10),
                              Text(
                                widget.match.homeTeam,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),

                        // Marcador / Predicción Central
                        if (!hasPrediction && isLocked)
                          if (widget.match.homeScore != null && widget.match.awayScore != null)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: widget.match.isLive
                                      ? [const Color(0x33FF3D57), const Color(0x11FF3D57)]
                                      : [const Color(0x3300E5FF), const Color(0x1100E5FF)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: widget.match.isLive ? const Color(0x55FF3D57) : const Color(0x5500E5FF),
                                ),
                              ),
                              child: Text(
                                widget.match.scoreDisplay,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: widget.match.isLive
                                      ? const Color(0xFFFF3D57)
                                      : Colors.white,
                                ),
                              ),
                            )
                          else
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                _ScoreBox(score: null, hasPrediction: false),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Text('VS', style: TextStyle(color: Colors.white24, fontWeight: FontWeight.bold, fontSize: 16)),
                                ),
                                _ScoreBox(score: null, hasPrediction: false),
                              ],
                            )
                        else
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _ScoreBox(score: prediction?.homeScore, hasPrediction: hasPrediction),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12),
                                    child: Text('VS', style: TextStyle(color: Colors.white24, fontWeight: FontWeight.bold, fontSize: 16)),
                                  ),
                                  _ScoreBox(score: prediction?.awayScore, hasPrediction: hasPrediction),
                                ],
                              ),
                              if (hasPrediction && (widget.match.homeScore != null && widget.match.awayScore != null)) ...[
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black38,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: Colors.white12),
                                  ),
                                  child: Text(
                                    'Resultado: ${widget.match.homeScore} - ${widget.match.awayScore}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                _PredictionResultIndicator(
                                  prediction: prediction,
                                  match: widget.match,
                                ),
                              ],
                            ],
                          ),

                        // Equipo visitante
                        Expanded(
                          child: Column(
                            children: [
                              _TeamFlag(flag: widget.match.awayFlag, team: widget.match.awayTeam),
                              const SizedBox(height: 10),
                              Text(
                                widget.match.awayTeam,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // --- Footer: Fecha y Badge ---
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (widget.match.isScheduled)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black38,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.schedule, size: 14, color: Color(0xFF00E5FF)),
                                const SizedBox(width: 6),
                                Text(
                                  dateFormat.format(widget.match.matchTime.toLocal()),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          const SizedBox(), // Spacer
                        
                        if (prediction != null)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, size: 14, color: Color(0xFF22C55E)),
                                const SizedBox(width: 6),
                                const Text(
                                  'Guardada',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF22C55E),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (!isLocked) ...[
                                  const SizedBox(width: 8),
                                  InkWell(
                                    onTap: () {
                                      ref
                                          .read(predictionControllerProvider.notifier)
                                          .deletePrediction(prediction.id, widget.match.id);
                                    },
                                    borderRadius: BorderRadius.circular(12),
                                    child: const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Cuadro pequeño para mostrar un score con estilo premium
// ---------------------------------------------------------------------------
class _ScoreBox extends StatelessWidget {
  final int? score;
  final bool hasPrediction;
  const _ScoreBox({this.score, this.hasPrediction = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 52,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: hasPrediction
              ? [const Color(0xFF1A2E20), const Color(0xFF101C14)]
              : [const Color(0xFF1C2A36), const Color(0xFF151E27)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasPrediction ? Theme.of(context).colorScheme.primary : Colors.white12,
          width: hasPrediction ? 2 : 1,
        ),
        boxShadow: hasPrediction ? [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 8,
            spreadRadius: 1,
          )
        ] : [],
      ),
      child: Center(
        child: Text(
          score?.toString() ?? '-',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: hasPrediction ? Colors.white : Colors.white38,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Widget de bandera/logo del equipo
// ---------------------------------------------------------------------------
class _TeamFlag extends StatelessWidget {
  final String? flag;
  final String team;
  const _TeamFlag({this.flag, required this.team});

  @override
  Widget build(BuildContext context) {
    if (flag != null) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipOval(
          child: Image.network(
            flag!,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _flagFallback(),
          ),
        ),
      );
    }
    return _flagFallback();
  }

  Widget _flagFallback() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFF1C2A36),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white12),
      ),
      child: Center(
        child: Text(
          team.isNotEmpty ? team[0] : '?',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: Colors.white70),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Indicador visual de si acertó la predicción o no
// ---------------------------------------------------------------------------
class _PredictionResultIndicator extends StatelessWidget {
  final Prediction prediction;
  final Match match;

  const _PredictionResultIndicator({
    required this.prediction,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    if (match.homeScore == null || match.awayScore == null) {
      return const SizedBox.shrink();
    }

    final predHome = prediction.homeScore;
    final predAway = prediction.awayScore;
    final realHome = match.homeScore!;
    final realAway = match.awayScore!;

    bool isExactMatch = predHome == realHome && predAway == realAway;

    int predDiff = predHome - predAway;
    int realDiff = realHome - realAway;

    bool isCorrectOutcome = false;
    if (predDiff > 0 && realDiff > 0) {
      isCorrectOutcome = true;
    } else if (predDiff < 0 && realDiff < 0) {
      isCorrectOutcome = true;
    } else if (predDiff == 0 && realDiff == 0) {
      isCorrectOutcome = true;
    }

    if (isExactMatch) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.star, color: Color(0xFFFFD700), size: 14),
          SizedBox(width: 4),
          Text('¡Resultado Exacto!', style: TextStyle(color: Color(0xFFFFD700), fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      );
    } else if (isCorrectOutcome) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.check_circle, color: Color(0xFF22C55E), size: 14),
          SizedBox(width: 4),
          Text('¡Acierto!', style: TextStyle(color: Color(0xFF22C55E), fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.cancel, color: Color(0xFFFF3D57), size: 14),
          SizedBox(width: 4),
          Text('Fallaste', style: TextStyle(color: Color(0xFFFF3D57), fontSize: 11, fontWeight: FontWeight.bold)),
        ],
      );
    }
  }
}
