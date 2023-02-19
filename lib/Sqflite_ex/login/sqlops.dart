import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }
  DatabaseHelper.internal();
  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'login.db');
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }
  void _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE Login (id INTEGER PRIMARY KEY, username TEXT, password TEXT)');
  }
  Future<int> saveUser(String username, String password) async {
    var dbClient = await db;
    int res = await dbClient.rawInsert(
        "INSERT Into Login (username, password)"
            " VALUES ('$username', '$password')");
    return res;
  }
  Future<bool> loginUser(String username, String password) async {
    var dbClient = await db;
    List<Map> list = await dbClient.rawQuery(
        "SELECT * FROM Login WHERE username = '$username' and password = '$password'");
    if (list.length > 0) {
      return true;
    } else {
      return false;
    }
  }
}
