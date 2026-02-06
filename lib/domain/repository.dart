import 'character.dart';

abstract class Repository {
  Future<List<Character>> getAllCharacters();
  Future<List<Character>> loadNewCharacters();
  Future<List<Character>> getFavouriteCharacters();
  void addToFavourite(Character character);
}