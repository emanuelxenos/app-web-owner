// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$salesHistoryHash() => r'3c5279fd4e8615447a1f2001081103a32543accb';

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

abstract class _$SalesHistory
    extends BuildlessAutoDisposeAsyncNotifier<List<Venda>> {
  late final String? inicio;
  late final String? fim;

  FutureOr<List<Venda>> build({String? inicio, String? fim});
}

/// See also [SalesHistory].
@ProviderFor(SalesHistory)
const salesHistoryProvider = SalesHistoryFamily();

/// See also [SalesHistory].
class SalesHistoryFamily extends Family<AsyncValue<List<Venda>>> {
  /// See also [SalesHistory].
  const SalesHistoryFamily();

  /// See also [SalesHistory].
  SalesHistoryProvider call({String? inicio, String? fim}) {
    return SalesHistoryProvider(inicio: inicio, fim: fim);
  }

  @override
  SalesHistoryProvider getProviderOverride(
    covariant SalesHistoryProvider provider,
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
  String? get name => r'salesHistoryProvider';
}

/// See also [SalesHistory].
class SalesHistoryProvider
    extends AutoDisposeAsyncNotifierProviderImpl<SalesHistory, List<Venda>> {
  /// See also [SalesHistory].
  SalesHistoryProvider({String? inicio, String? fim})
    : this._internal(
        () => SalesHistory()
          ..inicio = inicio
          ..fim = fim,
        from: salesHistoryProvider,
        name: r'salesHistoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$salesHistoryHash,
        dependencies: SalesHistoryFamily._dependencies,
        allTransitiveDependencies:
            SalesHistoryFamily._allTransitiveDependencies,
        inicio: inicio,
        fim: fim,
      );

  SalesHistoryProvider._internal(
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
  FutureOr<List<Venda>> runNotifierBuild(covariant SalesHistory notifier) {
    return notifier.build(inicio: inicio, fim: fim);
  }

  @override
  Override overrideWith(SalesHistory Function() create) {
    return ProviderOverride(
      origin: this,
      override: SalesHistoryProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<SalesHistory, List<Venda>>
  createElement() {
    return _SalesHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SalesHistoryProvider &&
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
mixin SalesHistoryRef on AutoDisposeAsyncNotifierProviderRef<List<Venda>> {
  /// The parameter `inicio` of this provider.
  String? get inicio;

  /// The parameter `fim` of this provider.
  String? get fim;
}

class _SalesHistoryProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SalesHistory, List<Venda>>
    with SalesHistoryRef {
  _SalesHistoryProviderElement(super.provider);

  @override
  String? get inicio => (origin as SalesHistoryProvider).inicio;
  @override
  String? get fim => (origin as SalesHistoryProvider).fim;
}

String _$saleDetailHash() => r'19372f55b0673bfeaee319396c867e83ee37cb00';

abstract class _$SaleDetail extends BuildlessAutoDisposeAsyncNotifier<Venda?> {
  late final int id;

  FutureOr<Venda?> build(int id);
}

/// See also [SaleDetail].
@ProviderFor(SaleDetail)
const saleDetailProvider = SaleDetailFamily();

/// See also [SaleDetail].
class SaleDetailFamily extends Family<AsyncValue<Venda?>> {
  /// See also [SaleDetail].
  const SaleDetailFamily();

  /// See also [SaleDetail].
  SaleDetailProvider call(int id) {
    return SaleDetailProvider(id);
  }

  @override
  SaleDetailProvider getProviderOverride(
    covariant SaleDetailProvider provider,
  ) {
    return call(provider.id);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'saleDetailProvider';
}

/// See also [SaleDetail].
class SaleDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<SaleDetail, Venda?> {
  /// See also [SaleDetail].
  SaleDetailProvider(int id)
    : this._internal(
        () => SaleDetail()..id = id,
        from: saleDetailProvider,
        name: r'saleDetailProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$saleDetailHash,
        dependencies: SaleDetailFamily._dependencies,
        allTransitiveDependencies: SaleDetailFamily._allTransitiveDependencies,
        id: id,
      );

  SaleDetailProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  FutureOr<Venda?> runNotifierBuild(covariant SaleDetail notifier) {
    return notifier.build(id);
  }

  @override
  Override overrideWith(SaleDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: SaleDetailProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<SaleDetail, Venda?> createElement() {
    return _SaleDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SaleDetailProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SaleDetailRef on AutoDisposeAsyncNotifierProviderRef<Venda?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _SaleDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<SaleDetail, Venda?>
    with SaleDetailRef {
  _SaleDetailProviderElement(super.provider);

  @override
  int get id => (origin as SaleDetailProvider).id;
}

String _$saleActionsHash() => r'c1b413c0f083b11dea943c8eb66c50b16d4ce196';

/// See also [SaleActions].
@ProviderFor(SaleActions)
final saleActionsProvider =
    AutoDisposeNotifierProvider<SaleActions, bool>.internal(
      SaleActions.new,
      name: r'saleActionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$saleActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SaleActions = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
