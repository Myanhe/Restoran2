import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/restaurant.dart';

class DatabaseHelper {
  static const _databaseName = 'favorites.db';
  static const _databaseVersion = 1;
  static const table = 'favorites';

  static final DatabaseHelper instance = DatabaseHelper._internal();

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, _databaseName);
    return openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id TEXT PRIMARY KEY,
        name TEXT,
        description TEXT,
        pictureId TEXT,
        city TEXT,
        rating REAL
      )
    ''');
  }

  Future<void> insertFavorite(Restaurant r) async {
    final db = await database;
    await db.insert(table, {
      'id': r.id,
      'name': r.name,
      'description': r.description,
      'pictureId': r.pictureId,
      'city': r.city,
      'rating': r.rating,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> removeFavorite(String id) async {
    final db = await database;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Restaurant>> getFavorites() async {
    final db = await database;
    final maps = await db.query(table);
    return maps.map((m) => Restaurant(
          id: m['id'] as String,
          name: m['name'] as String,
          description: m['description'] as String,
          pictureId: m['pictureId'] as String,
          city: m['city'] as String,
          rating: (m['rating'] as num).toDouble(),
        )).toList();
  }

  Future<bool> isFavorite(String id) async {
    final db = await database;
    final maps = await db.query(table, where: 'id = ?', whereArgs: [id]);
    return maps.isNotEmpty;
  }
}
