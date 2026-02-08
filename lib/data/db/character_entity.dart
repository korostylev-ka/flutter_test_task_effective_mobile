class CharacterEntity {
  String image;
  String name;
  String species;
  String location;
  String status;
  bool isFavourite;

  static const dbFileName = 'character_database.db';
  static const table = 'characters';
  static const createDB =
      'CREATE TABLE characters('
      'name TEXT PRIMARY KEY,'
      'image TEXT,'
      'species TEXT,'
      'location TEXT,'
      'status TEXT,'
      'isFavourite INTEGER'
      ')';

  CharacterEntity.of({
    required this.image,
    required this.name,
    required this.species,
    required this.location,
    required this.status,
    required this.isFavourite
  });

  Map<String, Object?> toMap() {
    return {
      'name': name,
      'image': image,
      'species': species,
      'location': location,
      'status': status,
      'isFavourite': isFavourite ? 1 : 0
    };
  }
}
