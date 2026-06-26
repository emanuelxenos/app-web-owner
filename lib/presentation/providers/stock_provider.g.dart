// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$inventoryDetailsHash() => r'438f15ae263942e537f95aa62f2dd9b731545766';

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

/// See also [inventoryDetails].
@ProviderFor(inventoryDetails)
const inventoryDetailsProvider = InventoryDetailsFamily();

/// See also [inventoryDetails].
class InventoryDetailsFamily extends Family<AsyncValue<Inventario>> {
  /// See also [inventoryDetails].
  const InventoryDetailsFamily();

  /// See also [inventoryDetails].
  InventoryDetailsProvider call(int id) {
    return InventoryDetailsProvider(id);
  }

  @override
  InventoryDetailsProvider getProviderOverride(
    covariant InventoryDetailsProvider provider,
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
  String? get name => r'inventoryDetailsProvider';
}

/// See also [inventoryDetails].
class InventoryDetailsProvider extends AutoDisposeFutureProvider<Inventario> {
  /// See also [inventoryDetails].
  InventoryDetailsProvider(int id)
    : this._internal(
        (ref) => inventoryDetails(ref as InventoryDetailsRef, id),
        from: inventoryDetailsProvider,
        name: r'inventoryDetailsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$inventoryDetailsHash,
        dependencies: InventoryDetailsFamily._dependencies,
        allTransitiveDependencies:
            InventoryDetailsFamily._allTransitiveDependencies,
        id: id,
      );

  InventoryDetailsProvider._internal(
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
  Override overrideWith(
    FutureOr<Inventario> Function(InventoryDetailsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: InventoryDetailsProvider._internal(
        (ref) => create(ref as InventoryDetailsRef),
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
  AutoDisposeFutureProviderElement<Inventario> createElement() {
    return _InventoryDetailsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InventoryDetailsProvider && other.id == id;
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
mixin InventoryDetailsRef on AutoDisposeFutureProviderRef<Inventario> {
  /// The parameter `id` of this provider.
  int get id;
}

class _InventoryDetailsProviderElement
    extends AutoDisposeFutureProviderElement<Inventario>
    with InventoryDetailsRef {
  _InventoryDetailsProviderElement(super.provider);

  @override
  int get id => (origin as InventoryDetailsProvider).id;
}

String _$lowStockHash() => r'0eab20714c0c96a20a4d3e1e331f697025fc0896';

/// See also [LowStock].
@ProviderFor(LowStock)
final lowStockProvider =
    AutoDisposeAsyncNotifierProvider<
      LowStock,
      List<EstoqueBaixoResponse>
    >.internal(
      LowStock.new,
      name: r'lowStockProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$lowStockHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$LowStock = AutoDisposeAsyncNotifier<List<EstoqueBaixoResponse>>;
String _$stockMovementsHash() => r'2a95576201976cd098e1cd8e3662adc882e789ba';

abstract class _$StockMovements
    extends BuildlessAutoDisposeAsyncNotifier<List<EstoqueMovimentacao>> {
  late final int? produtoId;
  late final DateTime? inicio;
  late final DateTime? fim;
  late final String? tipo;

  FutureOr<List<EstoqueMovimentacao>> build({
    int? produtoId,
    DateTime? inicio,
    DateTime? fim,
    String? tipo,
  });
}

/// See also [StockMovements].
@ProviderFor(StockMovements)
const stockMovementsProvider = StockMovementsFamily();

/// See also [StockMovements].
class StockMovementsFamily
    extends Family<AsyncValue<List<EstoqueMovimentacao>>> {
  /// See also [StockMovements].
  const StockMovementsFamily();

  /// See also [StockMovements].
  StockMovementsProvider call({
    int? produtoId,
    DateTime? inicio,
    DateTime? fim,
    String? tipo,
  }) {
    return StockMovementsProvider(
      produtoId: produtoId,
      inicio: inicio,
      fim: fim,
      tipo: tipo,
    );
  }

  @override
  StockMovementsProvider getProviderOverride(
    covariant StockMovementsProvider provider,
  ) {
    return call(
      produtoId: provider.produtoId,
      inicio: provider.inicio,
      fim: provider.fim,
      tipo: provider.tipo,
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
  String? get name => r'stockMovementsProvider';
}

/// See also [StockMovements].
class StockMovementsProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          StockMovements,
          List<EstoqueMovimentacao>
        > {
  /// See also [StockMovements].
  StockMovementsProvider({
    int? produtoId,
    DateTime? inicio,
    DateTime? fim,
    String? tipo,
  }) : this._internal(
         () => StockMovements()
           ..produtoId = produtoId
           ..inicio = inicio
           ..fim = fim
           ..tipo = tipo,
         from: stockMovementsProvider,
         name: r'stockMovementsProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$stockMovementsHash,
         dependencies: StockMovementsFamily._dependencies,
         allTransitiveDependencies:
             StockMovementsFamily._allTransitiveDependencies,
         produtoId: produtoId,
         inicio: inicio,
         fim: fim,
         tipo: tipo,
       );

  StockMovementsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.produtoId,
    required this.inicio,
    required this.fim,
    required this.tipo,
  }) : super.internal();

  final int? produtoId;
  final DateTime? inicio;
  final DateTime? fim;
  final String? tipo;

  @override
  FutureOr<List<EstoqueMovimentacao>> runNotifierBuild(
    covariant StockMovements notifier,
  ) {
    return notifier.build(
      produtoId: produtoId,
      inicio: inicio,
      fim: fim,
      tipo: tipo,
    );
  }

  @override
  Override overrideWith(StockMovements Function() create) {
    return ProviderOverride(
      origin: this,
      override: StockMovementsProvider._internal(
        () => create()
          ..produtoId = produtoId
          ..inicio = inicio
          ..fim = fim
          ..tipo = tipo,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        produtoId: produtoId,
        inicio: inicio,
        fim: fim,
        tipo: tipo,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    StockMovements,
    List<EstoqueMovimentacao>
  >
  createElement() {
    return _StockMovementsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StockMovementsProvider &&
        other.produtoId == produtoId &&
        other.inicio == inicio &&
        other.fim == fim &&
        other.tipo == tipo;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, produtoId.hashCode);
    hash = _SystemHash.combine(hash, inicio.hashCode);
    hash = _SystemHash.combine(hash, fim.hashCode);
    hash = _SystemHash.combine(hash, tipo.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StockMovementsRef
    on AutoDisposeAsyncNotifierProviderRef<List<EstoqueMovimentacao>> {
  /// The parameter `produtoId` of this provider.
  int? get produtoId;

  /// The parameter `inicio` of this provider.
  DateTime? get inicio;

  /// The parameter `fim` of this provider.
  DateTime? get fim;

  /// The parameter `tipo` of this provider.
  String? get tipo;
}

class _StockMovementsProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          StockMovements,
          List<EstoqueMovimentacao>
        >
    with StockMovementsRef {
  _StockMovementsProviderElement(super.provider);

  @override
  int? get produtoId => (origin as StockMovementsProvider).produtoId;
  @override
  DateTime? get inicio => (origin as StockMovementsProvider).inicio;
  @override
  DateTime? get fim => (origin as StockMovementsProvider).fim;
  @override
  String? get tipo => (origin as StockMovementsProvider).tipo;
}

String _$inventoriesHash() => r'da41453e06954c9d5fc0b9ced5d12a16bd7027c3';

abstract class _$Inventories
    extends BuildlessAutoDisposeAsyncNotifier<List<Inventario>> {
  late final DateTime? inicio;
  late final DateTime? fim;

  FutureOr<List<Inventario>> build({DateTime? inicio, DateTime? fim});
}

/// See also [Inventories].
@ProviderFor(Inventories)
const inventoriesProvider = InventoriesFamily();

/// See also [Inventories].
class InventoriesFamily extends Family<AsyncValue<List<Inventario>>> {
  /// See also [Inventories].
  const InventoriesFamily();

  /// See also [Inventories].
  InventoriesProvider call({DateTime? inicio, DateTime? fim}) {
    return InventoriesProvider(inicio: inicio, fim: fim);
  }

  @override
  InventoriesProvider getProviderOverride(
    covariant InventoriesProvider provider,
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
  String? get name => r'inventoriesProvider';
}

/// See also [Inventories].
class InventoriesProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<Inventories, List<Inventario>> {
  /// See also [Inventories].
  InventoriesProvider({DateTime? inicio, DateTime? fim})
    : this._internal(
        () => Inventories()
          ..inicio = inicio
          ..fim = fim,
        from: inventoriesProvider,
        name: r'inventoriesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$inventoriesHash,
        dependencies: InventoriesFamily._dependencies,
        allTransitiveDependencies: InventoriesFamily._allTransitiveDependencies,
        inicio: inicio,
        fim: fim,
      );

  InventoriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.inicio,
    required this.fim,
  }) : super.internal();

  final DateTime? inicio;
  final DateTime? fim;

  @override
  FutureOr<List<Inventario>> runNotifierBuild(covariant Inventories notifier) {
    return notifier.build(inicio: inicio, fim: fim);
  }

  @override
  Override overrideWith(Inventories Function() create) {
    return ProviderOverride(
      origin: this,
      override: InventoriesProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<Inventories, List<Inventario>>
  createElement() {
    return _InventoriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is InventoriesProvider &&
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
mixin InventoriesRef on AutoDisposeAsyncNotifierProviderRef<List<Inventario>> {
  /// The parameter `inicio` of this provider.
  DateTime? get inicio;

  /// The parameter `fim` of this provider.
  DateTime? get fim;
}

class _InventoriesProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<Inventories, List<Inventario>>
    with InventoriesRef {
  _InventoriesProviderElement(super.provider);

  @override
  DateTime? get inicio => (origin as InventoriesProvider).inicio;
  @override
  DateTime? get fim => (origin as InventoriesProvider).fim;
}

String _$stockActionsHash() => r'307c3f830b0172f006229e4debc4fcefae017d79';

/// See also [StockActions].
@ProviderFor(StockActions)
final stockActionsProvider =
    AutoDisposeNotifierProvider<StockActions, bool>.internal(
      StockActions.new,
      name: r'stockActionsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$stockActionsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$StockActions = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
