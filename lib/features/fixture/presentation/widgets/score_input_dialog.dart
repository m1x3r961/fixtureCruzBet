import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../predictions/domain/prediction_model.dart';
import '../../../predictions/presentation/prediction_controller.dart';
import '../../domain/match_model.dart';

class ScoreInputDialog extends ConsumerStatefulWidget {
  final Match match;
  final Prediction? existingPrediction;

  const ScoreInputDialog({
    super.key,
    required this.match,
    this.existingPrediction,
  });

  @override
  ConsumerState<ScoreInputDialog> createState() => _ScoreInputDialogState();
}

class _ScoreInputDialogState extends ConsumerState<ScoreInputDialog> {
  late int _homeScore;
  late int _awayScore;

  @override
  void initState() {
    super.initState();
    _homeScore = widget.existingPrediction?.homeScore ?? 0;
    _awayScore = widget.existingPrediction?.awayScore ?? 0;
  }

  void _incrementHome() => setState(() => _homeScore++);
  void _decrementHome() =>
      setState(() => _homeScore = _homeScore > 0 ? _homeScore - 1 : 0);

  void _incrementAway() => setState(() => _awayScore++);
  void _decrementAway() =>
      setState(() => _awayScore = _awayScore > 0 ? _awayScore - 1 : 0);

  Future<void> _submit() async {
    await ref.read(predictionControllerProvider.notifier).submitPrediction(
          matchId: widget.match.id,
          homeScore: _homeScore,
          awayScore: _awayScore,
          existingPredictionId: widget.existingPrediction?.id,
        );
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(predictionControllerProvider).isLoading;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      elevation: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                  Theme.of(context).colorScheme.surface.withValues(alpha: 0.6),
                ],
              ),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.6),
                  blurRadius: 40,
                  spreadRadius: -10,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Pronóstico',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white54, size: 20),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 36),

                // Score Input Area
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Home Team
                    Expanded(
                      child: Column(
                        children: [
                          _TeamFlagLarge(
                            flag: widget.match.homeFlag,
                            team: widget.match.homeTeam,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.match.homeTeam,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 20),
                          _ScoreSelector(
                            score: _homeScore,
                            onIncrement: _incrementHome,
                            onDecrement: _decrementHome,
                          ),
                        ],
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'VS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.white24,
                        ),
                      ),
                    ),

                    // Away Team
                    Expanded(
                      child: Column(
                        children: [
                          _TeamFlagLarge(
                            flag: widget.match.awayFlag,
                            team: widget.match.awayTeam,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            widget.match.awayTeam,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 20),
                          _ScoreSelector(
                            score: _awayScore,
                            onIncrement: _incrementAway,
                            onDecrement: _decrementAway,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 8,
                      shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            widget.existingPrediction != null
                                ? 'ACTUALIZAR'
                                : 'GUARDAR PREDICCIÓN',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ).animate().scale(
            duration: 300.ms,
            curve: Curves.easeOutBack,
            begin: const Offset(0.8, 0.8),
          ).fadeIn(duration: 200.ms),
    );
  }
}

class _ScoreSelector extends StatelessWidget {
  final int score;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _ScoreSelector({
    required this.score,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF131B22),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onIncrement,
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(Icons.keyboard_arrow_up, color: Colors.white, size: 28),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(
              score.toString(),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onDecrement,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  color: score > 0 ? Colors.white : Colors.white24,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamFlagLarge extends StatelessWidget {
  final String? flag;
  final String team;

  const _TeamFlagLarge({this.flag, required this.team});

  @override
  Widget build(BuildContext context) {
    if (flag != null) {
      return Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.white10, width: 2),
        ),
        child: ClipOval(
          child: Image.network(
            flag!,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallback(),
          ),
        ),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF1C2A36),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white12, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          team.isNotEmpty ? team[0] : '?',
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 28, color: Colors.white70),
        ),
      ),
    );
  }
}
