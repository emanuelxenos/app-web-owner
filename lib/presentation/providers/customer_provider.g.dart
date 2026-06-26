// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredCustomersHash() => r'24b3cefdb1f2828d7828caa7d52adaca389cb26d';

/// See also [filteredCustomers].
@ProviderFor(filteredCustomers)
final filteredCustomersProvider = AutoDisposeProvider<List<Cliente>>.internal(
  filteredCustomers,
  name: r'filteredCustomersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$filteredCustomersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredCustomersRef = AutoDisposeProviderRef<List<Cliente>>;
String _$customerHistoryHash() => r'3f6fe9ed55a7900391ea71c3885438c4e8b8ef7f';

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

/// See also [customerHistory].
@ProviderFor(customerHistory)
const customerHistoryProvider = CustomerHistoryFamily();

/// See also [customerHistory].
class CustomerHistoryFamily extends Family<AsyncValue<List<Venda>>> {
  /// See also [customerHistory].
  const CustomerHistoryFamily();

  /// See also [customerHistory].
  CustomerHistoryProvider call(int clienteId) {
    return CustomerHistoryProvider(clienteId);
  }

  @override
  CustomerHistoryProvider getProviderOverride(
    covariant CustomerHistoryProvider provider,
  ) {
    return call(provider.clienteId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customerHistoryProvider';
}

/// See also [customerHistory].
class CustomerHistoryProvider extends AutoDisposeFutureProvider<List<Venda>> {
  /// See also [customerHistory].
  CustomerHistoryProvider(int clienteId)
    : this._internal(
        (ref) => customerHistory(ref as CustomerHistoryRef, clienteId),
        from: customerHistoryProvider,
        name: r'customerHistoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$customerHistoryHash,
        dependencies: CustomerHistoryFamily._dependencies,
        allTransitiveDependencies:
            CustomerHistoryFamily._allTransitiveDependencies,
        clienteId: clienteId,
      );

  CustomerHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clienteId,
  }) : super.internal();

  final int clienteId;

  @override
  Override overrideWith(
    FutureOr<List<Venda>> Function(CustomerHistoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomerHistoryProvider._internal(
        (ref) => create(ref as CustomerHistoryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clienteId: clienteId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<Venda>> createElement() {
    return _CustomerHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerHistoryProvider && other.clienteId == clienteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clienteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomerHistoryRef on AutoDisposeFutureProviderRef<List<Venda>> {
  /// The parameter `clienteId` of this provider.
  int get clienteId;
}

class _CustomerHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<Venda>>
    with CustomerHistoryRef {
  _CustomerHistoryProviderElement(super.provider);

  @override
  int get clienteId => (origin as CustomerHistoryProvider).clienteId;
}

String _$customerAmortizationsHash() =>
    r'9ce3dd71e19eb606f67ca8aaa374025dc2478314';

/// See also [customerAmortizations].
@ProviderFor(customerAmortizations)
const customerAmortizationsProvider = CustomerAmortizationsFamily();

/// See also [customerAmortizations].
class CustomerAmortizationsFamily
    extends Family<AsyncValue<List<AmortizacaoHistorico>>> {
  /// See also [customerAmortizations].
  const CustomerAmortizationsFamily();

  /// See also [customerAmortizations].
  CustomerAmortizationsProvider call(int clienteId) {
    return CustomerAmortizationsProvider(clienteId);
  }

  @override
  CustomerAmortizationsProvider getProviderOverride(
    covariant CustomerAmortizationsProvider provider,
  ) {
    return call(provider.clienteId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'customerAmortizationsProvider';
}

/// See also [customerAmortizations].
class CustomerAmortizationsProvider
    extends AutoDisposeFutureProvider<List<AmortizacaoHistorico>> {
  /// See also [customerAmortizations].
  CustomerAmortizationsProvider(int clienteId)
    : this._internal(
        (ref) =>
            customerAmortizations(ref as CustomerAmortizationsRef, clienteId),
        from: customerAmortizationsProvider,
        name: r'customerAmortizationsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$customerAmortizationsHash,
        dependencies: CustomerAmortizationsFamily._dependencies,
        allTransitiveDependencies:
            CustomerAmortizationsFamily._allTransitiveDependencies,
        clienteId: clienteId,
      );

  CustomerAmortizationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.clienteId,
  }) : super.internal();

  final int clienteId;

  @override
  Override overrideWith(
    FutureOr<List<AmortizacaoHistorico>> Function(
      CustomerAmortizationsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: CustomerAmortizationsProvider._internal(
        (ref) => create(ref as CustomerAmortizationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        clienteId: clienteId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AmortizacaoHistorico>> createElement() {
    return _CustomerAmortizationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CustomerAmortizationsProvider &&
        other.clienteId == clienteId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, clienteId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin CustomerAmortizationsRef
    on AutoDisposeFutureProviderRef<List<AmortizacaoHistorico>> {
  /// The parameter `clienteId` of this provider.
  int get clienteId;
}

class _CustomerAmortizationsProviderElement
    extends AutoDisposeFutureProviderElement<List<AmortizacaoHistorico>>
    with CustomerAmortizationsRef {
  _CustomerAmortizationsProviderElement(super.provider);

  @override
  int get clienteId => (origin as CustomerAmortizationsProvider).clienteId;
}

String _$customerStatsNotifierHash() =>
    r'd6346f05b26fe58001d63a50f1f5fd424f3fe8ba';

/// See also [CustomerStatsNotifier].
@ProviderFor(CustomerStatsNotifier)
final customerStatsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      CustomerStatsNotifier,
      ClienteStats
    >.internal(
      CustomerStatsNotifier.new,
      name: r'customerStatsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$customerStatsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CustomerStatsNotifier = AutoDisposeAsyncNotifier<ClienteStats>;
String _$customersHash() => r'becc1a1be132adde76ee135c66b3ef68ce0ed006';

/// See also [Customers].
@ProviderFor(Customers)
final customersProvider =
    AutoDisposeAsyncNotifierProvider<
      Customers,
      PaginatedCustomersResult
    >.internal(
      Customers.new,
      name: r'customersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$customersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Customers = AutoDisposeAsyncNotifier<PaginatedCustomersResult>;
String _$customerSearchHash() => r'098e982ba279d5aff51ff80efeabce66b09dfa10';

/// See also [CustomerSearch].
@ProviderFor(CustomerSearch)
final customerSearchProvider =
    AutoDisposeNotifierProvider<CustomerSearch, String>.internal(
      CustomerSearch.new,
      name: r'customerSearchProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$customerSearchHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CustomerSearch = AutoDisposeNotifier<String>;
String _$customerInactivesHash() => r'2ba566ea9711805455137ea288b50a2c5b496611';

/// See also [CustomerInactives].
@ProviderFor(CustomerInactives)
final customerInactivesProvider =
    AutoDisposeNotifierProvider<CustomerInactives, bool>.internal(
      CustomerInactives.new,
      name: r'customerInactivesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$customerInactivesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CustomerInactives = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
