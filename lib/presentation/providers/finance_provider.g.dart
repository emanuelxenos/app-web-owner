// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$accountsPayableHash() => r'7497fa32ffb348c3f7a1563629c7c42149bba7a7';

/// See also [AccountsPayable].
@ProviderFor(AccountsPayable)
final accountsPayableProvider =
    AutoDisposeAsyncNotifierProvider<
      AccountsPayable,
      PaginatedResponse<ContaPagar>
    >.internal(
      AccountsPayable.new,
      name: r'accountsPayableProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$accountsPayableHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AccountsPayable =
    AutoDisposeAsyncNotifier<PaginatedResponse<ContaPagar>>;
String _$accountsReceivableHash() =>
    r'024e247a56cd600ab51291b85198f76e084a5b7a';

/// See also [AccountsReceivable].
@ProviderFor(AccountsReceivable)
final accountsReceivableProvider =
    AutoDisposeAsyncNotifierProvider<
      AccountsReceivable,
      PaginatedResponse<ContaReceber>
    >.internal(
      AccountsReceivable.new,
      name: r'accountsReceivableProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$accountsReceivableHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$AccountsReceivable =
    AutoDisposeAsyncNotifier<PaginatedResponse<ContaReceber>>;
String _$cashFlowHash() => r'a03390a17656d4b85061a5d87ba7d37cd5a3363e';

/// See also [CashFlow].
@ProviderFor(CashFlow)
final cashFlowProvider =
    AutoDisposeAsyncNotifierProvider<
      CashFlow,
      PaginatedResponse<FluxoCaixaResponse>
    >.internal(
      CashFlow.new,
      name: r'cashFlowProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cashFlowHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CashFlow =
    AutoDisposeAsyncNotifier<PaginatedResponse<FluxoCaixaResponse>>;
String _$chartCashFlowHash() => r'b0aae72118690be2d06c3b97b5e3c2729451da78';

/// See also [ChartCashFlow].
@ProviderFor(ChartCashFlow)
final chartCashFlowProvider =
    AutoDisposeAsyncNotifierProvider<
      ChartCashFlow,
      PaginatedResponse<FluxoCaixaResponse>
    >.internal(
      ChartCashFlow.new,
      name: r'chartCashFlowProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$chartCashFlowHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChartCashFlow =
    AutoDisposeAsyncNotifier<PaginatedResponse<FluxoCaixaResponse>>;
String _$financialFiltersHash() => r'bee4da4f953cc0d05ff63ca39598a779d361a140';

/// See also [FinancialFilters].
@ProviderFor(FinancialFilters)
final financialFiltersProvider =
    AutoDisposeNotifierProvider<
      FinancialFilters,
      ({DateTime? start, DateTime? end})
    >.internal(
      FinancialFilters.new,
      name: r'financialFiltersProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$financialFiltersHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FinancialFilters =
    AutoDisposeNotifier<({DateTime? start, DateTime? end})>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
