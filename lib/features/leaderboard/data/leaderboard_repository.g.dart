// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$leaderboardRepositoryHash() =>
    r'a1db98ae42fe79038cbc278f0751b5da72b98efa';

/// See also [leaderboardRepository].
@ProviderFor(leaderboardRepository)
final leaderboardRepositoryProvider =
    AutoDisposeProvider<LeaderboardRepository>.internal(
  leaderboardRepository,
  name: r'leaderboardRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$leaderboardRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LeaderboardRepositoryRef
    = AutoDisposeProviderRef<LeaderboardRepository>;
String _$leaderboardHash() => r'b56c3eec79198bf8f3fa8e3f047845b959283958';

/// See also [leaderboard].
@ProviderFor(leaderboard)
final leaderboardProvider =
    AutoDisposeFutureProvider<List<LeaderboardEntry>>.internal(
  leaderboard,
  name: r'leaderboardProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$leaderboardHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LeaderboardRef = AutoDisposeFutureProviderRef<List<LeaderboardEntry>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
