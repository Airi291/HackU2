import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AimDatabaseHelper {
  static final AimDatabaseHelper instance =
  AimDatabaseHelper._privateConstructor();
  static Database? _database;

  AimDatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'aim.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE aspirations(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            aim TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertAim(String content) async {
    final db = await database;
    await db.insert(
      'aspirations',
      {
        'aim': content,
      },
    );
  }

  Future<String> getAim() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('aspirations');
    if (maps.isEmpty) {
      return '';
    }
    return maps.first['aim'];
  }

  Future<void> updateAim(String content) async {
    final db = await database;
    await db.update(
      'aspirations',
      {
        'aim': content,
      },
    );
  }
}

// Achieve and date database helper
class AchDatabaseHelper {
  static final AchDatabaseHelper instance =
  AchDatabaseHelper._privateConstructor();
  static Database? _database;

  AchDatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'achieve.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE achievements(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            achieve TEXT NOT NULL,
            date TEXT NOT NULL,
            flag INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  Future<void> resetAchieve() async {
    final db = await database;
    await db.delete('achievements');
  }

  Future<void> insertAchieve(String content, String date) async {
    final db = await database;
    await db.insert(
      'achievements',
      {
        'achieve': content,
        'date': date,
      },
    );
  }

  Future<List<Map<String, dynamic>>> getAchieve() async {
    final db = await database;
    return await db.query('achievements');
  }

  Future<void> updateAchieve(int id) async {
    final db = await database;
    await db.update(
      'achievements',
      {
        'flag': 1,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<String> getAchievement() async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('achievements');
    String achieve = '[]';
    for (var map in maps) {
      achieve += "${map['date']}: ${map['achieve']}";
      if (map['flag'] == 1)
        achieve += 'done';
      else
        achieve += 'not done';
    }
    return achieve;
  }
}