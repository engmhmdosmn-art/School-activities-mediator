import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/project_idea.dart';
import '../models/poster_template.dart';

/// Generates real, print-ready PDF documents and hands them to the Android
/// system print dialog (or share sheet) via the `printing` package.
class PdfService {
  static Future<Uint8List> buildProjectWorksheet({
    required ProjectIdea idea,
    required String childName,
  }) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('الوسيط المدرسي والأنشطة', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey600)),
                pw.SizedBox(height: 6),
                pw.Text(idea.title, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 4),
                pw.Text('لأجل: $childName   |   المادة: ${idea.subject}   |   الصعوبة: ${idea.difficulty}   |   الوقت: ${idea.timeEstimate}',
                    style: const pw.TextStyle(fontSize: 11, color: PdfColors.grey700)),
                pw.Divider(height: 24),
                pw.Text(idea.description, style: const pw.TextStyle(fontSize: 12, lineSpacing: 3)),
                pw.SizedBox(height: 20),
                pw.Text('قائمة المواد المطلوبة', style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                ...idea.materials.map(
                  (m) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(width: 12, height: 12, decoration: pw.BoxDecoration(border: pw.Border.all(width: 1))),
                        pw.SizedBox(width: 8),
                        pw.Expanded(child: pw.Text(m, style: const pw.TextStyle(fontSize: 12))),
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text('خطوات التنفيذ', style: pw.TextStyle(fontSize: 15, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 8),
                ...List.generate(
                  idea.steps.length,
                  (i) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Row(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Container(
                          width: 20,
                          height: 20,
                          alignment: pw.Alignment.center,
                          decoration: const pw.BoxDecoration(shape: pw.BoxShape.circle, color: PdfColors.deepPurple),
                          child: pw.Text('${i + 1}', style: const pw.TextStyle(color: PdfColors.white, fontSize: 11)),
                        ),
                        pw.SizedBox(width: 8),
                        pw.Expanded(child: pw.Text(idea.steps[i], style: const pw.TextStyle(fontSize: 12, lineSpacing: 2))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
    return doc.save();
  }

  static Future<Uint8List> buildPoster({
    required PosterTemplate template,
    required PosterSize size,
    required String childName,
    required String schoolName,
    required String customMessage,
    required PdfColor themeColor,
    Uint8List? logoBytes,
  }) async {
    final doc = pw.Document();
    pw.ImageProvider? logoImage;
    if (logoBytes != null) {
      logoImage = pw.MemoryImage(logoBytes);
    }

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(size.widthPt, size.heightPt, marginAll: 0),
        build: (context) {
          return pw.Directionality(
            textDirection: pw.TextDirection.rtl,
            child: pw.Container(
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: themeColor, width: 10),
                gradient: pw.LinearGradient(colors: [PdfColors.white, themeColor.shade(0.06)]),
              ),
              padding: const pw.EdgeInsets.all(40),
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  if (logoImage != null) pw.Image(logoImage, height: 90),
                  if (logoImage != null) pw.SizedBox(height: 20),
                  pw.Text(template.title, style: pw.TextStyle(fontSize: 34, fontWeight: pw.FontWeight.bold, color: themeColor)),
                  pw.SizedBox(height: 24),
                  pw.Text('تُمنح هذه ${template.category} إلى', style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey700)),
                  pw.SizedBox(height: 10),
                  pw.Text(childName, style: pw.TextStyle(fontSize: 40, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 6),
                  pw.Text(schoolName, style: const pw.TextStyle(fontSize: 16, color: PdfColors.grey700)),
                  pw.SizedBox(height: 26),
                  pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    decoration: pw.BoxDecoration(border: pw.Border.all(color: themeColor, width: 1)),
                    child: pw.Text(
                      customMessage.isEmpty ? template.description : customMessage,
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    return doc.save();
  }

  /// Sends the given PDF directly to Android's native print/share dialog.
  static Future<void> printDocument(Uint8List bytes, String jobName) async {
    await Printing.layoutPdf(onLayout: (_) async => bytes, name: jobName);
  }
}
