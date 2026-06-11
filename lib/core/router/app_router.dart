import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/auth/presentation/login_screen.dart';
import '../../features/fixture/presentation/fixture_screen.dart';
import '../../features/admin/presentation/admin_dashboard_screen.dart';
import '../../features/admin/presentation/admin_user_detail_screen.dart';
import '../../features/admin/domain/admin_models.dart';
import '../../features/auth/data/profile_repository.dart';
import '../providers/supabase_provider.dart';

part 'app_router.g.dart';

// ---------------------------------------------------------------------------
// Nombres de rutas (constantes para evitar typos)
// ---------------------------------------------------------------------------
abstract class AppRoutes {
  static const login = '/login';
  static const fixture = '/fixture';
  static const admin = '/admin';
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

      if (isLoggedIn) {
        final profileState = ref.read(currentProfileProvider);
        
        // Solo redirigir basándonos en roles si el perfil ya cargó
        if (profileState.hasValue) {
          final profile = profileState.value;
          final isAdmin = profile?.isAdmin ?? false;

          if (isOnLoginPage) {
            return isAdmin ? AppRoutes.admin : AppRoutes.fixture;
          }

          // Si es admin y está en el fixture, forzarlo al admin dashboard
          if (isAdmin && state.matchedLocation == AppRoutes.fixture) {
            return AppRoutes.admin;
          }
        } else if (isOnLoginPage) {
           // Si apenas hizo login y el perfil no ha cargado, lo mandamos al fixture temporalmente,
           // o esperamos. Es mejor mandarlo al fixture, y si es admin el UI (o un listener) lo sacará.
           // Pero podemos usar un listener en _AuthNotifier para notificar cuando el perfil cambia.
           return AppRoutes.fixture;
        }
      }
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
      GoRoute(
        path: AppRoutes.admin,
        name: 'admin',
        pageBuilder: (context, state) => const NoTransitionPage(
          child: AdminDashboardScreen(),
        ),
        routes: [
          GoRoute(
            path: 'user/:id',
            name: 'admin_user_detail',
            pageBuilder: (context, state) {
              final userSummary = state.extra as UserSummary;
              return NoTransitionPage(
                child: AdminUserDetailScreen(userSummary: userSummary),
              );
            },
          ),
        ],
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
// Notifier que hace Listenable el stream de auth y el perfil
// ---------------------------------------------------------------------------
class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier(Ref ref) {
    ref.listen(authStateStreamProvider, (_, __) => notifyListeners());
    ref.listen(currentProfileProvider, (_, __) => notifyListeners());
  }
}
