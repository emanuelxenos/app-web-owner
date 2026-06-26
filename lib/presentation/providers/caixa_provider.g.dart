// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'caixa_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$caixaStatusHash() => r'6e91eff7098b1389df229461d9a9fb76278b881a';

/// See also [caixaStatus].
@ProviderFor(caixaStatus)
final caixaStatusProvider =
    AutoDisposeFutureProvider<CaixaStatusResponse>.internal(
      caixaStatus,
      name: r'caixaStatusProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$caixaStatusHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef CaixaStatusRef = AutoDisposeFutureProviderRef<CaixaStatusResponse>;
String _$caixaSessionsHash() => r'c768c455bce16f2fd8f0d1670097bdc8914e3b3a';

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

abstract class _$CaixaSessions
    extends BuildlessAutoDisposeAsyncNotifier<List<SessaoCaixa>> {
  late final String? inicio;
  late final String? fim;

  FutureOr<List<SessaoCaixa>> build({String? inicio, String? fim});
}

/// See also [CaixaSessions].
@ProviderFor(CaixaSessions)
const caixaSessionsProvider = CaixaSessionsFamily();

/// See also [CaixaSessions].
class CaixaSessionsFamily extends Family<AsyncValue<List<SessaoCaixa>>> {
  /// See also [CaixaSessions].
  const CaixaSessionsFamily();

  /// See also [CaixaSessions].
  CaixaSessionsProvider call({String? inicio, String? fim}) {
    return CaixaSessionsProvider(inicio: inicio, fim: fim);
  }

  @override
  CaixaSessionsProvider getProviderOverride(
    covariant CaixaSessionsProvider provider,
  ) {
    return call(inicio: provider.inicio, fim: provider.fim);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'caixaSessionsProvider';
}

/// See also [CaixaSessions].
class CaixaSessionsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<CaixaSessions, List<SessaoCaixa>> {
  /// See also [CaixaSessions].
  CaixaSessionsProvider({String? inicio, String? fim})
    : this._internal(
        () => CaixaSessions()
          ..inicio = inicio
          ..fim = fim,
        from: caixaSessionsProvider,
        name: r'caixaSessionsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$caixaSessionsHash,
        dependencies: CaixaSessionsFamily._dependencies,
        allTransitiveDependencies:
            CaixaSessionsFamily._allTransitiveDependencies,
        inicio: inicio,
        fim: fim,
      );

  CaixaSessionsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.inicio,
    required this.fim,
  }) : super.internal();

  final String? inicio;
  final String? fim;

  @override
  FutureOr<List<SessaoCaixa>> runNotifierBuild(
    covariant CaixaSessions notifier,
  ) {
    return notifier.build(inicio: inicio, fim: fim);
  }

  @override
  Override overrideWith(CaixaSessions Function() create) {
    return ProviderOverride(
      origin: this,
      override: CaixaSessionsProvider._internal(
        () => create()
          ..inicio = inicio
          ..fim = fim,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        inicio: inicio,
        fim: fim,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<CaixaSessions, List<SessaoCaixa>>
  createElement() {
    return _CaixaSessionsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CaixaSessionsProvider &&
        other.inicio == inicio &&
        other.fim == fim;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, inicio.hashCode);
    hash = _SystemHash.combine(hash, fim.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CaixaSessionsRef
    on AutoDisposeAsyncNotifierProviderRef<List<SessaoCaixa>> {
  /// The parameter `inicio` of this provider.
  String? get inicio;

  /// The parameter `fim` of this provider.
  String? get fim;
}

class _CaixaSessionsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          CaixaSessions,
          List<SessaoCaixa>
        >
    with CaixaSessionsRef {
  _CaixaSessionsProviderElement(super.provider);

  @override
  String? get inicio => (origin as CaixaSessionsProvider).inicio;
  @override
  String? get fim => (origin as CaixaSessionsProvider).fim;
}

String _$caixaMovementsHash() => r'40712370dd2ea5ae55299cd380b6e7c9b0f61797';

abstract class _$CaixaMovements
    extends BuildlessAutoDisposeAsyncNotifier<List<CaixaMovimentacao>> {
  late final String? inicio;
  late final String? fim;

  FutureOr<List<CaixaMovimentacao>> build({String? inicio, String? fim});
}

/// See also [CaixaMovements].
@ProviderFor(CaixaMovements)
const caixaMovementsProvider = CaixaMovementsFamily();

/// See also [CaixaMovements].
class CaixaMovementsFamily extends Family<AsyncValue<List<CaixaMovimentacao>>> {
  /// See also [CaixaMovements].
  const CaixaMovementsFamily();

  /// See also [CaixaMovements].
  CaixaMovementsProvider call({String? inicio, String? fim}) {
    return CaixaMovementsProvider(inicio: inicio, fim: fim);
  }

  @override
  CaixaMovementsProvider getProviderOverride(
    covariant CaixaMovementsProvider provider,
  ) {
    return call(inicio: provider.inicio, fim: provider.fim);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'caixaMovementsProvider';
}

/// See also [CaixaMovements].
class CaixaMovementsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          CaixaMovements,
          List<CaixaMovimentacao>
        > {
  /// See also [CaixaMovements].
  CaixaMovementsProvider({String? inicio, String? fim})
    : this._internal(
        () => CaixaMovements()
          ..inicio = inicio
          ..fim = fim,
        from: caixaMovementsProvider,
        name: r'caixaMovementsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$caixaMovementsHash,
        dependencies: CaixaMovementsFamily._dependencies,
        allTransitiveDependencies:
            CaixaMovementsFamily._allTransitiveDependencies,
        inicio: inicio,
        fim: fim,
      );

  CaixaMovementsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.inicio,
    required this.fim,
  }) : super.internal();

  final String? inicio;
  final String? fim;

  @override
  FutureOr<List<CaixaMovimentacao>> runNotifierBuild(
    covariant CaixaMovements notifier,
  ) {
    return notifier.build(inicio: inicio, fim: fim);
  }

  @override
  Override overrideWith(CaixaMovements Function() create) {
    return ProviderOverride(
      origin: this,
      override: CaixaMovementsProvider._internal(
        () => create()
          ..inicio = inicio
          ..fim = fim,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        inicio: inicio,
        fim: fim,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    CaixaMovements,
    List<CaixaMovimentacao>
  >
  createElement() {
    return _CaixaMovementsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CaixaMovementsProvider &&
        other.inicio == inicio &&
        other.fim == fim;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, inicio.hashCode);
    hash = _SystemHash.combine(hash, fim.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CaixaMovementsRef
    on AutoDisposeAsyncNotifierProviderRef<List<CaixaMovimentacao>> {
  /// The parameter `inicio` of this provider.
  String? get inicio;

  /// The parameter `fim` of this provider.
  String? get fim;
}

class _CaixaMovementsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          CaixaMovements,
          List<CaixaMovimentacao>
        >
    with CaixaMovementsRef {
  _CaixaMovementsProviderElement(super.provider);

  @override
  String? get inicio => (origin as CaixaMovementsProvider).inicio;
  @override
  String? get fim => (origin as CaixaMovementsProvider).fim;
}

String _$terminalsShowInactiveHash() =>
    r'00e41037bb799c884225239fc21763b726e52ec6';

/// See also [TerminalsShowInactive].
@ProviderFor(TerminalsShowInactive)
final terminalsShowInactiveProvider =
    AutoDisposeNotifierProvider<TerminalsShowInactive, bool>.internal(
      TerminalsShowInactive.new,
      name: r'terminalsShowInactiveProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$terminalsShowInactiveHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$TerminalsShowInactive = AutoDisposeNotifier<bool>;
String _$physicalTerminalsHash() => r'432bbb22187955ae24e549168aab7ef3c27436e9';

/// See also [PhysicalTerminals].
@ProviderFor(PhysicalTerminals)
final physicalTerminalsProvider =
    AutoDisposeAsyncNotifierProvider<
      PhysicalTerminals,
      List<CaixaFisico>
    >.internal(
      PhysicalTerminals.new,
      name: r'physicalTerminalsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$physicalTerminalsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PhysicalTerminals = AutoDisposeAsyncNotifier<List<CaixaFisico>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
