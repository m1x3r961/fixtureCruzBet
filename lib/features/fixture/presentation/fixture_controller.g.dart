// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fixture_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$matchDetailHash() => r'34bf8f4ef53f92ad7b299704e0a1e54e6be75fe3';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// Provider para obtener un partido específico
///
/// Copied from [matchDetail].
@ProviderFor(matchDetail)
const matchDetailProvider = MatchDetailFamily();

/// Provider para obtener un partido específico
///
/// Copied from [matchDetail].
class MatchDetailFamily extends Family<AsyncValue<Match?>> {
  /// Provider para obtener un partido específico
  ///
  /// Copied from [matchDetail].
  const MatchDetailFamily();

  /// Provider para obtener un partido específico
  ///
  /// Copied from [matchDetail].
  MatchDetailProvider call(
    String matchId,
  ) {
    return MatchDetailProvider(
      matchId,
    );
  }

  @override
  MatchDetailProvider getProviderOverride(
    covariant MatchDetailProvider provider,
  ) {
    return call(
      provider.matchId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'matchDetailProvider';
}

/// Provider para obtener un partido específico
///
/// Copied from [matchDetail].
class MatchDetailProvider extends AutoDisposeFutureProvider<Match?> {
  /// Provider para obtener un partido específico
  ///
  /// Copied from [matchDetail].
  MatchDetailProvider(
    String matchId,
  ) : this._internal(
          (ref) => matchDetail(
            ref as MatchDetailRef,
            matchId,
          ),
          from: matchDetailProvider,
          name: r'matchDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$matchDetailHash,
          dependencies: MatchDetailFamily._dependencies,
          allTransitiveDependencies:
              MatchDetailFamily._allTransitiveDependencies,
          matchId: matchId,
        );

  MatchDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.matchId,
  }) : super.internal();

  final String matchId;

  @override
  Override overrideWith(
    FutureOr<Match?> Function(MatchDetailRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MatchDetailProvider._internal(
        (ref) => create(ref as MatchDetailRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        matchId: matchId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Match?> createElement() {
    return _MatchDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MatchDetailProvider && other.matchId == matchId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, matchId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MatchDetailRef on AutoDisposeFutureProviderRef<Match?> {
  /// The parameter `matchId` of this provider.
  String get matchId;
}

class _MatchDetailProviderElement
    extends AutoDisposeFutureProviderElement<Match?> with MatchDetailRef {
  _MatchDetailProviderElement(super.provider);

  @override
  String get matchId => (origin as MatchDetailProvider).matchId;
}

String _$fixtureControllerHash() => r'602e4d62af7fd127c91a35e7680c2ee9f717e251';

/// Controller del fixture. Expone los partidos en tiempo real via Supabase Realtime.
///
/// Copied from [FixtureController].
@ProviderFor(FixtureController)
final fixtureControllerProvider =
    AutoDisposeStreamNotifierProvider<FixtureController, List<Match>>.internal(
  FixtureController.new,
  name: r'fixtureControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$fixtureControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$FixtureController = AutoDisposeStreamNotifier<List<Match>>;
String _$matchesByStageControllerHash() =>
    r'a11160ce977c276e4d4c2cb19dcdc60a88b45b10';

abstract class _$MatchesByStageController
    extends BuildlessAutoDisposeStreamNotifier<List<Match>> {
  late final String stage;

  Stream<List<Match>> build(
    String stage,
  );
}

/// Controller filtrado por stage
///
/// Copied from [MatchesByStageController].
@ProviderFor(MatchesByStageController)
const matchesByStageControllerProvider = MatchesByStageControllerFamily();

/// Controller filtrado por stage
///
/// Copied from [MatchesByStageController].
class MatchesByStageControllerFamily extends Family<AsyncValue<List<Match>>> {
  /// Controller filtrado por stage
  ///
  /// Copied from [MatchesByStageController].
  const MatchesByStageControllerFamily();

  /// Controller filtrado por stage
  ///
  /// Copied from [MatchesByStageController].
  MatchesByStageControllerProvider call(
    String stage,
  ) {
    return MatchesByStageControllerProvider(
      stage,
    );
  }

  @override
  MatchesByStageControllerProvider getProviderOverride(
    covariant MatchesByStageControllerProvider provider,
  ) {
    return call(
      provider.stage,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'matchesByStageControllerProvider';
}

/// Controller filtrado por stage
///
/// Copied from [MatchesByStageController].
class MatchesByStageControllerProvider
    extends AutoDisposeStreamNotifierProviderImpl<MatchesByStageController,
        List<Match>> {
  /// Controller filtrado por stage
  ///
  /// Copied from [MatchesByStageController].
  MatchesByStageControllerProvider(
    String stage,
  ) : this._internal(
          () => MatchesByStageController()..stage = stage,
          from: matchesByStageControllerProvider,
          name: r'matchesByStageControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$matchesByStageControllerHash,
          dependencies: MatchesByStageControllerFamily._dependencies,
          allTransitiveDependencies:
              MatchesByStageControllerFamily._allTransitiveDependencies,
          stage: stage,
        );

  MatchesByStageControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.stage,
  }) : super.internal();

  final String stage;

  @override
  Stream<List<Match>> runNotifierBuild(
    covariant MatchesByStageController notifier,
  ) {
    return notifier.build(
      stage,
    );
  }

  @override
  Override overrideWith(MatchesByStageController Function() create) {
    return ProviderOverride(
      origin: this,
      override: MatchesByStageControllerProvider._internal(
        () => create()..stage = stage,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        stage: stage,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<MatchesByStageController,
      List<Match>> createElement() {
    return _MatchesByStageControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MatchesByStageControllerProvider && other.stage == stage;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, stage.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MatchesByStageControllerRef
    on AutoDisposeStreamNotifierProviderRef<List<Match>> {
  /// The parameter `stage` of this provider.
  String get stage;
}

class _MatchesByStageControllerProviderElement
    extends AutoDisposeStreamNotifierProviderElement<MatchesByStageController,
        List<Match>> with MatchesByStageControllerRef {
  _MatchesByStageControllerProviderElement(super.provider);

  @override
  String get stage => (origin as MatchesByStageControllerProvider).stage;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
