import 'index.dart';
import 'package:sqflite/sqflite.dart';
import 'database.dart';

/// Database access object for `Index` class
///
/// TODO: wrap all methods with `try` blocks
class IndexDao {
  static const _table = 'indexes';

  static Future<int> insert(Index index,
      [var alg = ConflictAlgorithm.replace]) async {
    final conn = await DatabaseConnection().connection;
    final res = await conn.insert(
      _table,
      index.toMap(),
      conflictAlgorithm: alg,
    );

    return res;
  }

  static Future<Index?> getByPath(String path) async {
    final conn = await DatabaseConnection().connection;
    List<Map> maps = await conn.query(
      _table,
      where: 'path = ?',
      whereArgs: [path],
    );

    if (maps.isNotEmpty) {
      final first = maps.first;
      return Index(path: first['path'], text: first['text']);
    }

    return null;
  }

  static Future<int> deleteByPath(String id) async {
    final conn = await DatabaseConnection().connection;
    return await conn.delete(_table, where: 'path = ?', whereArgs: [id]);
  }

  static Future<List<Index>> query() async {
    final conn = await DatabaseConnection().connection;
    List<Map> indexes = await conn.query(_table);

    return indexes.nonNulls
        .map((e) => Index(path: e['path'], text: e['text']))
        .toList(growable: false);
  }

  static Future<int> update(Index index,
      [var alg = ConflictAlgorithm.replace]) async {
    final conn = await DatabaseConnection().connection;
    return await conn.update(
      _table,
      index.toMap(),
      where: 'path = ?',
      whereArgs: [index.path],
      conflictAlgorithm: alg,
    );
  }
}
