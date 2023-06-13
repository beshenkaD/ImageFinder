import 'package:sqflite/sqflite.dart';

/// Interface defining entity which is stored in database
abstract class IDatabaseEntity {
  Map<String, dynamic> toMap();
}

/// Singlton database connection
///
/// Initialize it with `create` method using `sqflite.openDatabase`
/// and then you can use it like this:
///   final c = await DatabaseConnection().connection;
///   await c.insert(...whatever...);
class DatabaseConnection {
  static final DatabaseConnection _instance = DatabaseConnection._internal();

  factory DatabaseConnection() {
    return _instance;
  }

  DatabaseConnection._internal();

  late final Future<Database> _database;

  /// The actual constructor of connector
  ///
  /// WARNING: You MUST run `WidgetsFlutterBinding.ensureInitialized()`
  /// BEFORE calling this method.
  Future<DatabaseConnection> create(Future<Database> database) async {
    var _ = DatabaseConnection._internal();

    _database = database;

    return _;
  }

  Future<Database> get connection => _database;
}
