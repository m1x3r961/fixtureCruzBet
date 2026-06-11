import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_provider.dart';

part 'auth_controller.g.dart';

// ---------------------------------------------------------------------------
// Estado de autenticación
// ---------------------------------------------------------------------------
enum AuthStatus { idle, loading, success, error }

/// Estado inmutable de autenticación (sin freezed para evitar circular parts)
class AuthState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.idle,
    this.errorMessage,
  });

  AuthState copyWith({AuthStatus? status, String? errorMessage}) {
    return AuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ---------------------------------------------------------------------------
// Controller de autenticación
// ---------------------------------------------------------------------------
@riverpod
class AuthController extends _$AuthController {
  @override
  AuthState build() => const AuthState();

  SupabaseClient get _client => ref.read(supabaseClientProvider);


  // --- Google OAuth (Solo Web) ---
  Future<void> signInWithGoogle() async {
    state = const AuthState(status: AuthStatus.loading);
    try {
      await _client.auth.signInWithOAuth(
        OAuthProvider.google,
        // Al dejar redirectTo nulo en la web, Supabase redirigirá automáticamente a la URL actual
        // o a la "Site URL" configurada en el panel de Supabase.
      );
    } on AuthException catch (e) {
      state = AuthState(
        status: AuthStatus.error,
        errorMessage: _translateAuthError(e.message),
      );
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  void reset() => state = const AuthState();

  String _translateAuthError(String message) {
    if (message.contains('Invalid login credentials')) {
      return 'Email o contraseña incorrectos.';
    }
    if (message.contains('Email not confirmed')) {
      return 'Confirma tu email antes de iniciar sesión.';
    }
    if (message.contains('User already registered')) {
      return 'Este email ya está registrado. Inicia sesión.';
    }
    return message;
  }
}
