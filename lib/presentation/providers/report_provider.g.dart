// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$salesReportDayHash() => r'6bc65b4694c6cfcdd43b80eb312a089eaaeaa3a8';

/// See also [SalesReportDay].
@ProviderFor(SalesReportDay)
final salesReportDayProvider =
    AutoDisposeAsyncNotifierProvider<
      SalesReportDay,
      Map<String, dynamic>
    >.internal(
      SalesReportDay.new,
      name: r'salesReportDayProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$salesReportDayHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SalesReportDay = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
String _$salesReportMonthHash() => r'0970dd5b74cd3f1671333aa55331b1ae2e89504a';

/// See also [SalesReportMonth].
@ProviderFor(SalesReportMonth)
final salesReportMonthProvider =
    AutoDisposeAsyncNotifierProvider<
      SalesReportMonth,
      Map<String, dynamic>
    >.internal(
      SalesReportMonth.new,
      name: r'salesReportMonthProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$salesReportMonthHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SalesReportMonth = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
String _$bestSellersHash() => r'c2ca02d8db1acba7e1ca91b365dcbb65dc1223cf';

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

abstract class _$BestSellers
    extends BuildlessAutoDisposeAsyncNotifier<List<Map<String, dynamic>>> {
  late final int? categoriaId;

  FutureOr<List<Map<String, dynamic>>> build({int? categoriaId});
}

/// See also [BestSellers].
@ProviderFor(BestSellers)
const bestSellersProvider = BestSellersFamily();

/// See also [BestSellers].
class BestSellersFamily extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [BestSellers].
  const BestSellersFamily();

  /// See also [BestSellers].
  BestSellersProvider call({int? categoriaId}) {
    return BestSellersProvider(categoriaId: categoriaId);
  }

  @override
  BestSellersProvider getProviderOverride(
    covariant BestSellersProvider provider,
  ) {
    return call(categoriaId: provider.categoriaId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'bestSellersProvider';
}

/// See also [BestSellers].
class BestSellersProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          BestSellers,
          List<Map<String, dynamic>>
        > {
  /// See also [BestSellers].
  BestSellersProvider({int? categoriaId})
    : this._internal(
        () => BestSellers()..categoriaId = categoriaId,
        from: bestSellersProvider,
        name: r'bestSellersProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$bestSellersHash,
        dependencies: BestSellersFamily._dependencies,
        allTransitiveDependencies: BestSellersFamily._allTransitiveDependencies,
        categoriaId: categoriaId,
      );

  BestSellersProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.categoriaId,
  }) : super.internal();

  final int? categoriaId;

  @override
  FutureOr<List<Map<String, dynamic>>> runNotifierBuild(
    covariant BestSellers notifier,
  ) {
    return notifier.build(categoriaId: categoriaId);
  }

  @override
  Override overrideWith(BestSellers Function() create) {
    return ProviderOverride(
      origin: this,
      override: BestSellersProvider._internal(
        () => create()..categoriaId = categoriaId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        categoriaId: categoriaId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    BestSellers,
    List<Map<String, dynamic>>
  >
  createElement() {
    return _BestSellersProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BestSellersProvider && other.categoriaId == categoriaId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, categoriaId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BestSellersRef
    on AutoDisposeAsyncNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `categoriaId` of this provider.
  int? get categoriaId;
}

class _BestSellersProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          BestSellers,
          List<Map<String, dynamic>>
        >
    with BestSellersRef {
  _BestSellersProviderElement(super.provider);

  @override
  int? get categoriaId => (origin as BestSellersProvider).categoriaId;
}

String _$salesReportPeriodHash() => r'6e3d0145dd6cf7215067aa6f58f1cab1ec094870';

abstract class _$SalesReportPeriod
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, dynamic>> {
  late final String dataInicio;
  late final String dataFim;

  FutureOr<Map<String, dynamic>> build(String dataInicio, String dataFim);
}

/// See also [SalesReportPeriod].
@ProviderFor(SalesReportPeriod)
const salesReportPeriodProvider = SalesReportPeriodFamily();

/// See also [SalesReportPeriod].
class SalesReportPeriodFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [SalesReportPeriod].
  const SalesReportPeriodFamily();

  /// See also [SalesReportPeriod].
  SalesReportPeriodProvider call(String dataInicio, String dataFim) {
    return SalesReportPeriodProvider(dataInicio, dataFim);
  }

  @override
  SalesReportPeriodProvider getProviderOverride(
    covariant SalesReportPeriodProvider provider,
  ) {
    return call(provider.dataInicio, provider.dataFim);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'salesReportPeriodProvider';
}

/// See also [SalesReportPeriod].
class SalesReportPeriodProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          SalesReportPeriod,
          Map<String, dynamic>
        > {
  /// See also [SalesReportPeriod].
  SalesReportPeriodProvider(String dataInicio, String dataFim)
    : this._internal(
        () => SalesReportPeriod()
          ..dataInicio = dataInicio
          ..dataFim = dataFim,
        from: salesReportPeriodProvider,
        name: r'salesReportPeriodProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$salesReportPeriodHash,
        dependencies: SalesReportPeriodFamily._dependencies,
        allTransitiveDependencies:
            SalesReportPeriodFamily._allTransitiveDependencies,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );

  SalesReportPeriodProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dataInicio,
    required this.dataFim,
  }) : super.internal();

  final String dataInicio;
  final String dataFim;

  @override
  FutureOr<Map<String, dynamic>> runNotifierBuild(
    covariant SalesReportPeriod notifier,
  ) {
    return notifier.build(dataInicio, dataFim);
  }

  @override
  Override overrideWith(SalesReportPeriod Function() create) {
    return ProviderOverride(
      origin: this,
      override: SalesReportPeriodProvider._internal(
        () => create()
          ..dataInicio = dataInicio
          ..dataFim = dataFim,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dataInicio: dataInicio,
        dataFim: dataFim,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    SalesReportPeriod,
    Map<String, dynamic>
  >
  createElement() {
    return _SalesReportPeriodProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SalesReportPeriodProvider &&
        other.dataInicio == dataInicio &&
        other.dataFim == dataFim;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dataInicio.hashCode);
    hash = _SystemHash.combine(hash, dataFim.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SalesReportPeriodRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `dataInicio` of this provider.
  String get dataInicio;

  /// The parameter `dataFim` of this provider.
  String get dataFim;
}

class _SalesReportPeriodProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          SalesReportPeriod,
          Map<String, dynamic>
        >
    with SalesReportPeriodRef {
  _SalesReportPeriodProviderElement(super.provider);

  @override
  String get dataInicio => (origin as SalesReportPeriodProvider).dataInicio;
  @override
  String get dataFim => (origin as SalesReportPeriodProvider).dataFim;
}

String _$stockReportHash() => r'4e85b257bac399e08004bd0757e325dee582cfaf';

/// See also [StockReport].
@ProviderFor(StockReport)
final stockReportProvider =
    AutoDisposeAsyncNotifierProvider<StockReport, RelatorioEstoque>.internal(
      StockReport.new,
      name: r'stockReportProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$stockReportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$StockReport = AutoDisposeAsyncNotifier<RelatorioEstoque>;
String _$financeReportHash() => r'7086e7036f52f7bcc389efb96800a8f3e8f4f691';

/// See also [FinanceReport].
@ProviderFor(FinanceReport)
final financeReportProvider =
    AutoDisposeAsyncNotifierProvider<
      FinanceReport,
      Map<String, dynamic>
    >.internal(
      FinanceReport.new,
      name: r'financeReportProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$financeReportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$FinanceReport = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
String _$dreReportHash() => r'7f930c99ba78ae399de70bdbed2d6839cda74481';

abstract class _$DreReport
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, dynamic>> {
  late final int? mes;
  late final int? ano;

  FutureOr<Map<String, dynamic>> build({int? mes, int? ano});
}

/// See also [DreReport].
@ProviderFor(DreReport)
const dreReportProvider = DreReportFamily();

/// See also [DreReport].
class DreReportFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [DreReport].
  const DreReportFamily();

  /// See also [DreReport].
  DreReportProvider call({int? mes, int? ano}) {
    return DreReportProvider(mes: mes, ano: ano);
  }

  @override
  DreReportProvider getProviderOverride(covariant DreReportProvider provider) {
    return call(mes: provider.mes, ano: provider.ano);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dreReportProvider';
}

/// See also [DreReport].
class DreReportProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<DreReport, Map<String, dynamic>> {
  /// See also [DreReport].
  DreReportProvider({int? mes, int? ano})
    : this._internal(
        () => DreReport()
          ..mes = mes
          ..ano = ano,
        from: dreReportProvider,
        name: r'dreReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dreReportHash,
        dependencies: DreReportFamily._dependencies,
        allTransitiveDependencies: DreReportFamily._allTransitiveDependencies,
        mes: mes,
        ano: ano,
      );

  DreReportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mes,
    required this.ano,
  }) : super.internal();

  final int? mes;
  final int? ano;

  @override
  FutureOr<Map<String, dynamic>> runNotifierBuild(
    covariant DreReport notifier,
  ) {
    return notifier.build(mes: mes, ano: ano);
  }

  @override
  Override overrideWith(DreReport Function() create) {
    return ProviderOverride(
      origin: this,
      override: DreReportProvider._internal(
        () => create()
          ..mes = mes
          ..ano = ano,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mes: mes,
        ano: ano,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<DreReport, Map<String, dynamic>>
  createElement() {
    return _DreReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DreReportProvider && other.mes == mes && other.ano == ano;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mes.hashCode);
    hash = _SystemHash.combine(hash, ano.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DreReportRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `mes` of this provider.
  int? get mes;

  /// The parameter `ano` of this provider.
  int? get ano;
}

class _DreReportProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<DreReport, Map<String, dynamic>>
    with DreReportRef {
  _DreReportProviderElement(super.provider);

  @override
  int? get mes => (origin as DreReportProvider).mes;
  @override
  int? get ano => (origin as DreReportProvider).ano;
}

String _$inadimplenciaReportHash() =>
    r'4830471950a7eab51c5ba454bfc469da5339aac9';

/// See also [InadimplenciaReport].
@ProviderFor(InadimplenciaReport)
final inadimplenciaReportProvider =
    AutoDisposeAsyncNotifierProvider<
      InadimplenciaReport,
      Map<String, dynamic>
    >.internal(
      InadimplenciaReport.new,
      name: r'inadimplenciaReportProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$inadimplenciaReportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$InadimplenciaReport = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
String _$curvaABCReportHash() => r'04fb3f1a1d7bc1773babb43867e3b31f78f99d08';

/// See also [CurvaABCReport].
@ProviderFor(CurvaABCReport)
final curvaABCReportProvider =
    AutoDisposeAsyncNotifierProvider<
      CurvaABCReport,
      Map<String, dynamic>
    >.internal(
      CurvaABCReport.new,
      name: r'curvaABCReportProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$curvaABCReportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CurvaABCReport = AutoDisposeAsyncNotifier<Map<String, dynamic>>;
String _$comissoesReportHash() => r'1df892c939b29b49f081bec4e77377ffd7201f74';

abstract class _$ComissoesReport
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, dynamic>> {
  late final int? mes;
  late final int? ano;

  FutureOr<Map<String, dynamic>> build({int? mes, int? ano});
}

/// See also [ComissoesReport].
@ProviderFor(ComissoesReport)
const comissoesReportProvider = ComissoesReportFamily();

/// See also [ComissoesReport].
class ComissoesReportFamily extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [ComissoesReport].
  const ComissoesReportFamily();

  /// See also [ComissoesReport].
  ComissoesReportProvider call({int? mes, int? ano}) {
    return ComissoesReportProvider(mes: mes, ano: ano);
  }

  @override
  ComissoesReportProvider getProviderOverride(
    covariant ComissoesReportProvider provider,
  ) {
    return call(mes: provider.mes, ano: provider.ano);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'comissoesReportProvider';
}

/// See also [ComissoesReport].
class ComissoesReportProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ComissoesReport,
          Map<String, dynamic>
        > {
  /// See also [ComissoesReport].
  ComissoesReportProvider({int? mes, int? ano})
    : this._internal(
        () => ComissoesReport()
          ..mes = mes
          ..ano = ano,
        from: comissoesReportProvider,
        name: r'comissoesReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$comissoesReportHash,
        dependencies: ComissoesReportFamily._dependencies,
        allTransitiveDependencies:
            ComissoesReportFamily._allTransitiveDependencies,
        mes: mes,
        ano: ano,
      );

  ComissoesReportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mes,
    required this.ano,
  }) : super.internal();

  final int? mes;
  final int? ano;

  @override
  FutureOr<Map<String, dynamic>> runNotifierBuild(
    covariant ComissoesReport notifier,
  ) {
    return notifier.build(mes: mes, ano: ano);
  }

  @override
  Override overrideWith(ComissoesReport Function() create) {
    return ProviderOverride(
      origin: this,
      override: ComissoesReportProvider._internal(
        () => create()
          ..mes = mes
          ..ano = ano,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mes: mes,
        ano: ano,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ComissoesReport, Map<String, dynamic>>
  createElement() {
    return _ComissoesReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ComissoesReportProvider &&
        other.mes == mes &&
        other.ano == ano;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mes.hashCode);
    hash = _SystemHash.combine(hash, ano.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ComissoesReportRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `mes` of this provider.
  int? get mes;

  /// The parameter `ano` of this provider.
  int? get ano;
}

class _ComissoesReportProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ComissoesReport,
          Map<String, dynamic>
        >
    with ComissoesReportRef {
  _ComissoesReportProviderElement(super.provider);

  @override
  int? get mes => (origin as ComissoesReportProvider).mes;
  @override
  int? get ano => (origin as ComissoesReportProvider).ano;
}

String _$rankingClientesReportHash() =>
    r'0fcd689ff8d7f5b82568e8a05d7b8ce95b2baaaf';

/// See also [RankingClientesReport].
@ProviderFor(RankingClientesReport)
final rankingClientesReportProvider =
    AutoDisposeAsyncNotifierProvider<
      RankingClientesReport,
      List<Map<String, dynamic>>
    >.internal(
      RankingClientesReport.new,
      name: r'rankingClientesReportProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$rankingClientesReportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RankingClientesReport =
    AutoDisposeAsyncNotifier<List<Map<String, dynamic>>>;
String _$clientesInativosReportHash() =>
    r'bf2af77ac12de977595de0cb59a8698ca253c7c0';

/// See also [ClientesInativosReport].
@ProviderFor(ClientesInativosReport)
final clientesInativosReportProvider =
    AutoDisposeAsyncNotifierProvider<
      ClientesInativosReport,
      List<Map<String, dynamic>>
    >.internal(
      ClientesInativosReport.new,
      name: r'clientesInativosReportProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$clientesInativosReportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ClientesInativosReport =
    AutoDisposeAsyncNotifier<List<Map<String, dynamic>>>;
String _$clientesAusentesReportHash() =>
    r'd351a6a75be1b08d06ba856fccb525963a489167';

/// See also [ClientesAusentesReport].
@ProviderFor(ClientesAusentesReport)
final clientesAusentesReportProvider =
    AutoDisposeAsyncNotifierProvider<
      ClientesAusentesReport,
      List<Map<String, dynamic>>
    >.internal(
      ClientesAusentesReport.new,
      name: r'clientesAusentesReportProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$clientesAusentesReportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ClientesAusentesReport =
    AutoDisposeAsyncNotifier<List<Map<String, dynamic>>>;
String _$dreDetalhadoReportHash() =>
    r'43fab50dc745b7048cf03f82cf88a62c4a14abd1';

abstract class _$DreDetalhadoReport
    extends BuildlessAutoDisposeAsyncNotifier<Map<String, dynamic>> {
  late final int? mes;
  late final int? ano;

  FutureOr<Map<String, dynamic>> build({int? mes, int? ano});
}

/// See also [DreDetalhadoReport].
@ProviderFor(DreDetalhadoReport)
const dreDetalhadoReportProvider = DreDetalhadoReportFamily();

/// See also [DreDetalhadoReport].
class DreDetalhadoReportFamily
    extends Family<AsyncValue<Map<String, dynamic>>> {
  /// See also [DreDetalhadoReport].
  const DreDetalhadoReportFamily();

  /// See also [DreDetalhadoReport].
  DreDetalhadoReportProvider call({int? mes, int? ano}) {
    return DreDetalhadoReportProvider(mes: mes, ano: ano);
  }

  @override
  DreDetalhadoReportProvider getProviderOverride(
    covariant DreDetalhadoReportProvider provider,
  ) {
    return call(mes: provider.mes, ano: provider.ano);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dreDetalhadoReportProvider';
}

/// See also [DreDetalhadoReport].
class DreDetalhadoReportProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          DreDetalhadoReport,
          Map<String, dynamic>
        > {
  /// See also [DreDetalhadoReport].
  DreDetalhadoReportProvider({int? mes, int? ano})
    : this._internal(
        () => DreDetalhadoReport()
          ..mes = mes
          ..ano = ano,
        from: dreDetalhadoReportProvider,
        name: r'dreDetalhadoReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dreDetalhadoReportHash,
        dependencies: DreDetalhadoReportFamily._dependencies,
        allTransitiveDependencies:
            DreDetalhadoReportFamily._allTransitiveDependencies,
        mes: mes,
        ano: ano,
      );

  DreDetalhadoReportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mes,
    required this.ano,
  }) : super.internal();

  final int? mes;
  final int? ano;

  @override
  FutureOr<Map<String, dynamic>> runNotifierBuild(
    covariant DreDetalhadoReport notifier,
  ) {
    return notifier.build(mes: mes, ano: ano);
  }

  @override
  Override overrideWith(DreDetalhadoReport Function() create) {
    return ProviderOverride(
      origin: this,
      override: DreDetalhadoReportProvider._internal(
        () => create()
          ..mes = mes
          ..ano = ano,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mes: mes,
        ano: ano,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    DreDetalhadoReport,
    Map<String, dynamic>
  >
  createElement() {
    return _DreDetalhadoReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DreDetalhadoReportProvider &&
        other.mes == mes &&
        other.ano == ano;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mes.hashCode);
    hash = _SystemHash.combine(hash, ano.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DreDetalhadoReportRef
    on AutoDisposeAsyncNotifierProviderRef<Map<String, dynamic>> {
  /// The parameter `mes` of this provider.
  int? get mes;

  /// The parameter `ano` of this provider.
  int? get ano;
}

class _DreDetalhadoReportProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          DreDetalhadoReport,
          Map<String, dynamic>
        >
    with DreDetalhadoReportRef {
  _DreDetalhadoReportProviderElement(super.provider);

  @override
  int? get mes => (origin as DreDetalhadoReportProvider).mes;
  @override
  int? get ano => (origin as DreDetalhadoReportProvider).ano;
}

String _$projecaoCaixaReportHash() =>
    r'b02699b00a8c366eda9aa1df3f2740d4853e3b35';

/// See also [ProjecaoCaixaReport].
@ProviderFor(ProjecaoCaixaReport)
final projecaoCaixaReportProvider =
    AutoDisposeAsyncNotifierProvider<
      ProjecaoCaixaReport,
      List<Map<String, dynamic>>
    >.internal(
      ProjecaoCaixaReport.new,
      name: r'projecaoCaixaReportProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$projecaoCaixaReportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProjecaoCaixaReport =
    AutoDisposeAsyncNotifier<List<Map<String, dynamic>>>;
String _$cancelamentosReportHash() =>
    r'a4149ac11db2961b7863a4787ddc1ecead718a30';

/// See also [CancelamentosReport].
@ProviderFor(CancelamentosReport)
final cancelamentosReportProvider =
    AutoDisposeAsyncNotifierProvider<
      CancelamentosReport,
      List<Map<String, dynamic>>
    >.internal(
      CancelamentosReport.new,
      name: r'cancelamentosReportProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$cancelamentosReportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$CancelamentosReport =
    AutoDisposeAsyncNotifier<List<Map<String, dynamic>>>;
String _$giroEstoqueReportHash() => r'eb031c03c72b9701b913e4cac792f8d06e335f49';

/// See also [GiroEstoqueReport].
@ProviderFor(GiroEstoqueReport)
final giroEstoqueReportProvider =
    AutoDisposeAsyncNotifierProvider<
      GiroEstoqueReport,
      List<Map<String, dynamic>>
    >.internal(
      GiroEstoqueReport.new,
      name: r'giroEstoqueReportProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$giroEstoqueReportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$GiroEstoqueReport =
    AutoDisposeAsyncNotifier<List<Map<String, dynamic>>>;
String _$rupturaEstoqueReportHash() =>
    r'188f14410c3281642894c13a67b1d4c85f4b7e6f';

/// See also [RupturaEstoqueReport].
@ProviderFor(RupturaEstoqueReport)
final rupturaEstoqueReportProvider =
    AutoDisposeAsyncNotifierProvider<
      RupturaEstoqueReport,
      List<Map<String, dynamic>>
    >.internal(
      RupturaEstoqueReport.new,
      name: r'rupturaEstoqueReportProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$rupturaEstoqueReportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RupturaEstoqueReport =
    AutoDisposeAsyncNotifier<List<Map<String, dynamic>>>;
String _$rankingOperadoresReportHash() =>
    r'531233671e8d3ef581d1329ea9a488783aaf0d91';

abstract class _$RankingOperadoresReport
    extends BuildlessAutoDisposeAsyncNotifier<List<Map<String, dynamic>>> {
  late final int? mes;
  late final int? ano;

  FutureOr<List<Map<String, dynamic>>> build({int? mes, int? ano});
}

/// See also [RankingOperadoresReport].
@ProviderFor(RankingOperadoresReport)
const rankingOperadoresReportProvider = RankingOperadoresReportFamily();

/// See also [RankingOperadoresReport].
class RankingOperadoresReportFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [RankingOperadoresReport].
  const RankingOperadoresReportFamily();

  /// See also [RankingOperadoresReport].
  RankingOperadoresReportProvider call({int? mes, int? ano}) {
    return RankingOperadoresReportProvider(mes: mes, ano: ano);
  }

  @override
  RankingOperadoresReportProvider getProviderOverride(
    covariant RankingOperadoresReportProvider provider,
  ) {
    return call(mes: provider.mes, ano: provider.ano);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'rankingOperadoresReportProvider';
}

/// See also [RankingOperadoresReport].
class RankingOperadoresReportProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          RankingOperadoresReport,
          List<Map<String, dynamic>>
        > {
  /// See also [RankingOperadoresReport].
  RankingOperadoresReportProvider({int? mes, int? ano})
    : this._internal(
        () => RankingOperadoresReport()
          ..mes = mes
          ..ano = ano,
        from: rankingOperadoresReportProvider,
        name: r'rankingOperadoresReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$rankingOperadoresReportHash,
        dependencies: RankingOperadoresReportFamily._dependencies,
        allTransitiveDependencies:
            RankingOperadoresReportFamily._allTransitiveDependencies,
        mes: mes,
        ano: ano,
      );

  RankingOperadoresReportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mes,
    required this.ano,
  }) : super.internal();

  final int? mes;
  final int? ano;

  @override
  FutureOr<List<Map<String, dynamic>>> runNotifierBuild(
    covariant RankingOperadoresReport notifier,
  ) {
    return notifier.build(mes: mes, ano: ano);
  }

  @override
  Override overrideWith(RankingOperadoresReport Function() create) {
    return ProviderOverride(
      origin: this,
      override: RankingOperadoresReportProvider._internal(
        () => create()
          ..mes = mes
          ..ano = ano,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mes: mes,
        ano: ano,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    RankingOperadoresReport,
    List<Map<String, dynamic>>
  >
  createElement() {
    return _RankingOperadoresReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RankingOperadoresReportProvider &&
        other.mes == mes &&
        other.ano == ano;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mes.hashCode);
    hash = _SystemHash.combine(hash, ano.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RankingOperadoresReportRef
    on AutoDisposeAsyncNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `mes` of this provider.
  int? get mes;

  /// The parameter `ano` of this provider.
  int? get ano;
}

class _RankingOperadoresReportProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          RankingOperadoresReport,
          List<Map<String, dynamic>>
        >
    with RankingOperadoresReportRef {
  _RankingOperadoresReportProviderElement(super.provider);

  @override
  int? get mes => (origin as RankingOperadoresReportProvider).mes;
  @override
  int? get ano => (origin as RankingOperadoresReportProvider).ano;
}

String _$auditoriaGeralReportHash() =>
    r'a453b445359125751db220703e7d993bad35de6a';

abstract class _$AuditoriaGeralReport
    extends BuildlessAutoDisposeAsyncNotifier<List<Map<String, dynamic>>> {
  late final String? search;

  FutureOr<List<Map<String, dynamic>>> build({String? search});
}

/// See also [AuditoriaGeralReport].
@ProviderFor(AuditoriaGeralReport)
const auditoriaGeralReportProvider = AuditoriaGeralReportFamily();

/// See also [AuditoriaGeralReport].
class AuditoriaGeralReportFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [AuditoriaGeralReport].
  const AuditoriaGeralReportFamily();

  /// See also [AuditoriaGeralReport].
  AuditoriaGeralReportProvider call({String? search}) {
    return AuditoriaGeralReportProvider(search: search);
  }

  @override
  AuditoriaGeralReportProvider getProviderOverride(
    covariant AuditoriaGeralReportProvider provider,
  ) {
    return call(search: provider.search);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'auditoriaGeralReportProvider';
}

/// See also [AuditoriaGeralReport].
class AuditoriaGeralReportProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          AuditoriaGeralReport,
          List<Map<String, dynamic>>
        > {
  /// See also [AuditoriaGeralReport].
  AuditoriaGeralReportProvider({String? search})
    : this._internal(
        () => AuditoriaGeralReport()..search = search,
        from: auditoriaGeralReportProvider,
        name: r'auditoriaGeralReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$auditoriaGeralReportHash,
        dependencies: AuditoriaGeralReportFamily._dependencies,
        allTransitiveDependencies:
            AuditoriaGeralReportFamily._allTransitiveDependencies,
        search: search,
      );

  AuditoriaGeralReportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.search,
  }) : super.internal();

  final String? search;

  @override
  FutureOr<List<Map<String, dynamic>>> runNotifierBuild(
    covariant AuditoriaGeralReport notifier,
  ) {
    return notifier.build(search: search);
  }

  @override
  Override overrideWith(AuditoriaGeralReport Function() create) {
    return ProviderOverride(
      origin: this,
      override: AuditoriaGeralReportProvider._internal(
        () => create()..search = search,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        search: search,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    AuditoriaGeralReport,
    List<Map<String, dynamic>>
  >
  createElement() {
    return _AuditoriaGeralReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AuditoriaGeralReportProvider && other.search == search;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, search.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AuditoriaGeralReportRef
    on AutoDisposeAsyncNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `search` of this provider.
  String? get search;
}

class _AuditoriaGeralReportProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          AuditoriaGeralReport,
          List<Map<String, dynamic>>
        >
    with AuditoriaGeralReportRef {
  _AuditoriaGeralReportProviderElement(super.provider);

  @override
  String? get search => (origin as AuditoriaGeralReportProvider).search;
}

String _$vendasCategoriaReportHash() =>
    r'847da56e8e1b6d5793d3d2cebd11916fbc6e3be3';

abstract class _$VendasCategoriaReport
    extends BuildlessAutoDisposeAsyncNotifier<List<Map<String, dynamic>>> {
  late final int? mes;
  late final int? ano;

  FutureOr<List<Map<String, dynamic>>> build({int? mes, int? ano});
}

/// See also [VendasCategoriaReport].
@ProviderFor(VendasCategoriaReport)
const vendasCategoriaReportProvider = VendasCategoriaReportFamily();

/// See also [VendasCategoriaReport].
class VendasCategoriaReportFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [VendasCategoriaReport].
  const VendasCategoriaReportFamily();

  /// See also [VendasCategoriaReport].
  VendasCategoriaReportProvider call({int? mes, int? ano}) {
    return VendasCategoriaReportProvider(mes: mes, ano: ano);
  }

  @override
  VendasCategoriaReportProvider getProviderOverride(
    covariant VendasCategoriaReportProvider provider,
  ) {
    return call(mes: provider.mes, ano: provider.ano);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'vendasCategoriaReportProvider';
}

/// See also [VendasCategoriaReport].
class VendasCategoriaReportProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          VendasCategoriaReport,
          List<Map<String, dynamic>>
        > {
  /// See also [VendasCategoriaReport].
  VendasCategoriaReportProvider({int? mes, int? ano})
    : this._internal(
        () => VendasCategoriaReport()
          ..mes = mes
          ..ano = ano,
        from: vendasCategoriaReportProvider,
        name: r'vendasCategoriaReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$vendasCategoriaReportHash,
        dependencies: VendasCategoriaReportFamily._dependencies,
        allTransitiveDependencies:
            VendasCategoriaReportFamily._allTransitiveDependencies,
        mes: mes,
        ano: ano,
      );

  VendasCategoriaReportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mes,
    required this.ano,
  }) : super.internal();

  final int? mes;
  final int? ano;

  @override
  FutureOr<List<Map<String, dynamic>>> runNotifierBuild(
    covariant VendasCategoriaReport notifier,
  ) {
    return notifier.build(mes: mes, ano: ano);
  }

  @override
  Override overrideWith(VendasCategoriaReport Function() create) {
    return ProviderOverride(
      origin: this,
      override: VendasCategoriaReportProvider._internal(
        () => create()
          ..mes = mes
          ..ano = ano,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mes: mes,
        ano: ano,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    VendasCategoriaReport,
    List<Map<String, dynamic>>
  >
  createElement() {
    return _VendasCategoriaReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VendasCategoriaReportProvider &&
        other.mes == mes &&
        other.ano == ano;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mes.hashCode);
    hash = _SystemHash.combine(hash, ano.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VendasCategoriaReportRef
    on AutoDisposeAsyncNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `mes` of this provider.
  int? get mes;

  /// The parameter `ano` of this provider.
  int? get ano;
}

class _VendasCategoriaReportProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          VendasCategoriaReport,
          List<Map<String, dynamic>>
        >
    with VendasCategoriaReportRef {
  _VendasCategoriaReportProviderElement(super.provider);

  @override
  int? get mes => (origin as VendasCategoriaReportProvider).mes;
  @override
  int? get ano => (origin as VendasCategoriaReportProvider).ano;
}

String _$contasPagarDetalhadoReportHash() =>
    r'44be40561274b0c3a6ab7263dfe88e939b1ac439';

abstract class _$ContasPagarDetalhadoReport
    extends BuildlessAutoDisposeAsyncNotifier<List<Map<String, dynamic>>> {
  late final String? status;

  FutureOr<List<Map<String, dynamic>>> build({String? status});
}

/// See also [ContasPagarDetalhadoReport].
@ProviderFor(ContasPagarDetalhadoReport)
const contasPagarDetalhadoReportProvider = ContasPagarDetalhadoReportFamily();

/// See also [ContasPagarDetalhadoReport].
class ContasPagarDetalhadoReportFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [ContasPagarDetalhadoReport].
  const ContasPagarDetalhadoReportFamily();

  /// See also [ContasPagarDetalhadoReport].
  ContasPagarDetalhadoReportProvider call({String? status}) {
    return ContasPagarDetalhadoReportProvider(status: status);
  }

  @override
  ContasPagarDetalhadoReportProvider getProviderOverride(
    covariant ContasPagarDetalhadoReportProvider provider,
  ) {
    return call(status: provider.status);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'contasPagarDetalhadoReportProvider';
}

/// See also [ContasPagarDetalhadoReport].
class ContasPagarDetalhadoReportProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ContasPagarDetalhadoReport,
          List<Map<String, dynamic>>
        > {
  /// See also [ContasPagarDetalhadoReport].
  ContasPagarDetalhadoReportProvider({String? status})
    : this._internal(
        () => ContasPagarDetalhadoReport()..status = status,
        from: contasPagarDetalhadoReportProvider,
        name: r'contasPagarDetalhadoReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$contasPagarDetalhadoReportHash,
        dependencies: ContasPagarDetalhadoReportFamily._dependencies,
        allTransitiveDependencies:
            ContasPagarDetalhadoReportFamily._allTransitiveDependencies,
        status: status,
      );

  ContasPagarDetalhadoReportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.status,
  }) : super.internal();

  final String? status;

  @override
  FutureOr<List<Map<String, dynamic>>> runNotifierBuild(
    covariant ContasPagarDetalhadoReport notifier,
  ) {
    return notifier.build(status: status);
  }

  @override
  Override overrideWith(ContasPagarDetalhadoReport Function() create) {
    return ProviderOverride(
      origin: this,
      override: ContasPagarDetalhadoReportProvider._internal(
        () => create()..status = status,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        status: status,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    ContasPagarDetalhadoReport,
    List<Map<String, dynamic>>
  >
  createElement() {
    return _ContasPagarDetalhadoReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ContasPagarDetalhadoReportProvider &&
        other.status == status;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, status.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ContasPagarDetalhadoReportRef
    on AutoDisposeAsyncNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `status` of this provider.
  String? get status;
}

class _ContasPagarDetalhadoReportProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ContasPagarDetalhadoReport,
          List<Map<String, dynamic>>
        >
    with ContasPagarDetalhadoReportRef {
  _ContasPagarDetalhadoReportProviderElement(super.provider);

  @override
  String? get status => (origin as ContasPagarDetalhadoReportProvider).status;
}

String _$produtosMargemReportHash() =>
    r'330760f23322e4759ecc882dae8a9ba76f1a8795';

/// See also [ProdutosMargemReport].
@ProviderFor(ProdutosMargemReport)
final produtosMargemReportProvider =
    AutoDisposeAsyncNotifierProvider<
      ProdutosMargemReport,
      List<Map<String, dynamic>>
    >.internal(
      ProdutosMargemReport.new,
      name: r'produtosMargemReportProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$produtosMargemReportHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProdutosMargemReport =
    AutoDisposeAsyncNotifier<List<Map<String, dynamic>>>;
String _$vendasFluxoHorarioReportHash() =>
    r'4dbf8af1aee8ab861e60d12de432d3a59d1ba9e9';

abstract class _$VendasFluxoHorarioReport
    extends BuildlessAutoDisposeAsyncNotifier<List<Map<String, dynamic>>> {
  late final String? dataInicio;
  late final String? dataFim;

  FutureOr<List<Map<String, dynamic>>> build({
    String? dataInicio,
    String? dataFim,
  });
}

/// See also [VendasFluxoHorarioReport].
@ProviderFor(VendasFluxoHorarioReport)
const vendasFluxoHorarioReportProvider = VendasFluxoHorarioReportFamily();

/// See also [VendasFluxoHorarioReport].
class VendasFluxoHorarioReportFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [VendasFluxoHorarioReport].
  const VendasFluxoHorarioReportFamily();

  /// See also [VendasFluxoHorarioReport].
  VendasFluxoHorarioReportProvider call({String? dataInicio, String? dataFim}) {
    return VendasFluxoHorarioReportProvider(
      dataInicio: dataInicio,
      dataFim: dataFim,
    );
  }

  @override
  VendasFluxoHorarioReportProvider getProviderOverride(
    covariant VendasFluxoHorarioReportProvider provider,
  ) {
    return call(dataInicio: provider.dataInicio, dataFim: provider.dataFim);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'vendasFluxoHorarioReportProvider';
}

/// See also [VendasFluxoHorarioReport].
class VendasFluxoHorarioReportProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          VendasFluxoHorarioReport,
          List<Map<String, dynamic>>
        > {
  /// See also [VendasFluxoHorarioReport].
  VendasFluxoHorarioReportProvider({String? dataInicio, String? dataFim})
    : this._internal(
        () => VendasFluxoHorarioReport()
          ..dataInicio = dataInicio
          ..dataFim = dataFim,
        from: vendasFluxoHorarioReportProvider,
        name: r'vendasFluxoHorarioReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$vendasFluxoHorarioReportHash,
        dependencies: VendasFluxoHorarioReportFamily._dependencies,
        allTransitiveDependencies:
            VendasFluxoHorarioReportFamily._allTransitiveDependencies,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );

  VendasFluxoHorarioReportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dataInicio,
    required this.dataFim,
  }) : super.internal();

  final String? dataInicio;
  final String? dataFim;

  @override
  FutureOr<List<Map<String, dynamic>>> runNotifierBuild(
    covariant VendasFluxoHorarioReport notifier,
  ) {
    return notifier.build(dataInicio: dataInicio, dataFim: dataFim);
  }

  @override
  Override overrideWith(VendasFluxoHorarioReport Function() create) {
    return ProviderOverride(
      origin: this,
      override: VendasFluxoHorarioReportProvider._internal(
        () => create()
          ..dataInicio = dataInicio
          ..dataFim = dataFim,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dataInicio: dataInicio,
        dataFim: dataFim,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    VendasFluxoHorarioReport,
    List<Map<String, dynamic>>
  >
  createElement() {
    return _VendasFluxoHorarioReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VendasFluxoHorarioReportProvider &&
        other.dataInicio == dataInicio &&
        other.dataFim == dataFim;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dataInicio.hashCode);
    hash = _SystemHash.combine(hash, dataFim.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VendasFluxoHorarioReportRef
    on AutoDisposeAsyncNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `dataInicio` of this provider.
  String? get dataInicio;

  /// The parameter `dataFim` of this provider.
  String? get dataFim;
}

class _VendasFluxoHorarioReportProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          VendasFluxoHorarioReport,
          List<Map<String, dynamic>>
        >
    with VendasFluxoHorarioReportRef {
  _VendasFluxoHorarioReportProviderElement(super.provider);

  @override
  String? get dataInicio =>
      (origin as VendasFluxoHorarioReportProvider).dataInicio;
  @override
  String? get dataFim => (origin as VendasFluxoHorarioReportProvider).dataFim;
}

String _$vendasMeiosPagamentoReportHash() =>
    r'710772a9a1cbe1f53b0afa00438da92442da4e4f';

abstract class _$VendasMeiosPagamentoReport
    extends BuildlessAutoDisposeAsyncNotifier<List<Map<String, dynamic>>> {
  late final String? dataInicio;
  late final String? dataFim;

  FutureOr<List<Map<String, dynamic>>> build({
    String? dataInicio,
    String? dataFim,
  });
}

/// See also [VendasMeiosPagamentoReport].
@ProviderFor(VendasMeiosPagamentoReport)
const vendasMeiosPagamentoReportProvider = VendasMeiosPagamentoReportFamily();

/// See also [VendasMeiosPagamentoReport].
class VendasMeiosPagamentoReportFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [VendasMeiosPagamentoReport].
  const VendasMeiosPagamentoReportFamily();

  /// See also [VendasMeiosPagamentoReport].
  VendasMeiosPagamentoReportProvider call({
    String? dataInicio,
    String? dataFim,
  }) {
    return VendasMeiosPagamentoReportProvider(
      dataInicio: dataInicio,
      dataFim: dataFim,
    );
  }

  @override
  VendasMeiosPagamentoReportProvider getProviderOverride(
    covariant VendasMeiosPagamentoReportProvider provider,
  ) {
    return call(dataInicio: provider.dataInicio, dataFim: provider.dataFim);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'vendasMeiosPagamentoReportProvider';
}

/// See also [VendasMeiosPagamentoReport].
class VendasMeiosPagamentoReportProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          VendasMeiosPagamentoReport,
          List<Map<String, dynamic>>
        > {
  /// See also [VendasMeiosPagamentoReport].
  VendasMeiosPagamentoReportProvider({String? dataInicio, String? dataFim})
    : this._internal(
        () => VendasMeiosPagamentoReport()
          ..dataInicio = dataInicio
          ..dataFim = dataFim,
        from: vendasMeiosPagamentoReportProvider,
        name: r'vendasMeiosPagamentoReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$vendasMeiosPagamentoReportHash,
        dependencies: VendasMeiosPagamentoReportFamily._dependencies,
        allTransitiveDependencies:
            VendasMeiosPagamentoReportFamily._allTransitiveDependencies,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );

  VendasMeiosPagamentoReportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dataInicio,
    required this.dataFim,
  }) : super.internal();

  final String? dataInicio;
  final String? dataFim;

  @override
  FutureOr<List<Map<String, dynamic>>> runNotifierBuild(
    covariant VendasMeiosPagamentoReport notifier,
  ) {
    return notifier.build(dataInicio: dataInicio, dataFim: dataFim);
  }

  @override
  Override overrideWith(VendasMeiosPagamentoReport Function() create) {
    return ProviderOverride(
      origin: this,
      override: VendasMeiosPagamentoReportProvider._internal(
        () => create()
          ..dataInicio = dataInicio
          ..dataFim = dataFim,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dataInicio: dataInicio,
        dataFim: dataFim,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    VendasMeiosPagamentoReport,
    List<Map<String, dynamic>>
  >
  createElement() {
    return _VendasMeiosPagamentoReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VendasMeiosPagamentoReportProvider &&
        other.dataInicio == dataInicio &&
        other.dataFim == dataFim;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dataInicio.hashCode);
    hash = _SystemHash.combine(hash, dataFim.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VendasMeiosPagamentoReportRef
    on AutoDisposeAsyncNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `dataInicio` of this provider.
  String? get dataInicio;

  /// The parameter `dataFim` of this provider.
  String? get dataFim;
}

class _VendasMeiosPagamentoReportProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          VendasMeiosPagamentoReport,
          List<Map<String, dynamic>>
        >
    with VendasMeiosPagamentoReportRef {
  _VendasMeiosPagamentoReportProviderElement(super.provider);

  @override
  String? get dataInicio =>
      (origin as VendasMeiosPagamentoReportProvider).dataInicio;
  @override
  String? get dataFim => (origin as VendasMeiosPagamentoReportProvider).dataFim;
}

String _$comprasVendasReportHash() =>
    r'866071fc4ec270d5c8ecdd48841a1cff1b3bcfed';

abstract class _$ComprasVendasReport
    extends BuildlessAutoDisposeAsyncNotifier<List<Map<String, dynamic>>> {
  late final String? dataInicio;
  late final String? dataFim;

  FutureOr<List<Map<String, dynamic>>> build({
    String? dataInicio,
    String? dataFim,
  });
}

/// See also [ComprasVendasReport].
@ProviderFor(ComprasVendasReport)
const comprasVendasReportProvider = ComprasVendasReportFamily();

/// See also [ComprasVendasReport].
class ComprasVendasReportFamily
    extends Family<AsyncValue<List<Map<String, dynamic>>>> {
  /// See also [ComprasVendasReport].
  const ComprasVendasReportFamily();

  /// See also [ComprasVendasReport].
  ComprasVendasReportProvider call({String? dataInicio, String? dataFim}) {
    return ComprasVendasReportProvider(
      dataInicio: dataInicio,
      dataFim: dataFim,
    );
  }

  @override
  ComprasVendasReportProvider getProviderOverride(
    covariant ComprasVendasReportProvider provider,
  ) {
    return call(dataInicio: provider.dataInicio, dataFim: provider.dataFim);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'comprasVendasReportProvider';
}

/// See also [ComprasVendasReport].
class ComprasVendasReportProvider
    extends
        AutoDisposeAsyncNotifierProviderImpl<
          ComprasVendasReport,
          List<Map<String, dynamic>>
        > {
  /// See also [ComprasVendasReport].
  ComprasVendasReportProvider({String? dataInicio, String? dataFim})
    : this._internal(
        () => ComprasVendasReport()
          ..dataInicio = dataInicio
          ..dataFim = dataFim,
        from: comprasVendasReportProvider,
        name: r'comprasVendasReportProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$comprasVendasReportHash,
        dependencies: ComprasVendasReportFamily._dependencies,
        allTransitiveDependencies:
            ComprasVendasReportFamily._allTransitiveDependencies,
        dataInicio: dataInicio,
        dataFim: dataFim,
      );

  ComprasVendasReportProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.dataInicio,
    required this.dataFim,
  }) : super.internal();

  final String? dataInicio;
  final String? dataFim;

  @override
  FutureOr<List<Map<String, dynamic>>> runNotifierBuild(
    covariant ComprasVendasReport notifier,
  ) {
    return notifier.build(dataInicio: dataInicio, dataFim: dataFim);
  }

  @override
  Override overrideWith(ComprasVendasReport Function() create) {
    return ProviderOverride(
      origin: this,
      override: ComprasVendasReportProvider._internal(
        () => create()
          ..dataInicio = dataInicio
          ..dataFim = dataFim,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        dataInicio: dataInicio,
        dataFim: dataFim,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<
    ComprasVendasReport,
    List<Map<String, dynamic>>
  >
  createElement() {
    return _ComprasVendasReportProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ComprasVendasReportProvider &&
        other.dataInicio == dataInicio &&
        other.dataFim == dataFim;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, dataInicio.hashCode);
    hash = _SystemHash.combine(hash, dataFim.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ComprasVendasReportRef
    on AutoDisposeAsyncNotifierProviderRef<List<Map<String, dynamic>>> {
  /// The parameter `dataInicio` of this provider.
  String? get dataInicio;

  /// The parameter `dataFim` of this provider.
  String? get dataFim;
}

class _ComprasVendasReportProviderElement
    extends
        AutoDisposeAsyncNotifierProviderElement<
          ComprasVendasReport,
          List<Map<String, dynamic>>
        >
    with ComprasVendasReportRef {
  _ComprasVendasReportProviderElement(super.provider);

  @override
  String? get dataInicio => (origin as ComprasVendasReportProvider).dataInicio;
  @override
  String? get dataFim => (origin as ComprasVendasReportProvider).dataFim;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
