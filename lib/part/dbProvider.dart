import 'dart:io';
import 'package:TimeCount/part/timeCountModel.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProvider {
  // privateなコンストラクタ
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;

    // DBがなかったら作る
    _database = await initDB();
    return _database;
  }

  static final _tableName = "TIMECOUNT";

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    // import 'package:path/path.dart'; が必要
    // なぜか サジェスチョンが出てこない
    String path = join(documentsDirectory.path, "TimeCount.db");

    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  _createTable(Database db, int version) async {
    await db.execute("CREATE TABLE TIMEDELTA ("
        "id TEXT PRIMARY KEY,"
        "TITLE TEXT,"
        "SDATETIME TEXT,"
        "FDATETIME TEXT,"
        "DELTAMINUTE INT"
        "UPDATEDATE TEXT"
        ")");
    await db.execute("CREATE TABLE BOULD ("
        "id TEXT PRIMARY KEY,"
        "YEARMONTH TEXT,"
        "NUMBER TEXT,"
        "ATTEMPT TEXT,"
        "RESULT TEXT"
        ")");
    await db.execute("CREATE TABLE TITLE ("
        "id TEXT PRIMARY KEY,"
        "TITLENAME TEXT,"
        ")");
  }

  createTimeCount(TimeCount timeCount) async {
    final db = await database;
    var res = await db.insert(_tableName, timeCount.toMap());
    return res;
  }

  getAllTimeCounts() async {
    final db = await database;
    var res = await db.query(_tableName);
    List<TimeCount> list =
        res.isNotEmpty ? res.map((c) => TimeCount.fromMap(c)).toList() : [];
    return list;
  }

  updateTimeCount(TimeCount timeCount) async {
    final db = await database;
    var res = await db.update(_tableName, timeCount.toMap(),
        where: "id = ?", whereArgs: [timeCount.id]);
    return res;
  }

  deleteTimeCount(String id) async {
    final db = await database;
    var res = db.delete(_tableName, where: "id = ?", whereArgs: [id]);
    return res;
  }
}
