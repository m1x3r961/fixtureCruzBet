import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/fixture/presentation/fixture_screen.dart';
import '../providers/supabase_provider.dart';

part 'app_router.g.dart';

// ---------------------------------------------------------------------------
// Nombres de rutas (constantes para evitar typos)
// ---------------------------------------------------------------------------
abstract class AppRoutes {
  static const login = '/login';
  static const fixture = '/fixture';
}

// ---------------------------------------------------------------------------
// Provider del router
// ---------------------------------------------------------------------------
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authNotifier = _AuthNotifier(ref);

  return GoRouter(
    initialLocation: AppRoutes.fixture,
    refreshListenable: authNotifier,
    debugLogDiagnostics: true,

    redirect: (BuildContext context, GoRouterState state) {
      final user = Supabase.instance.client.auth.currentUser;
      final isLoggedIn = user != null;
      final isOnLoginPage = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn && !isOnLoginPage) return AppRoutes.login;
      if (isLoggedIn && isOnLoginPage) return AppRoutes.fixture;
      return null;
    },

    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.fixture,
        name: 'fixture',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: FixtureScreen(),
        ),
      ),
    ],

    errorPageBuilder: (context, state) => MaterialPage(
      child: Scaffold(
        body: Center(
          child: Text('Ruta no encontrada: ${state.error}'),
        ),
      ),
    ),
  );
}

// ---------------------------------------------------------------------------
// Notifier que hace Listenable el stream de auth para que GoRouter reaccione
// ---------------------------------------------------------------------------
class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(Ref ref) {
    ref.listen(authStateStreamProvider, (_, __) => notifyListeners());
  }
}
