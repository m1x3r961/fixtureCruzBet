import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Widget de carga con efecto shimmer para listas de partidos
class MatchListShimmer extends StatelessWidget {
  final int itemCount;
  const MatchListShimmer({super.key, this.itemCount = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemBuilder: (_, __) => const _MatchCardSkeleton(),
    );
  }
}

class _MatchCardSkeleton extends StatelessWidget {
  const _MatchCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF1C2435),
      highlightColor: const Color(0xFF2A3A55),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        height: 100,
        decoration: BoxDecoration(
          color: const Color(0xFF111827),
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

/// Widget de error genérico con botón de reintento
class ErrorRetryWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorRetryWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.sports_soccer_outlined,
              size: 56,
              color: Color(0xFF2A3A55),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF8899AA), fontSize: 14),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Badge de estado del partido (LIVE, SCHEDULED, FINISHED)
class MatchStatusBadge extends StatelessWidget {
  final String status;
  const MatchStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status.toUpperCase()) {
      'LIVE' || 'IN_PLAY' => ('EN VIVO', const Color(0xFFFF3D57)),
      'FINISHED' || 'FT' => ('FT', const Color(0xFF4CAF50)),
      _ => ('PRÓXIMO', const Color(0xFF1E88E5)),
    };

    final isLive = status.toUpperCase() == 'LIVE' ||
        status.toUpperCase() == 'IN_PLAY';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLive) ...[
            _PulsingDot(color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  final Color color;
  const _PulsingDot({required this.color});

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Opacity(
        opacity: _anim.value,
        child: Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
