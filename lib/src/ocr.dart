import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

/// Wrapper for MLKIT and Tesseract
///
/// TODO: Auto download tesseract data,
///       MLKIT
class OcrWrapper {
  const OcrWrapper();

  // TODO: remove hardcoding
  final _lang = 'eng';

  Future<String> extractText(String path) async {
    String text = await FlutterTesseractOcr.extractText(
      path,
      language: _lang,

      // https://muthu.co/all-tesseract-ocr-options/
      // 11 - Sparse text. Find as much text as possible in no particular order.
      // 12 - Sparse text with OSD.
      args: {
        "psm": "12",
        "preserve_interword_spaces": "1",
      },
    );

    return text.replaceAll('\n', ' ').toLowerCase();
  }
}
