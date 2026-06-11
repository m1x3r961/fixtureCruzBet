import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.status == AuthStatus.loading;

    ref.listen(authControllerProvider, (_, next) {
      if (next.status == AuthStatus.error && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: const Color(0xFFB00020),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        ref.read(authControllerProvider.notifier).reset();
      }
    });

    return Scaffold(
      body: Container(
        color: const Color(0xFF3D3D3D),
        child: Stack(
          children: [
            // Decoración de fondo — círculos difusos verdes
            Positioned(
              top: -80,
              left: -80,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF22C55E).withValues(alpha: 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: -60,
              right: -60,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF15803D).withValues(alpha: 0.15),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Contenido principal
            SafeArea(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 420),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(flex: 2),

                        // ── Logo PNG (transparente, sin texto) ──
                        // ── Logo (fondo plomo sólido, sin transparencia) ──
                        Image.asset(
                          'assets/images/logo_app.png',
                          width: 300,
                          fit: BoxFit.contain,
                        )
                            .animate()
                            .fadeIn(duration: 700.ms)
                            .slideY(begin: -0.15, curve: Curves.easeOutCubic),

                        const SizedBox(height: 32),

                        // ── Subtítulo ──
                        Text(
                          'Predice · Compite · Gana',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withValues(alpha: 0.6),
                            letterSpacing: 1.5,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 300.ms, duration: 500.ms),

                        const Spacer(flex: 2),

                        // ── Card del Botón ──
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                'Inicia sesión para continuar',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withValues(alpha: 0.5),
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 16),

                              // ── Botón Google ──
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: isLoading
                                      ? null
                                      : () => ref
                                          .read(authControllerProvider.notifier)
                                          .signInWithGoogle(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: const Color(0xFF1A1A1A),
                                    disabledBackgroundColor:
                                        Colors.white.withValues(alpha: 0.5),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: isLoading
                                      ? const SizedBox(
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: Color(0xFF4285F4),
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            // Ícono G de Google
                                            Container(
                                              width: 24,
                                              height: 24,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Text(
                                                'G',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w900,
                                                  color: Color(0xFF4285F4),
                                                  height: 1.35,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            const Text(
                                              'Continuar con Google',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: Color(0xFF1A1A1A),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 400.ms, duration: 600.ms)
                            .slideY(begin: 0.12, curve: Curves.easeOutCubic),

                        const Spacer(flex: 1),

                        // ── Footer ──
                        Text(
                          'Mundial 2026 · CruzBet',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.white.withValues(alpha: 0.25),
                            letterSpacing: 1,
                          ),
                        )
                            .animate()
                            .fadeIn(delay: 700.ms, duration: 400.ms),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
