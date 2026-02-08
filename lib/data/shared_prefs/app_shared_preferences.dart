import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/character.dart';
import '../mapper.dart';

class AppSharedPreferences {
  final _favourite = 'favourite characters';
  final _allCharacters = 'all characters';
  final _url = 'url for new characters';
  final _defaultUrl = 'https://rickandmortyapi.com/api/character';
  final _mapper = Mapper();

  Future<void> addUrlForNewCharactersToSharedPref(String url) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(_url);
    await prefs.setString(_url, url);
  }

  Future<String> getUrlForNewCharactersFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_url) ?? _defaultUrl;
  }

  Future<void> addFavouriteCharacterToSharedPref(Character character) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Character> favourites =
        await getFavouriteCharactersListFromSharedPref();
    prefs.remove(_favourite);
    if (character.isFavourite) {
      favourites.remove(character);
    } else {
      favourites.add(Character.favourite(character));
    }
    prefs.remove(_favourite);
    await saveFavouriteCharactersListToSharedPref(favourites);
    await updateCharacterInSharedPref(Character.favourite(character));
  }

  Future<void> addCharacterToSharedPref(Character character) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Character> characters = await getAllCharactersListFromSharedPref();
    prefs.remove(_allCharacters);
    if (!characters.contains(character)) {
      characters.add(character);
    }
    prefs.remove(_allCharacters);
    await saveCharactersListToSharedPref(characters);
  }

  Future<void> addCharactersListToSharedPref(
    List<Character> newCharacters
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Character> characters = await getAllCharactersListFromSharedPref();
    for (final character in newCharacters) {
      if (!characters.contains(character)) {
        characters.add(character);
      }
    }
    prefs.remove(_allCharacters);
    await saveCharactersListToSharedPref(characters);
  }

  Future<void> updateCharacterInSharedPref(Character character) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Character> characters = await getAllCharactersListFromSharedPref();
    if (characters.contains(character)) {
      int index = characters.indexOf(character);
      characters[index] = character;
    }
    prefs.remove(_allCharacters);
    await saveCharactersListToSharedPref(characters);
  }

  Future<void> saveFavouriteCharactersListToSharedPref(
    List<Character> characters,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_favourite, _mapper.encodeCharacters(characters));
  }

  Future<List<Character>> getFavouriteCharactersListFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final charactersString = await prefs.getString(_favourite);
    return _mapper.decodeCharacters(charactersString);
  }

  Future<List<Character>> getAllCharactersListFromSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final charactersString = await prefs.getString(_allCharacters);
    return _mapper.decodeCharacters(charactersString);
  }

  Future<void> saveCharactersListToSharedPref(
    List<Character> characters,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_allCharacters, _mapper.encodeCharacters(characters));
  }
}
