import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'character_entity.dart';

class DBService {
  late final Future<Database> database;
  static DBService? service;

  static DBService instance() {
    if (service == null) {
      service = DBService();
      service!.init();
    }
    return service!;
  }

  void init() async {
    database = openDatabase(
      join(await getDatabasesPath(), CharacterEntity.dbFileName),
      onCreate: (db, version) {
        return db.execute(CharacterEntity.createDB);
      },
      version: 1,
    );
  }

  Future<void> insert(CharacterEntity characterEntity) async {
    final db = await database;
    await db.insert(
      CharacterEntity.table,
      characterEntity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.abort,
    );
  }

  Future<List<CharacterEntity>> getFavouriteCharacters() async {
    final db = await database;
    final List<Map<String, Object?>> charactersMap = await db.query(
      CharacterEntity.table,
    );
    return [
      for (final {
            'image': image as String,
            'name': name as String,
            'species': species as String,
            'location': location as String,
            'status': status as String,
          }
          in charactersMap)
        CharacterEntity.of(
          image: image,
          name: name,
          species: species,
          location: location,
          status: status,
        ),
    ];
  }

  Future<void> delete(String name) async {
    final db = await database;
    await db.delete(
      CharacterEntity.table,
      where: 'name = ?',
      whereArgs: [name],
    );
  }
}
