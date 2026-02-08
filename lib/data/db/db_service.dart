import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'character_entity.dart';

class DBService {
  late Future<Database> database;
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
      onCreate: (db, version) async {
        await db.execute(CharacterEntity.createDB);
      },
      version: 1,
    );
  }

  Future<void> insert(CharacterEntity characterEntity) async {
    final db = await database;
    await db.insert(
      CharacterEntity.table,
      characterEntity.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CharacterEntity>> getAllCharacters() async {
    final db = await database;
    final List<Map<String, Object?>> charactersMap = await db.query(
      CharacterEntity.table,
    );
    return [
      for (final {
      'image': image as String,
      'savedImage': savedImage as String,
      'name': name as String,
      'species': species as String,
      'location': location as String,
      'status': status as String,
      'isFavourite': isFavourite as int
      }
      in charactersMap)
        CharacterEntity.of(
            image: image,
            savedImage: savedImage,
            name: name,
            species: species,
            location: location,
            status: status,
            isFavourite: isFavourite == 1 ? true : false
        ),
    ];
  }

  Future<List<CharacterEntity>> getFavouriteCharacters() async {
    final db = await database;
    final List<Map<String, Object?>> charactersMap = await db.query(
      CharacterEntity.table,
      where: 'isFavourite = ?',
      whereArgs: [1],
    );
    return [
      for (final {
            'image': image as String,
            'savedImage': savedImage as String,
            'name': name as String,
            'species': species as String,
            'location': location as String,
            'status': status as String,
            'isFavourite': isFavourite as int
          }
          in charactersMap)

        CharacterEntity.of(
          image: image,
          savedImage: savedImage,
          name: name,
          species: species,
          location: location,
          status: status,
          isFavourite: isFavourite == 1
        ),
    ];
  }

  Future<CharacterEntity?> getCharacterEntity(String name) async {
    final db = await database;
    final List<Map<String, Object?>> charactersMap = await db.query(
      CharacterEntity.table,
      where: 'name = ?',
      whereArgs: [name],
    );
    if (charactersMap.isNotEmpty) {
      return [
        for (final {
        'image': image as String,
        'savedImage': savedImage as String,
        'name': name as String,
        'species': species as String,
        'location': location as String,
        'status': status as String,
        'isFavourite': isFavourite as int
        }
        in charactersMap)
          CharacterEntity.of(
              image: image,
              savedImage: savedImage,
              name: name,
              species: species,
              location: location,
              status: status,
              isFavourite: isFavourite == 1
          ),
      ].first;
    } else {
      return null;
    }

  }

  Future<void> delete(String name) async {
    final db = await database;
    await db.delete(
      CharacterEntity.table,
      where: 'name = ?',
      whereArgs: [name],
    );
  }

  Future<void> update(CharacterEntity characterEntity) async {
    final db = await database;
    await db.update(
      CharacterEntity.table,
      characterEntity.toMap(),
      where: 'name = ?',
      whereArgs: [characterEntity.name],
    );
  }
}
