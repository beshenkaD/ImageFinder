import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';
import 'dart:io';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<File> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      return file;
    }

    throw 'error picking file';
  }

  Future<String> _ocrText(File file, String lang) async {
    String text = await FlutterTesseractOcr.extractText(file.absolute.path,
        language: lang,
        args: {
          "psm": "4",
          // "preserve_interword_spaces": "1",
        });

    return text;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FloatingActionButton(
                  onPressed: () async {
                    File file = await _pickFile();
                    String text = await _ocrText(file, 'eng');
                    print(text);
                  },
                  child: const Text('OCR IT!'),
                ),
              ]),
        ),
      ),
    );
  }
}
