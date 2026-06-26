import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/domain/models/customer.dart';
import 'package:unifytechxenoswebowner/presentation/providers/customer_provider.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart'; // for StatusChip
import 'package:unifytechxenoswebowner/presentation/views/customers/utils/customer_utils.dart';

class CustomerDetailsDrawer extends ConsumerWidget {
  final Cliente cliente;
  const CustomerDetailsDrawer({super.key, required this.cliente});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync =
        ref.watch(customerHistoryProvider(cliente.idCliente));

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding:
          const EdgeInsets.only(left: 0, top: 0, bottom: 0, right: 0),
      alignment: Alignment.centerRight,
      child: Container(
        width: 420,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0xFF1A1D38),
          border: Border(
              left: BorderSide(color: Color(0xFF2A2D50), width: 1)),
        ),
        child: Column(children: [
          // Header
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryColor.withValues(alpha: 0.25),
                  AppTheme.primaryColor.withValues(alpha: 0.05),
                ],
              ),
              border: const Border(
                  bottom: BorderSide(color: Color(0xFF2A2D50))),
            ),
            child: Row(children: [
              CircleAvatar(
                backgroundColor:
                    AppTheme.primaryColor.withValues(alpha: 0.2),
                radius: 24,
                child: Text(
                  cliente.nome.isNotEmpty
                      ? cliente.nome[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(cliente.nome,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 2),
                    StatusChip.fromStatus(
                        cliente.ativo ? 'ativo' : 'inativo'),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white54),
                onPressed: () => Navigator.pop(context),
              ),
            ]),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact & Identification
                  _SectionHeader('Identificação & Contato'),
                  const SizedBox(height: 10),
                  _InfoRow(icon: Icons.person_outline,
                      label: 'Tipo',
                      value: cliente.tipoPessoa == 'J'
                          ? 'Pessoa Jurídica'
                          : 'Pessoa Física'),
                  if (cliente.cpfCnpj != null && cliente.cpfCnpj!.isNotEmpty)
                    _InfoRow(
                        icon: Icons.badge_outlined,
                        label: cliente.tipoPessoa == 'J' ? 'CNPJ' : 'CPF',
                        value: formatDocumento(
                            cliente.tipoPessoa, cliente.cpfCnpj)),
                  if (cliente.telefone != null &&
                      cliente.telefone!.isNotEmpty)
                    _InfoRow(
                        icon: Icons.phone_outlined,
                        label: 'Telefone',
                        value: cliente.telefone!),
                  if (cliente.email != null && cliente.email!.isNotEmpty)
                    _InfoRow(
                        icon: Icons.email_outlined,
                        label: 'Email',
                        value: cliente.email!),
                  if (cliente.dataCadastro != null)
                    _InfoRow(
                        icon: Icons.calendar_today_outlined,
                        label: 'Cadastrado em',
                        value:
                            '${cliente.dataCadastro!.day.toString().padLeft(2, '0')}/${cliente.dataCadastro!.month.toString().padLeft(2, '0')}/${cliente.dataCadastro!.year}'),

                  const SizedBox(height: 20),

                  // Credit & Debt
                  _SectionHeader('Situação Financeira'),
                  const SizedBox(height: 10),
                  _CreditBar(
                      limiteCredito: cliente.limiteCredito,
                      saldoDevedor: cliente.saldoDevedor),
                  const SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                        child: _FinancialCard(
                      label: 'Limite de Crédito',
                      value:
                          'R\$ ${cliente.limiteCredito.toStringAsFixed(2)}',
                      color: Colors.green,
                      icon: Icons.credit_card_rounded,
                    )),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _FinancialCard(
                      label: 'Saldo Devedor',
                      value:
                          'R\$ ${cliente.saldoDevedor.toStringAsFixed(2)}',
                      color: cliente.saldoDevedor > 0
                          ? AppTheme.accentRed
                          : Colors.green,
                      icon: Icons.money_off_rounded,
                    )),
                  ]),

                  const SizedBox(height: 20),

                  // Purchase History (last 5)
                  _SectionHeader('Últimas Compras'),
                  const SizedBox(height: 10),
                  historyAsync.when(
                    loading: () => const Center(
                        child: Padding(
                            padding: EdgeInsets.all(20),
                            child: CircularProgressIndicator())),
                    error: (e, _) => Text('Erro: $e',
                        style: const TextStyle(
                            color: AppTheme.accentRed, fontSize: 12)),
                    data: (vendas) {
                      if (vendas.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text('Nenhuma compra registrada.',
                              style: TextStyle(
                                  color: Colors.white54, fontSize: 13)),
                        );
                      }
                      final recent = vendas.take(5).toList();
                      return Column(
                        children: recent.map((v) {
                          final saldo = v.valorTotal - v.valorPago;
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color:
                                  Colors.white.withValues(alpha: 0.04),
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: Colors.white12),
                            ),
                            child: Row(children: [
                              Icon(
                                saldo > 0
                                    ? Icons.pending_outlined
                                    : Icons.check_circle_outline,
                                color: saldo > 0
                                    ? Colors.orange
                                    : Colors.green,
                                size: 16,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(v.numeroVenda,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12)),
                                    Text(
                                      '${v.dataVenda.day.toString().padLeft(2, '0')}/${v.dataVenda.month.toString().padLeft(2, '0')}/${v.dataVenda.year}',
                                      style: const TextStyle(
                                          color: Colors.white38,
                                          fontSize: 11),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'R\$ ${v.valorTotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  if (saldo > 0)
                                    Text(
                                      'Falta: R\$ ${saldo.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          color: AppTheme.accentRed,
                                          fontSize: 10),
                                    ),
                                ],
                              ),
                            ]),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.07))),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(title.toUpperCase(),
            style: const TextStyle(
                color: Colors.white38,
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600)),
      ),
      Expanded(
          child: Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.07))),
    ]);
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoRow(
      {required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        Icon(icon, color: Colors.white38, size: 15),
        const SizedBox(width: 8),
        Text('$label: ',
            style: const TextStyle(color: Colors.white54, fontSize: 12)),
        Expanded(
            child: Text(value,
                style: const TextStyle(
                    color: Colors.white, fontSize: 12),
                overflow: TextOverflow.ellipsis)),
      ]),
    );
  }
}

class _FinancialCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;
  const _FinancialCard(
      {required this.label,
      required this.value,
      required this.color,
      required this.icon});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(height: 6),
          Text(label,
              style: const TextStyle(
                  color: Colors.white54, fontSize: 10)),
          const SizedBox(height: 2),
          Text(value,
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ],
      ),
    );
  }
}

class _CreditBar extends StatelessWidget {
  final double limiteCredito;
  final double saldoDevedor;
  const _CreditBar(
      {required this.limiteCredito, required this.saldoDevedor});
  @override
  Widget build(BuildContext context) {
    final ratio = limiteCredito > 0
        ? (saldoDevedor / limiteCredito).clamp(0.0, 1.0)
        : 0.0;
    final color = ratio > 0.8
        ? AppTheme.accentRed
        : ratio > 0.5
            ? Colors.orange
            : Colors.green;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Uso do limite: ${(ratio * 100).toStringAsFixed(0)}%',
                style:
                    TextStyle(color: color, fontSize: 11)),
            Text(
                '${saldoDevedor.toStringAsFixed(0)} / ${limiteCredito.toStringAsFixed(0)}',
                style: const TextStyle(
                    color: Colors.white54, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: Colors.white.withValues(alpha: 0.08),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
