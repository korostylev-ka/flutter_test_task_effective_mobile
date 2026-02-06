import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../domain/character.dart';
import '../domain/repository.dart';
import '../domain/status.dart';
import 'api.dart';
import 'db/character_entity.dart';
import 'db/db_service.dart';
import 'mapper.dart';

class RepositoryImpl implements Repository {
  final _resultsKey = 'results';
  final _infoKey = 'info';
  final _nameKey = 'name';
  final _imageKey = 'image';
  final _statusKey = 'status';
  final _speciesKey = 'species';
  final _locationKey = 'location';
  final _nextPageKey = 'next';
  final _api = Api();
  final _mapper = Mapper();
  String _urlForGetCharacters = 'https://rickandmortyapi.com/api/character';
  final List<Character> _charactersList = [];

  @override
  Future<void> addToFavourite(Character character) async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      if (!character.isFavourite) {
        await DBService.instance().insert(
          CharacterEntity.of(
            image: character.image,
            name: character.name,
            species: character.species,
            location: character.location,
            status: character.status.statusText,
          ),
        );
      } else {
        await DBService.instance().delete(character.name);
      }
    } else {
      //TODO('Shared pref to add')
    }
  }

  @override
  Future<List<Character>> loadNewCharacters() async {
    List<Character> characters = [];
    try {
      var response = await _api.getCharacters(_urlForGetCharacters);
      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);
        var list = data[_resultsKey];
        for (var characterItem in list) {
          String name = characterItem[_nameKey];
          String image = characterItem[_imageKey];
          String status = characterItem[_statusKey];
          String species = characterItem[_speciesKey];
          String location = characterItem[_locationKey][_nameKey];
          final character = Character(
            image: image,
            name: name,
            species: species,
            status: Status.getStatus(status),
            location: location,
          );
          characters.add(character);
        }
        String nextPage = data[_infoKey][_nextPageKey];
        _urlForGetCharacters = nextPage;
      }
    } catch (e) {
      return characters;
    }
    _charactersList.addAll(characters);
    return characters;
  }

  @override
  Future<List<Character>> getFavouriteCharacters() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      final characterEntities = await DBService.instance()
          .getFavouriteCharacters();
      return _mapper.characterEntityListToCharacterList(characterEntities);
    } else {
      return _charactersList;
      //TODO('Shared pref to add')
    }
  }

  @override
  Future<List<Character>> getAllCharacters() async {
    return _charactersList;
  }
}
