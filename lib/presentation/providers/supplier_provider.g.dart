// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredSuppliersHash() => r'b35e3a83bd509c18529603a34c70e7aec141009f';

/// See also [filteredSuppliers].
@ProviderFor(filteredSuppliers)
final filteredSuppliersProvider =
    AutoDisposeProvider<List<Fornecedor>>.internal(
      filteredSuppliers,
      name: r'filteredSuppliersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$filteredSuppliersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef FilteredSuppliersRef = AutoDisposeProviderRef<List<Fornecedor>>;
String _$paginatedFilteredSuppliersHash() =>
    r'70ed7e368b2be10d48cba4ad50c087c30ff6af72';

/// See also [paginatedFilteredSuppliers].
@ProviderFor(paginatedFilteredSuppliers)
final paginatedFilteredSuppliersProvider =
    AutoDisposeProvider<List<Fornecedor>>.internal(
      paginatedFilteredSuppliers,
      name: r'paginatedFilteredSuppliersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paginatedFilteredSuppliersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef PaginatedFilteredSuppliersRef =
    AutoDisposeProviderRef<List<Fornecedor>>;
String _$suppliersHash() => r'6f5a043d3271594fefbc3d27a122184d2d74c917';

/// See also [Suppliers].
@ProviderFor(Suppliers)
final suppliersProvider =
    AutoDisposeAsyncNotifierProvider<Suppliers, List<Fornecedor>>.internal(
      Suppliers.new,
      name: r'suppliersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$suppliersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$Suppliers = AutoDisposeAsyncNotifier<List<Fornecedor>>;
String _$supplierPaginationStateHash() =>
    r'05209273c0b4a103727d0dd842d763a03984215b';

/// See also [SupplierPaginationState].
@ProviderFor(SupplierPaginationState)
final supplierPaginationStateProvider =
    AutoDisposeNotifierProvider<
      SupplierPaginationState,
      SupplierPaginationFilters
    >.internal(
      SupplierPaginationState.new,
      name: r'supplierPaginationStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$supplierPaginationStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SupplierPaginationState =
    AutoDisposeNotifier<SupplierPaginationFilters>;
String _$supplierSearchHash() => r'42a42e5db305969a5a8e29ef05453d74d5ef5b12';

/// See also [SupplierSearch].
@ProviderFor(SupplierSearch)
final supplierSearchProvider =
    AutoDisposeNotifierProvider<SupplierSearch, String>.internal(
      SupplierSearch.new,
      name: r'supplierSearchProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$supplierSearchHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SupplierSearch = AutoDisposeNotifier<String>;
String _$supplierInactivesHash() => r'9e09fb0b0e76cd97dbd1796cee44d49d27b46c72';

/// See also [SupplierInactives].
@ProviderFor(SupplierInactives)
final supplierInactivesProvider =
    AutoDisposeNotifierProvider<SupplierInactives, bool>.internal(
      SupplierInactives.new,
      name: r'supplierInactivesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$supplierInactivesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SupplierInactives = AutoDisposeNotifier<bool>;
String _$selectedSupplierAnalyticsHash() =>
    r'cc22479e72e8e966bf3996058a8c87361391303d';

/// See also [SelectedSupplierAnalytics].
@ProviderFor(SelectedSupplierAnalytics)
final selectedSupplierAnalyticsProvider =
    NotifierProvider<SelectedSupplierAnalytics, int?>.internal(
      SelectedSupplierAnalytics.new,
      name: r'selectedSupplierAnalyticsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$selectedSupplierAnalyticsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SelectedSupplierAnalytics = Notifier<int?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
