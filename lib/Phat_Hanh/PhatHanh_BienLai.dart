import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:vnpt/Util/Util.dart';

class PhatHanh_BienLai extends StatefulWidget {
  const PhatHanh_BienLai({Key? key}) : super(key: key);
  @override
  PhatHanhBienLai createState() => PhatHanhBienLai();
}

class PhatHanhBienLai extends State<PhatHanh_BienLai> {
  PrintingInfo? printingInfo;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> detailBienLai1 =
        ModalRoute.of(context)!.settings.arguments as List<String>;

    String name = detailBienLai1.isNotEmpty ? detailBienLai1[0] : "";

    String address = detailBienLai1.isNotEmpty ? detailBienLai1[1] : "";

    dynamic cost = detailBienLai1.isNotEmpty ? detailBienLai1[2] : "";
    String amountInWord = detailBienLai1.isNotEmpty ? detailBienLai1[3] : "";

    pw.RichText.debug = true;
    final actions = <PdfPreviewAction>[
      if (kIsWeb)
        const PdfPreviewAction(icon: Icon(Icons.save), onPressed: saveAsFile)
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text("Biên lai"),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: actions,
        onPrinted: showPrintedToast,
        onShared: showSharedToast,
        build: (PdfPageFormat format) =>
            generatePdf(format, name, address, cost, amountInWord),
      ),
    );
  }
}
