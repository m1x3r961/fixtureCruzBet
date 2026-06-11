import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/providers/supabase_provider.dart';
import '../domain/profile_model.dart';

part 'profile_repository.g.dart';

class ProfileRepository {
  final SupabaseClient _client;

  ProfileRepository(this._client);

  /// Obtiene el perfil del usuario autenticado actual.
  Future<Profile?> getCurrentUserProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) return null;
    return Profile.fromJson(response);
  }

  /// Verifica rápidamente si el usuario actual es administrador.
  Future<bool> isCurrentUserAdmin() async {
    final profile = await getCurrentUserProfile();
    return profile?.isAdmin ?? false;
  }
}

@riverpod
ProfileRepository profileRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return ProfileRepository(client);
}

/// Provider para observar el perfil actual, se invalida cuando cambia el Auth State.
@riverpod
Future<Profile?> currentProfile(Ref ref) async {
  // Invalidar cuando el estado de autenticación cambia
  ref.watch(authStateStreamProvider);
  
  final repo = ref.watch(profileRepositoryProvider);
  return repo.getCurrentUserProfile();
}
