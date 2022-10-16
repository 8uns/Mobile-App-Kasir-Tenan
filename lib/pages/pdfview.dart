// import 'dart:html';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:kasir_tenan_0_1/pages/prinpdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:printing/printing.dart';

class PdfViewer extends StatefulWidget {
  String colorbase;
  String doc;
  String title;
  PdfViewer({required this.doc, required this.title, required this.colorbase});

  @override
  State<PdfViewer> createState() =>
      _PdfViewerState(titleread: title, docread: doc, colorbaseread: colorbase);
}

class _PdfViewerState extends State<PdfViewer> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();
  String titleread;
  String docread;
  String colorbaseread;
  _PdfViewerState(
      {required this.titleread,
      required this.docread,
      required this.colorbaseread});
  @override
  var isBooled = false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorbaseread == 'blue'
            ? Colors.blue
            : colorbaseread == 'yellow'
                ? Colors.amberAccent
                : colorbaseread == 'red'
                    ? Colors.red
                    : colorbaseread == 'orange'
                        ? Colors.orange
                        : Colors.amber,
        title: Text(
          titleread,
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.print),
            tooltip: 'Increase volume by 10',
            onPressed: () {
              setState(() {
                // print("print dong");
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PrintPdf(doc: docread)));
              });
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        docread,
        key: _pdfViewerKey,
        // onDocumentLoaded: (PdfDocumentLoadedDetails details) async {
        //   final Uint8List bytes = Uint8List.fromList(details.document.save());
        //   await Navigator.pushReplacement(
        //     context,
        //     MaterialPageRoute<dynamic>(
        //       builder: (BuildContext context) => SafeArea(
        //         child: PdfPreview(
        //           build: (format) => bytes,
        //         ),
        //       ),
        //     ),
        //   );
        // },
      ),
    );
  }
}
