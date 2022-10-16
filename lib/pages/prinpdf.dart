// import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:printing/printing.dart';

class PrintPdf extends StatefulWidget {
  String doc;
  PrintPdf({required this.doc});

  @override
  State<PrintPdf> createState() => _PrintPdfState(docread: doc);
}

class _PrintPdfState extends State<PrintPdf> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  String docread;
  _PrintPdfState({required this.docread});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SfPdfViewer.network(
        docread,
        key: _pdfViewerKey,
        onDocumentLoaded: (PdfDocumentLoadedDetails details) async {
          final Uint8List bytes = Uint8List.fromList(details.document.save());
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => SafeArea(
                child: PdfPreview(
                  build: (format) => bytes,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
