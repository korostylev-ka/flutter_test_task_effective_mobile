import 'dart:convert';

import '../domain/character.dart';
import '../domain/status.dart';
import 'db/character_entity.dart';

class Mapper {
  final _jsonImageKey = 'image';
  final _jsonNameKey = 'name';
  final _jsonSpeciesKey = 'species';
  final _jsonLocationKey = 'location';
  final _jsonStatusKey = 'status';
  final _jsonIsFavouriteKey = 'is favourite';

  Character characterEntityToCharacter(CharacterEntity characterEntity) {
    return Character(
      image: characterEntity.image,
      name: characterEntity.name,
      species: characterEntity.species,
      status: Status.getStatusFromStatusText(characterEntity.status),
      location: characterEntity.location,
      isFavourite: true,
    );
  }

  List<Character> characterEntityListToCharacterList(
    List<CharacterEntity> characterEntities,
  ) {
    List<Character> charactersList = [];
    for (var characterEntity in characterEntities) {
      charactersList.add(characterEntityToCharacter(characterEntity));
    }
    return charactersList;
  }

  Map<String, dynamic> mapCharacterToMap(Character character) {
    return {
      _jsonImageKey: character.image,
      _jsonNameKey: character.name,
      _jsonSpeciesKey: character.species,
      _jsonStatusKey: json.encode(character.status.toString()),
      _jsonLocationKey: character.location,
      _jsonIsFavouriteKey: character.isFavourite,
    };
  }

  Character mapCharacterFromJson(Map<String, dynamic> jsonCharacters) {
    return Character(
      image: jsonCharacters[_jsonImageKey],
      name: jsonCharacters[_jsonNameKey],
      species: jsonCharacters[_jsonSpeciesKey],
      status: Status.getStatusFromString(
        json.decode(jsonCharacters[_jsonStatusKey]),
      ),
      location: jsonCharacters[_jsonLocationKey],
      isFavourite: jsonCharacters[_jsonIsFavouriteKey],
    );
  }

  String encodeCharacters(List<Character> characters) {
    return json.encode(
      characters
          .map<Map<String, dynamic>>(
            (character) => mapCharacterToMap(character),
          )
          .toList(),
    );
  }

  List<Character> decodeCharacters(String? characters) {
    if (characters == null) return [];
    return (json.decode(characters) as List<dynamic>)
        .map<Character>((json) => mapCharacterFromJson(json))
        .toList();
  }
}
