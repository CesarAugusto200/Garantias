import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/warranty.dart';

class WarrantyDatabase {
  static final WarrantyDatabase instance = WarrantyDatabase._init();
  static Database? _database;

  WarrantyDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('warranty.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE warranties (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        productName TEXT NOT NULL,
        store TEXT NOT NULL,
        purchaseDate TEXT NOT NULL,
        expirationDate TEXT NOT NULL
      )
    ''');
  }

  Future<int> insertWarranty(Warranty warranty) async {
    final db = await instance.database;
    return await db.insert('warranties', warranty.toMap());
  }

  Future<List<Warranty>> fetchAllWarranties() async {
    final db = await instance.database;
    final result = await db.query('warranties');

    return result.map((map) => Warranty.fromMap(map)).toList();
  }
}
