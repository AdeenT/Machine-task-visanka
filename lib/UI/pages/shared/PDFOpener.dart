import 'dart:io';

import 'package:ourESchool/UI/Utility/constants.dart';
import 'package:ourESchool/UI/Widgets/TopBar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdf_viewer_plugin/pdf_viewer_plugin.dart';

class PDFOpener extends StatefulWidget {
  final String url;
  final String title;

  PDFOpener({required this.url, required this.title});

  @override
  _PDFOpenerState createState() => _PDFOpenerState();
}

class _PDFOpenerState extends State<PDFOpener> {
  String? path;

  bool _isLoading = true;

  loadPDF() async {
    path = (await getFileFromUrl(widget.url)).path;
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  @override
  void initState() {
    super.initState();
    loadPDF();
  }

  Future<File> getFileFromUrl(String url) async {
    try {
      var data = await http.get(Uri.parse(url));
      var bytes = data.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      String fileName = createCryptoRandomString(8);
      File file = File("${dir.path}/$fileName.pdf");

      File urlFile = await file.writeAsBytes(bytes);
      return urlFile;
    } catch (e) {
      throw Exception("Error opening url file");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        child: kBackBtn,
        onPressed: () {
          Navigator.pop(context);
        },
        title: widget.title ?? 'PDF',
      ),
      body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PdfView(path: path ?? ''),
      ),
    );
  }
}
