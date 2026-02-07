import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/character.dart';
import '../mapper.dart';

class AppSharedPreferences {
  final _favourite = 'favourite characters';
  final _mapper = Mapper();

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
}
