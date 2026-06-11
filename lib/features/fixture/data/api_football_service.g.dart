// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_football_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$apiFootballServiceHash() =>
    r'ff20e10874c68d72914fbf92e405bd4eca9aa321';

/// See also [apiFootballService].
@ProviderFor(apiFootballService)
final apiFootballServiceProvider =
    AutoDisposeProvider<ApiFootballService>.internal(
  apiFootballService,
  name: r'apiFootballServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$apiFootballServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ApiFootballServiceRef = AutoDisposeProviderRef<ApiFootballService>;
String _$matchSyncControllerHash() =>
    r'cf8119786308476242446f81cfd9244183eb6e48';

/// Controller que verifica si es necesario sincronizar antes de llamar a la API.
///
/// Copied from [MatchSyncController].
@ProviderFor(MatchSyncController)
final matchSyncControllerProvider = AutoDisposeNotifierProvider<
    MatchSyncController, AsyncValue<SyncResult?>>.internal(
  MatchSyncController.new,
  name: r'matchSyncControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$matchSyncControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MatchSyncController = AutoDisposeNotifier<AsyncValue<SyncResult?>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
