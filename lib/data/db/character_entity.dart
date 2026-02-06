class CharacterEntity {
  String image;
  String name;
  String species;
  String location;
  String status;

  static const dbFileName = 'character_database.db';
  static const table = 'characters';
  static const createDB =
      'CREATE TABLE characters('
      'name TEXT PRIMARY KEY,'
      'image TEXT,'
      'species TEXT,'
      'location TEXT,'
      'status TEXT'
      ')';

  CharacterEntity.of({
    required this.image,
    required this.name,
    required this.species,
    required this.location,
    required this.status,
  });

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'image': image,
      'species': species,
      'location': location,
      'status': status,
    };
  }
}
