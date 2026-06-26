import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unifytechxenoswebowner/data/repositories/finance_repository.dart';
import 'package:unifytechxenoswebowner/domain/models/account_payable.dart';
import 'package:unifytechxenoswebowner/domain/models/account_receivable.dart';
import 'package:unifytechxenoswebowner/domain/models/caixa.dart';
import 'package:unifytechxenoswebowner/domain/models/report.dart';
import 'package:unifytechxenoswebowner/domain/models/pagination.dart';

part 'finance_provider.g.dart';

@riverpod
class AccountsPayable extends _$AccountsPayable {
  int _page = 1;
  final int _limit = 15;

  @override
  Future<PaginatedResponse<ContaPagar>> build() async {
    final filters = ref.watch(financialFiltersProvider);
    return ref.read(financeRepositoryProvider).contasPagar(
      page: _page,
      limit: _limit,
      vencInicio: filters.start?.toString().split(' ')[0],
      vencFim: filters.end?.toString().split(' ')[0],
    );
  }

  void setPage(int page) {
    _page = page;
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<bool> criar(CriarContaPagarRequest request) async {
    try {
      await ref.read(financeRepositoryProvider).criarContaPagar(request);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> pagar(int id, PagarContaRequest request) async {
    try {
      await ref.read(financeRepositoryProvider).pagarConta(id, request);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> excluir(int id) async {
    try {
      await ref.read(financeRepositoryProvider).excluirContaPagar(id);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }
}

@riverpod
class AccountsReceivable extends _$AccountsReceivable {
  int _page = 1;
  final int _limit = 15;

  @override
  Future<PaginatedResponse<ContaReceber>> build() async {
    final filters = ref.watch(financialFiltersProvider);
    return ref.read(financeRepositoryProvider).contasReceber(
      page: _page,
      limit: _limit,
      vencInicio: filters.start?.toString().split(' ')[0],
      vencFim: filters.end?.toString().split(' ')[0],
    );
  }

  void setPage(int page) {
    _page = page;
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  Future<bool> criar(CriarContaReceberRequest request) async {
    try {
      await ref.read(financeRepositoryProvider).criarContaReceber(request);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> receber(int id, ReceberContaRequest request) async {
    try {
      await ref.read(financeRepositoryProvider).receberConta(id, request);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> excluir(int id) async {
    try {
      await ref.read(financeRepositoryProvider).excluirContaReceber(id);
      await refresh();
      return true;
    } catch (_) {
      return false;
    }
  }
}

@riverpod
class CashFlow extends _$CashFlow {
  int _page = 1;
  final int _limit = 15;

  @override
  Future<PaginatedResponse<FluxoCaixaResponse>> build() async {
    final filters = ref.watch(financialFiltersProvider);
    return ref.read(financeRepositoryProvider).fluxoCaixa(
      page: _page,
      limit: _limit,
      dataInicio: filters.start?.toString().split(' ')[0],
      dataFim: filters.end?.toString().split(' ')[0],
    );
  }

  void setPage(int page) {
    _page = page;
    ref.invalidateSelf();
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

@riverpod
class ChartCashFlow extends _$ChartCashFlow {
  @override
  Future<PaginatedResponse<FluxoCaixaResponse>> build() async {
    final filters = ref.watch(financialFiltersProvider);
    return ref.read(financeRepositoryProvider).fluxoCaixa(
      page: 1,
      limit: 100000,
      dataInicio: filters.start?.toString().split(' ')[0],
      dataFim: filters.end?.toString().split(' ')[0],
    );
  }
}

@riverpod
class FinancialFilters extends _$FinancialFilters {
  @override
  ({DateTime? start, DateTime? end}) build() => (start: null, end: null);

  void setRange(DateTime? start, DateTime? end) {
    state = (start: start, end: end);
  }
}
