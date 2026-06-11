// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prediction_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$userPredictionsHash() => r'05093ee8fc12fdcff2c35d7af7faf75d3201ca2a';

/// See also [userPredictions].
@ProviderFor(userPredictions)
final userPredictionsProvider =
    AutoDisposeFutureProvider<List<Prediction>>.internal(
  userPredictions,
  name: r'userPredictionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$userPredictionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UserPredictionsRef = AutoDisposeFutureProviderRef<List<Prediction>>;
String _$predictionForMatchHash() =>
    r'3d9c79d739b75c5b5c4c1a740ff3b68e5c6c784a';

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

/// See also [predictionForMatch].
@ProviderFor(predictionForMatch)
const predictionForMatchProvider = PredictionForMatchFamily();

/// See also [predictionForMatch].
class PredictionForMatchFamily extends Family<AsyncValue<Prediction?>> {
  /// See also [predictionForMatch].
  const PredictionForMatchFamily();

  /// See also [predictionForMatch].
  PredictionForMatchProvider call(
    String matchId,
  ) {
    return PredictionForMatchProvider(
      matchId,
    );
  }

  @override
  PredictionForMatchProvider getProviderOverride(
    covariant PredictionForMatchProvider provider,
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
  String? get name => r'predictionForMatchProvider';
}

/// See also [predictionForMatch].
class PredictionForMatchProvider
    extends AutoDisposeFutureProvider<Prediction?> {
  /// See also [predictionForMatch].
  PredictionForMatchProvider(
    String matchId,
  ) : this._internal(
          (ref) => predictionForMatch(
            ref as PredictionForMatchRef,
            matchId,
          ),
          from: predictionForMatchProvider,
          name: r'predictionForMatchProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$predictionForMatchHash,
          dependencies: PredictionForMatchFamily._dependencies,
          allTransitiveDependencies:
              PredictionForMatchFamily._allTransitiveDependencies,
          matchId: matchId,
        );

  PredictionForMatchProvider._internal(
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
    FutureOr<Prediction?> Function(PredictionForMatchRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: PredictionForMatchProvider._internal(
        (ref) => create(ref as PredictionForMatchRef),
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
  AutoDisposeFutureProviderElement<Prediction?> createElement() {
    return _PredictionForMatchProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is PredictionForMatchProvider && other.matchId == matchId;
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
mixin PredictionForMatchRef on AutoDisposeFutureProviderRef<Prediction?> {
  /// The parameter `matchId` of this provider.
  String get matchId;
}

class _PredictionForMatchProviderElement
    extends AutoDisposeFutureProviderElement<Prediction?>
    with PredictionForMatchRef {
  _PredictionForMatchProviderElement(super.provider);

  @override
  String get matchId => (origin as PredictionForMatchProvider).matchId;
}

String _$predictionControllerHash() =>
    r'd1eb51866fb923d144a955d8bd610498bd517e72';

/// See also [PredictionController].
@ProviderFor(PredictionController)
final predictionControllerProvider = AutoDisposeNotifierProvider<
    PredictionController, AsyncValue<PredictionStatus>>.internal(
  PredictionController.new,
  name: r'predictionControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$predictionControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PredictionController
    = AutoDisposeNotifier<AsyncValue<PredictionStatus>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
