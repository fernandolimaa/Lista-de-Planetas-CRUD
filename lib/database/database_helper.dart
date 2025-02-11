import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/planet.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;


  DatabaseHelper._init();

  Future<void> debugCheckDatabase() async {
    final db = await database;
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    print("📂 Tabelas no banco: $tables");
  }

  Future<void> resetDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = "$dbPath/planets.db";
    await deleteDatabase(path);
    print("🗑️ Banco de dados deletado! Reinicie o app.");
  }

  Future<void> insertTestPlanet() async {
    await insertPlanet(Planet(
      name: "Saturno",
      distance: 9.5,
      size: 120536,
      nickname: "Planeta dos Anéis",
    ));
    print("🚀 Planeta Saturno inserido!");
  }


  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!; // ✅ Correto!
  }

  Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'planets.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate, // ✅ Agora a função é chamada corretamente
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE planets (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      distance REAL NOT NULL,
      size REAL NOT NULL,
      nickname TEXT
    )
  ''');

    await db.insert('planets', {'name': 'Terra', 'distance': 1.0, 'size': 12742, 'nickname': 'Planeta Azul'});
    await db.insert('planets', {'name': 'Marte', 'distance': 1.5, 'size': 6779, 'nickname': 'Planeta Vermelho'});
    await db.insert('planets', {'name': 'Júpiter', 'distance': 5.2, 'size': 139820, 'nickname': 'Gigante Gasoso'});

    print("🌍 Planetas iniciais adicionados ao banco!");
  }


  Future<void> _insertDefaultPlanets(Database db) async {
    List<Planet> planets = [
      Planet(name: 'Mercúrio', distance: 0.39, size: 4879, nickname: 'Pequeno'),
      Planet(name: 'Vênus', distance: 0.72, size: 12104, nickname: 'Quente'),
      Planet(name: 'Terra', distance: 1.00, size: 12742, nickname: 'Lar'),
      Planet(name: 'Marte', distance: 1.52, size: 6779, nickname: 'Vermelho'),
      Planet(name: 'Júpiter', distance: 5.20, size: 139820, nickname: 'Gigante'),
      Planet(name: 'Saturno', distance: 9.58, size: 116460, nickname: 'Anéis'),
      Planet(name: 'Urano', distance: 19.22, size: 50724, nickname: 'Gélido'),
      Planet(name: 'Netuno', distance: 30.05, size: 49244, nickname: 'Azul'),
    ];
    for (var planet in planets) {
      await db.insert('planets', planet.toMap());
    }
  }
  Future<int> insertPlanet(Planet planet) async {
    final db = await instance.database;
    return await db.insert('planets', planet.toMap());
  }

  Future<List<Planet>> getPlanets() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('planets');

    print("Banco de dados retornou: ${maps.length} registros");
    for (var map in maps) {
      print("Planeta encontrado: ${map['name']} - Distância: ${map['distance']} UA");
    }

    return List.generate(maps.length, (i) {
      return Planet(
        id: maps[i]['id'],
        name: maps[i]['name'],
        distance: maps[i]['distance'],
        size: maps[i]['size'],
        nickname: maps[i]['nickname'],
      );
    });
  }

  Future<void> updatePlanet(Planet planet) async {
    final db = await instance.database;
    await db.update('planets', planet.toMap(), where: 'id = ?', whereArgs: [planet.id]);
  }

  Future<void> deletePlanet(int id) async {
    final db = await instance.database;
    await db.delete('planets', where: 'id = ?', whereArgs: [id]);
  }
}
