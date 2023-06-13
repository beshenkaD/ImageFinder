import 'dart:io';

import 'ocr.dart';
import 'database.dart';
import 'index_dao.dart';

class Index implements IDatabaseEntity {
  final String path;
  final String text;

  const Index({
    required this.path,
    required this.text,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'path': path,
      'text': text,
    };
  }
}

/// This class performs indexing of image files
///
/// The result of indexing is a pair of two strings (`Index` class):
/// image filepath and text extracted from image using OCR.
/// this data will be saved in sqlite database.
class Indexer {
  late OcrWrapper _wrapper;
  Indexer(OcrWrapper w) {
    _wrapper = w;
  }

  /// This function indexes one single file
  Future<void> indexFile(String filepath) async {
    final text = await _wrapper.extractText(filepath);
    await IndexDao.insert(Index(path: filepath, text: text));
  }

  /// This function indexes all image files in directory
  Future<void> indexDirectory(String dirpath) async {
    for (final item in Directory(dirpath).listSync()) {
      final path = item.absolute.path;

      if (!_isImage(path)) {
        continue;
      }

      await indexFile(path);
    }
  }

  bool _isImage(String path) {
    final extensions = [
      '.jpg',
      '.png',
      '.jpeg',
      '.tiff',
      '.gif',
      '.webp',
      '.bmp',
      '.pnm',
    ];

    for (final ext in extensions) {
      if (path.endsWith(ext)) {
        return true;
      }
    }

    return false;
  }
}
