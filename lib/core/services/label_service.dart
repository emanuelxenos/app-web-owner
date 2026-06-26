import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:barcode/barcode.dart';
import 'package:intl/intl.dart';
import 'package:unifytechxenoswebowner/domain/models/product.dart';

class LabelService {
  static final _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  /// Gera e abre o diálogo de impressão para etiquetas de um produto
  static Future<void> printProductLabels({
    required Produto product,
    required int quantity,
    double widthMm = 40,
    double heightMm = 25,
  }) async {
    await printMultipleProductLabels(
      productQuantities: [MapEntry(product, quantity)],
      widthMm: widthMm,
      heightMm: heightMm,
    );
  }

  /// Gera etiquetas para múltiplos produtos de uma vez
  static Future<void> printMultipleProductLabels({
    required List<MapEntry<Produto, int>> productQuantities,
    double widthMm = 40,
    double heightMm = 25,
  }) async {
    final pdf = pw.Document();
    
    final font = await PdfGoogleFonts.robotoRegular();
    final fontBold = await PdfGoogleFonts.robotoBold();

    // Criamos uma lista com todas as etiquetas individuais
    final List<pw.Widget> allLabels = [];
    
    for (final entry in productQuantities) {
      final product = entry.key;
      final quantity = entry.value;

      for (var i = 0; i < quantity; i++) {
        allLabels.add(
          pw.Container(
            width: widthMm * PdfPageFormat.mm,
            height: heightMm * PdfPageFormat.mm,
            padding: const pw.EdgeInsets.all(2),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  product.nome.toUpperCase(),
                  style: pw.TextStyle(fontSize: 6, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                  maxLines: 2,
                ),
                pw.SizedBox(height: 1),
                pw.Expanded(
                  child: pw.Center(
                    child: pw.BarcodeWidget(
                      barcode: Barcode.code128(),
                      data: product.codigoBarras ?? product.idProduto.toString(),
                      drawText: false,
                    ),
                  ),
                ),
                pw.SizedBox(height: 1),
                pw.Text(
                  _currencyFormat.format(product.precoVenda),
                  style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                ),
              ],
            ),
          ),
        );
      }
    }

    // Adicionamos as etiquetas em páginas A4 usando Wrap para preencher a folha
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(10 * PdfPageFormat.mm),
        theme: pw.ThemeData.withFont(base: font, bold: fontBold),
        build: (pw.Context context) {
          return [
            pw.Wrap(
              spacing: 2 * PdfPageFormat.mm,
              runSpacing: 2 * PdfPageFormat.mm,
              children: allLabels,
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'Etiquetas_A4_${DateFormat('ddMMyyyy_HHmm').format(DateTime.now())}',
    );
  }

}
