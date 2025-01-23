import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  factory DBHelper() => _instance;

  /// Access the database instance. Initializes it if not already done.
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  /// Initialize the database with a given file path.
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Create tables in the database during initialization.
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_code TEXT NOT NULL,
        display_name TEXT NOT NULL,
        email TEXT NOT NULL,
        employee_code TEXT NOT NULL,
        company_code TEXT NOT NULL
      )
    ''');
  }

  /// Insert a user into the database.
  /// Prevents duplicate entries by checking the `user_code`.
  Future<void> insertUser(Map<String, dynamic> user) async {
    if (user.isEmpty) {
      throw ArgumentError("User data cannot be empty.");
    }

    final db = await database;

    // Check for existing user
    final existingUser = await db.query(
      'user',
      where: 'user_code = ?',
      whereArgs: [user['user_code']],
    );

    if (existingUser.isNotEmpty) {
      throw Exception(
          'User already exists in the database with user_code: ${user['user_code']}');
    }

    await db.insert(
      'user',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Fetch all users from the database.
  Future<List<Map<String, dynamic>>> getUsers() async {
    final db = await database;
    final result = await db.query('user');
    if (result.isEmpty) {
      throw Exception("No users found in the database.");
    }
    return result;
  }

  /// Insert or update a user in the database.
  Future<void> upsertUser(Map<String, dynamic> user) async {
    if (user.isEmpty) {
      throw ArgumentError("User data cannot be empty.");
    }

    final db = await database;

    // Check if the user already exists
    final existingUser = await db.query(
      'user',
      where: 'user_code = ?',
      whereArgs: [user['user_code']],
    );

    if (existingUser.isNotEmpty) {
      // Update the existing user
      await db.update(
        'user',
        user,
        where: 'user_code = ?',
        whereArgs: [user['user_code']],
      );
    } else {
      // Insert a new user
      await db.insert(
        'user',
        user,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  /// Clear all users from the database.
  Future<void> clearUsers() async {
    final db = await database;
    await db.delete('user');
  }

  /// Close the database connection.
  Future<void> closeDB() async {
    final db = _database;
    if (db != null) {
      await db.close();
    }
  }

  /// Check if a user exists by `user_code`.
  Future<bool> userExists(String userCode) async {
    final db = await database;
    final result = await db.query(
      'user',
      where: 'user_code = ?',
      whereArgs: [userCode],
    );
    return result.isNotEmpty;
  }
}
