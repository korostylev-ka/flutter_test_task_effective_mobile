import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_task_for_effective_mobile/di/dependency_injection.dart';
import '../domain/character.dart';
import '../domain/repository.dart';
import '../domain/status.dart';
import 'db/db_service.dart';
import 'package:http/http.dart' as http;

class RepositoryImpl implements Repository {
  final _resultsKey = 'results';
  final _infoKey = 'info';
  final _nameKey = 'name';
  final _imageKey = 'image';
  final _statusKey = 'status';
  final _speciesKey = 'species';
  final _locationKey = 'location';
  final _nextPageKey = 'next';
  final _api = DependencyInjection.getApi();
  final _mapper = DependencyInjection.getMapper();
  String _urlForGetCharacters = 'https://rickandmortyapi.com/api/character';

  @override
  Future<void> addToFavourite(Character character) async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      final database = DBService.instance();
      await database.update(
        _mapper.characterToCharacterEntity(Character.favourite(character)),
      );
    } else {
      final sharedPrefs = DependencyInjection.getSharedPrefs();
      await sharedPrefs.addFavouriteCharacterToSharedPref(character);
    }
  }

  @override
  Future<List<Character>> loadNewCharacters() async {
    final sharedPrefs = DependencyInjection.getSharedPrefs();
    _urlForGetCharacters = await sharedPrefs
        .getUrlForNewCharactersFromSharedPref();
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
            status: Status.getStatusFromApiStatus(status),
            location: location,
          );
          characters.add(character);
        }
        await addNewCharactersList(characters);
        String nextPage = data[_infoKey][_nextPageKey];
        await sharedPrefs.addUrlForNewCharactersToSharedPref(nextPage);
      }
    } catch (e) {
      return characters;
    }
    return characters;
  }

  @override
  Future<List<Character>> getFavouriteCharacters() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      final database = DependencyInjection.getDatabase();
      final characterEntities = await database.getFavouriteCharacters();
      return _mapper.characterEntityListToCharacterList(characterEntities);
    } else {
      final sharedPrefs = DependencyInjection.getSharedPrefs();
      return await sharedPrefs.getFavouriteCharactersListFromSharedPref();
    }
  }

  @override
  Future<List<Character>> getAllCharacters() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      final database = DependencyInjection.getDatabase();
      final favouriteEntities = await database.getAllCharacters();
      return _mapper.characterEntityListToCharacterList(favouriteEntities);
    } else {
      final sharedPrefs = DependencyInjection.getSharedPrefs();
      return await sharedPrefs.getAllCharactersListFromSharedPref();
    }
  }

  Future<void> saveImageToDeviceFromUrl(Character character) async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      final imageFromApi = await http.get(Uri.parse(character.image));
      if (imageFromApi.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final imageName = character.name.replaceAll(' ', '');
        final imagePath = '${dir.path}/$imageName.jpg';
        final file = File(imagePath);
        file.writeAsBytes(imageFromApi.bodyBytes);
        character.image = imagePath;
        if (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS) {
          final database = DependencyInjection.getDatabase();
          await database.update(
            _mapper.characterToCharacterEntity(character),
          );
        }
        if (defaultTargetPlatform == TargetPlatform.windows) {
          final sharedPrefs = DependencyInjection.getSharedPrefs();
          await sharedPrefs.updateCharacterInSharedPref(character);
        }
      }
    }
  }

  Future<void> addNewCharactersList(List<Character> characters) async {
    final allCharacters = await getAllCharacters();
    List<Character> charactersToAdd = [];
    for (var character in characters) {
      if (!allCharacters.contains(character)) {
        charactersToAdd.add(character);
      }
    }
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      final database = DependencyInjection.getDatabase();
      for (var character in charactersToAdd) {
        database.insert(_mapper.characterToCharacterEntity(character));
      }
    } else {
      final sharedPrefs = DependencyInjection.getSharedPrefs();
      await sharedPrefs.addCharactersListToSharedPref(characters);
    }
  }
}
