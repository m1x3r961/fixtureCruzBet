import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'supabase_provider.g.dart';

/// Provider global y único del SupabaseClient.
/// Al usar `keepAlive: true`, el cliente nunca se destruye.
@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(Ref ref) {
  return Supabase.instance.client;
}

/// Shortcut para acceder al usuario autenticado actual.
@Riverpod(keepAlive: true)
User? currentUser(Ref ref) {
  return Supabase.instance.client.auth.currentUser;
}

/// Stream del estado de autenticación de Supabase.
/// Se usa en el router para redirigir al login o al fixture.
@Riverpod(keepAlive: true)
Stream<AuthState> authStateStream(Ref ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
}
