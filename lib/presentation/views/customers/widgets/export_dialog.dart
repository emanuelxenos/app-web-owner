import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:unifytechxenoswebowner/core/theme/app_theme.dart';
import 'package:unifytechxenoswebowner/data/repositories/customer_repository.dart';
import 'package:unifytechxenoswebowner/presentation/widgets/shared_widgets.dart';

class ExportDialog extends ConsumerStatefulWidget {
  final String activeSearch;
  final String? activeTipoPessoa;
  final double? activeLimiteMin;
  final double? activeLimiteMax;
  final bool activeInadimplente;

  const ExportDialog({
    super.key,
    required this.activeSearch,
    this.activeTipoPessoa,
    this.activeLimiteMin,
    this.activeLimiteMax,
    required this.activeInadimplente,
  });

  @override
  ConsumerState<ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends ConsumerState<ExportDialog> {
  String _format = 'csv';
  bool _useActiveFilters = true;
  bool _exporting = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1C2039),
      title: const Row(children: [
        Icon(Icons.download_rounded, color: AppTheme.primaryColor),
        SizedBox(width: 8),
        Text('Exportar Clientes',
            style: TextStyle(color: Colors.white, fontSize: 18)),
      ]),
      content: SizedBox(
        width: 380,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Formato do arquivo:',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 10),
            Row(children: [
              Expanded(
                child: _FormatTile(
                  icon: Icons.table_chart_rounded,
                  label: 'CSV',
                  subtitle: 'Excel / Planilhas',
                  selected: _format == 'csv',
                  color: Colors.green,
                  onTap: () => setState(() => _format = 'csv'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _FormatTile(
                  icon: Icons.picture_as_pdf_rounded,
                  label: 'PDF',
                  subtitle: 'Relatório imprimível',
                  selected: _format == 'pdf',
                  color: Colors.redAccent,
                  onTap: () => setState(() => _format = 'pdf'),
                ),
              ),
            ]),
            const SizedBox(height: 16),
            const Text('Escopo de dados:',
                style: TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 6),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _useActiveFilters,
              activeColor: AppTheme.primaryColor,
              title: const Text('Aplicar filtros ativos',
                  style:
                      TextStyle(color: Colors.white70, fontSize: 13)),
              subtitle: Text(
                _buildFilterDescription(),
                style:
                    const TextStyle(color: Colors.white38, fontSize: 11),
              ),
              onChanged: (v) =>
                  setState(() => _useActiveFilters = v ?? true),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: _exporting ? null : () => Navigator.pop(context),
            child: const Text('Cancelar',
                style: TextStyle(color: Colors.white70))),
        ElevatedButton.icon(
          onPressed: _exporting ? null : _export,
          icon: _exporting
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.download_rounded, size: 16),
          label: Text(_exporting ? 'Exportando...' : 'Exportar $_format'.toUpperCase()),
          style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor),
        ),
      ],
    );
  }

  String _buildFilterDescription() {
    if (!_useActiveFilters) return 'Todos os clientes ativos';
    final parts = <String>[];
    if (widget.activeSearch.isNotEmpty) {
      parts.add('busca: "${widget.activeSearch}"');
    }
    if (widget.activeTipoPessoa != null) {
      parts.add(widget.activeTipoPessoa == 'F'
          ? 'Pessoa Física'
          : 'Pessoa Jurídica');
    }
    if (widget.activeLimiteMin != null || widget.activeLimiteMax != null) {
      parts.add(
          'limite: R\$ ${widget.activeLimiteMin?.toStringAsFixed(0) ?? '0'} – ${widget.activeLimiteMax?.toStringAsFixed(0) ?? '∞'}');
    }
    if (widget.activeInadimplente) parts.add('apenas inadimplentes');
    return parts.isEmpty ? 'Nenhum filtro ativo' : parts.join(' · ');
  }

  Future<void> _export() async {
    setState(() => _exporting = true);
    try {
      String fileName = 'clientes_${DateTime.now().millisecondsSinceEpoch}.$_format';
      String? outputFile = await FilePicker.saveFile(
        dialogTitle: 'Exportar Clientes',
        fileName: fileName,
        type: FileType.custom,
        allowedExtensions: [_format],
      );

      if (outputFile == null) {
        setState(() => _exporting = false);
        return;
      }

      if (!outputFile.endsWith('.$_format')) {
        outputFile += '.$_format';
      }

      final repo = ref.read(customerRepositoryProvider);
      final bytes = await repo.exportarClientes(
        format: _format,
        search: _useActiveFilters ? widget.activeSearch : null,
        tipoPessoa: _useActiveFilters ? widget.activeTipoPessoa : null,
        limiteMin: _useActiveFilters ? widget.activeLimiteMin : null,
        limiteMax: _useActiveFilters ? widget.activeLimiteMax : null,
        inadimplente: _useActiveFilters ? widget.activeInadimplente : false,
      );

      if (bytes.isEmpty) {
        throw Exception('Nenhum dado retornado para exportação.');
      }

      final file = File(outputFile);
      await file.writeAsBytes(bytes);

      if (!mounted) return;
      Navigator.pop(context);
      AppNotifications.showSuccess(context, 'Clientes exportados com sucesso para:\n$outputFile');
    } catch (e) {
      if (mounted) {
        AppNotifications.showError(context, 'Falha ao exportar: ${e.toString()}');
      }
    } finally {
      if (mounted) setState(() => _exporting = false);
    }
  }
}

class _FormatTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool selected;
  final Color color;
  final VoidCallback onTap;
  const _FormatTile(
      {required this.icon,
      required this.label,
      required this.subtitle,
      required this.selected,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? color.withValues(alpha: 0.12)
              : Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: selected ? color : Colors.white12,
              width: selected ? 1.5 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: selected ? color : Colors.white38, size: 22),
            const SizedBox(height: 6),
            Text(label,
                style: TextStyle(
                    color: selected ? color : Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: 14)),
            Text(subtitle,
                style: const TextStyle(
                    color: Colors.white38, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
