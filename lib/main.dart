import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart' as p;
import 'src/database.dart';
import 'src/index.dart';
import 'src/ocr.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {
  MainApp({super.key}) {
    _initDatabase().whenComplete(() => null);
  }

  Future<void> _initDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();

    DatabaseConnection().create(openDatabase(
      p.join(await getDatabasesPath(), 'image_finder.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE indexes(path TEXT PRIMARY KEY, text TEXT)',
        );
      },
      version: 1,
    ));
  }

  Future<void> _printDatabase() async {
    final conn = await DatabaseConnection().connection;

    final res = await conn.query('indexes');
    print(res);
  }

  Future<String> _pickDirectory() async {
    String? result = await FilePicker.platform.getDirectoryPath();

    if (result != null) {
      return result;
    }

    throw 'error picking file';
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
                    final dir = await _pickDirectory();
                    final indexer = Indexer(const OcrWrapper());
                    await indexer.indexDirectory(dir);
                    print('directory $dir indexed!');
                  },
                  child: const Text('Select index directory'),
                ),
                FloatingActionButton(
                  onPressed: () async {
                    await _printDatabase();
                  },
                  child: const Text('Print!'),
                ),
              ]),
        ),
      ),
    );
  }
}
