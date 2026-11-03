import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

abstract class AccountStore {
  Future<int> insertAccount(Map<String, dynamic> account);

  Future<List<Map<String, dynamic>>> getAccounts();

  Future<double> getTotalBalance();
}

class DatabaseHelper implements AccountStore {
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance =
      DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'bank_accounts.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE accounts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            accountHolder TEXT NOT NULL,
            balance REAL NOT NULL
          )
        ''');
      },
    );
  }

  @override
  Future<int> insertAccount(Map<String, dynamic> account) async {
    final db = await database;
    return db.insert('accounts', account);
  }

  @override
  Future<List<Map<String, dynamic>>> getAccounts() async {
    final db = await database;
    return db.query('accounts', orderBy: 'id DESC');
  }

  @override
  Future<double> getTotalBalance() async {
    final db = await database;

    final result = await db.rawQuery(
      'SELECT SUM(balance) AS total FROM accounts',
    );

    return (result.first['total'] as num?)?.toDouble() ?? 0.0;
  }
}