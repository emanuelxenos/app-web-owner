import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:unifytechxenoswebowner/core/utils/formatters.dart';
import 'package:unifytechxenoswebowner/domain/models/sale.dart';

class ReceiptPrinterService {
  static Future<void> printReceipt(Venda venda) async {
    final pdf = pw.Document();
    
    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    // 80mm roll paper width is approx 80mm, with some margins.
    final pageFormat = PdfPageFormat.roll80;

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.all(16),
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text(
                'UNIFY TECH XENOS',
                style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 8),
              pw.Text('Recibo de Venda', style: pw.TextStyle(fontSize: 12)),
              pw.Text('Nº: ${venda.numeroVenda}', style: pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 16),
              
              _buildRow('Data:', Formatters.dateTime(venda.dataVenda)),
              _buildRow('Operador:', venda.operadorNome ?? '-'),
              _buildRow('Status:', venda.status.toUpperCase()),
              
              pw.Divider(thickness: 1, color: PdfColors.grey500),
              
              pw.Text('ITENS DA VENDA', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.SizedBox(height: 8),
              
              ...venda.itens.map((item) {
                return pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(item.produtoNome ?? 'Produto', style: const pw.TextStyle(fontSize: 10)),
                            pw.Text('${Formatters.quantity(item.quantidade)} ${item.unidadeVenda} x ${Formatters.currency(item.precoUnitario)}', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey700)),
                          ],
                        ),
                      ),
                      pw.Text(Formatters.currency(item.valorLiquido), style: const pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                );
              }),
              
              pw.Divider(thickness: 1, color: PdfColors.grey500),
              
              _buildRow('Subtotal:', Formatters.currency(venda.valorTotalProdutos)),
              if (venda.valorTotalDescontos > 0)
                _buildRow('Descontos:', Formatters.currency(venda.valorTotalDescontos)),
              
              pw.SizedBox(height: 4),
              _buildRow('TOTAL:', Formatters.currency(venda.valorTotal), isBold: true, fontSize: 14),
              
              pw.Divider(thickness: 1, color: PdfColors.grey500),
              
              pw.SizedBox(height: 4),
              pw.Text('PAGAMENTOS', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.SizedBox(height: 4),
              
              ...venda.pagamentos.map((p) => _buildRow(p.formaPagamentoNome ?? 'Pagamento:', Formatters.currency(p.valor))),
              if (venda.valorTroco > 0)
                _buildRow('Troco:', Formatters.currency(venda.valorTroco)),
                
              pw.SizedBox(height: 24),
              pw.Text('Obrigado pela preferência!', textAlign: pw.TextAlign.center, style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
              pw.Text('unifytechxenos.com.br', textAlign: pw.TextAlign.center, style: const pw.TextStyle(fontSize: 8)),
              pw.SizedBox(height: 16),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Recibo_Venda_${venda.numeroVenda}',
    );
  }

  static pw.Widget _buildRow(String label, String value, {bool isBold = false, double fontSize = 10}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: fontSize, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: fontSize, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
          ),
        ],
      ),
    );
  }

  static Future<void> printTextDANFE(String rawText, String chave) async {
    final pdf = pw.Document();
    final font = await PdfGoogleFonts.courierPrimeRegular();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        theme: pw.ThemeData.withFont(base: font),
        build: (pw.Context context) {
          return [
            pw.Text(
              rawText,
              style: const pw.TextStyle(fontSize: 10, height: 1.2),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'DANFE_NFe_${chave.replaceAll(" ", "")}',
    );
  }
}
