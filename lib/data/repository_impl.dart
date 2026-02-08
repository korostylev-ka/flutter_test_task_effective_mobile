import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_task_for_effective_mobile/data/shared_prefs/app_shared_preferences.dart';
import '../domain/character.dart';
import '../domain/repository.dart';
import '../domain/status.dart';
import 'api.dart';
import 'db/character_entity.dart';
import 'db/db_service.dart';
import 'mapper.dart';
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
  final _api = Api();
  final _mapper = Mapper();
  String _urlForGetCharacters = 'https://rickandmortyapi.com/api/character';

  @override
  Future<void> addToFavourite(Character character) async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      final database = DBService.instance();
      final characterEntity = await database.getCharacterEntity(character.name);
      await database.update(
        _mapper.characterToCharacterEntity(
          Character.favourite(character),
          characterEntity!.savedImage,
        ),
      );
    } else {
      AppSharedPreferences sharedPrefs = AppSharedPreferences();
      await sharedPrefs.addFavouriteCharacterToSharedPref(character);
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
            status: Status.getStatusFromApiStatus(status),
            location: location,
          );
          characters.add(character);
          await addNewCharacter(character);
        }
        String nextPage = data[_infoKey][_nextPageKey];
        _urlForGetCharacters = nextPage;
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
      final database = DBService.instance();
      final characterEntities = await database.getFavouriteCharacters();
      return _mapper.characterEntityListToCharacterList(characterEntities);
    } else {
      AppSharedPreferences sharedPrefs = AppSharedPreferences();
      return await sharedPrefs.getFavouriteCharactersListFromSharedPref();
    }
  }

  @override
  Future<List<Character>> getAllCharacters() async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      final database = DBService.instance();
      final favouriteEntities = await database.getAllCharacters();
      return _mapper.characterEntityListToCharacterList(favouriteEntities);
    } else {
      AppSharedPreferences sharedPrefs = AppSharedPreferences();
      return await sharedPrefs.getAllCharactersListFromSharedPref();
    }
  }

  Future<String> saveImageToDeviceFromUrl(Character character) async {
    final imageFromApi = await http.get(Uri.parse(character.image));
    final dir = await getApplicationDocumentsDirectory();
    final imageName = character.name.replaceAll(' ', '');
    ;
    final imagePath = '${dir.path}/$imageName.jpg';
    final file = File(imagePath);
    await file.writeAsBytes(imageFromApi.bodyBytes);
    return imagePath;
  }

  Future<void> addNewCharacter(Character character) async {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      final database = DBService.instance();
      CharacterEntity? characterEntity = await database.getCharacterEntity(
        character.name,
      );
      if (characterEntity == null) {
        String imageName = await saveImageToDeviceFromUrl(character);
        await database.insert(
          _mapper.characterToCharacterEntity(character, imageName),
        );
      }
    } else {
      AppSharedPreferences sharedPrefs = AppSharedPreferences();
      await sharedPrefs.addCharacterToSharedPref(character);
    }
  }
}
