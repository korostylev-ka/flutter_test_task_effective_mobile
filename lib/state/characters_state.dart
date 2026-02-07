import 'package:flutter/cupertino.dart';
import '../data/repository_impl.dart';
import '../domain/character.dart';

class CharactersState extends ChangeNotifier {
  final _repository = RepositoryImpl();
  List<Character> _characters = [];
  List<Character> get characters => _characters;
  List<Character> _favouriteCharacters = [];
  List<Character> get favouriteCharacters => _favouriteCharacters;

  Future<void> init() async {
    if (_characters.isEmpty) {
      await loadCharacters();
      await getFavouriteCharacters();
    }
  }

  Future<List<Character>> getAllCharacters() async {
    _characters = await _repository.getAllCharacters();
    for (int i = 0; i < _characters.length; i++) {
      if (_favouriteCharacters.contains(_characters[i])) {
        _characters[i] = Character.favourite(_characters[i]);
      }
    }
    notifyListeners();
    return _characters;
  }

  Future<void> loadCharacters() async {
    var newCharacters = await _repository.loadNewCharacters();
    for (int i = 0; i < newCharacters.length; i++) {
      if (_favouriteCharacters.contains(newCharacters[i])) {
        newCharacters[i] = Character.favourite(newCharacters[i]);
      }
    }
    _characters.addAll(newCharacters);
    notifyListeners();
  }

  Future<List<Character>> getFavouriteCharacters() async {
    _favouriteCharacters = await _repository.getFavouriteCharacters();
    notifyListeners();
    return favouriteCharacters;
  }

  void addToFavourite(Character character) async {
    await _repository.addToFavourite(character);
    getFavouriteCharacters();
    for (int i = 0; i < _characters.length; i++) {
      if (character.name == _characters[i].name) {
        var newCharacter = Character.favourite(character);
        _characters[i] = newCharacter;
      }
    }
    notifyListeners();
  }
}
