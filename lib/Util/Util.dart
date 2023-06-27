import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vnpt/Phat_Hanh/PhatHanh_Activity.dart';

Future<void> saveAsFile(
  final BuildContext context,
  final LayoutCallback build,
  final PdfPageFormat pageFormat,
) async {
  final bytes = await build(pageFormat);

  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/document.pdf');
  print('save ass file ${file.path}...');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

void showPrintedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Doccument printed successfully")));
}

void showSharedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Doccument shared successfully")));
}

Future<Uint8List> generatePdf(final PdfPageFormat format, String name,
    String address, dynamic cost, String amountInWord) async {
  PhatHanhActivity phatHanhActivity = PhatHanhActivity();

  final doc = pw.Document(
    title: "Biên lai",
  );
  final pagetheme = await _myPageTheme(format);
  final backgroundImg = pw.MemoryImage(
    (await rootBundle.load('assets/img.png')).buffer.asUint8List(),
  );
  final font = await rootBundle.load('assets/Nunito-Bold.ttf');
  final ttf = pw.Font.ttf(font);

  DateTime now = DateTime.now();
  String formattedDate = '${now.day}/0${now.month}/${now.year}';
  String formattedDateinWord = '${now.day} tháng 0${now.month} năm ${now.year}';

  doc.addPage(pw.MultiPage(
      pageTheme: pagetheme,
      build: (final context) => [
            pw.Column(children: [
              pw.Center(
                child: pw.Container(
                    child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                      pw.Container(
                          margin: const pw.EdgeInsets.fromLTRB(0, 60, 0, 15),
                          child: pw.Text("Biên lai thu tiền thuế, phí, lệ phí",
                              style: pw.TextStyle(
                                font: ttf,
                                fontSize: 25,
                                fontWeight: pw.FontWeight.bold,
                              ))),
                    ])),
              ),
              pw.Container(
                alignment: pw.Alignment.topLeft,
                margin: const pw.EdgeInsets.fromLTRB(60, 5, 60, 0),
                child: pw.Text("Tên người nộp: $name  ",
                    style: pw.TextStyle(
                      fontSize: 20,
                      font: ttf,
                    )),
              ),
              pw.Container(
                  alignment: pw.Alignment.topLeft,
                  margin: const pw.EdgeInsets.fromLTRB(60, 5, 60, 0),
                  child: pw.Text("Địa chỉ: $address ",
                      style: pw.TextStyle(
                        fontSize: 20,
                        font: ttf,
                      ))),
              pw.Container(
                  alignment: pw.Alignment.topLeft,
                  margin: const pw.EdgeInsets.fromLTRB(60, 5, 60, 0),
                  child: pw.Text("Số tiền: $costđ",
                      style: pw.TextStyle(
                        fontSize: 20,
                        font: ttf,
                      ))),
              pw.Container(
                  alignment: pw.Alignment.topLeft,
                  margin: const pw.EdgeInsets.fromLTRB(60, 5, 60, 0),
                  child: pw.Text("Số tiền bằng chữ: $amountInWord ",
                      style: pw.TextStyle(
                        fontSize: 20,
                        font: ttf,
                      ))),
              pw.Container(
                  alignment: pw.Alignment.topLeft,
                  margin: const pw.EdgeInsets.fromLTRB(60, 30, 60, 0),
                  child: pw.Text("Ngày $formattedDateinWord",
                      style: pw.TextStyle(
                        fontSize: 20,
                        font: ttf,
                      ))),
              pw.Container(
                  alignment: pw.Alignment.topLeft,
                  margin: const pw.EdgeInsets.fromLTRB(60, 5, 60, 0),
                  child: pw.Text("Ký bởi: Biên Lai Test VNPT VLG  ",
                      style: pw.TextStyle(
                        fontSize: 20,
                        font: ttf,
                      ))),
              pw.Container(
                  alignment: pw.Alignment.topLeft,
                  margin: const pw.EdgeInsets.fromLTRB(60, 5, 60, 0),
                  child: pw.Text("Ký ngày: $formattedDate",
                      style: pw.TextStyle(
                        fontSize: 20,
                        font: ttf,
                      ))),
            ])
          ]));

  return doc.save();
}

Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final backgroundImg = pw.MemoryImage(
      (await rootBundle.load('assets/img.png')).buffer.asUint8List());

  return pw.PageTheme(
      margin: pw.EdgeInsets.symmetric(
          horizontal: 1 * PdfPageFormat.cm, vertical: 0.5 * PdfPageFormat.cm),
      textDirection: pw.TextDirection.ltr,
      orientation: pw.PageOrientation.portrait,
      buildBackground: (final context) => pw.FullPage(
          ignoreMargins: false,
          child: pw.Watermark(
              angle: 0,
              child: pw.Image(
                alignment: pw.Alignment.center,
                backgroundImg,
                fit: pw.BoxFit.cover,
              ))));
}
