import 'package:flutter/cupertino.dart';
import 'package:test_task_for_effective_mobile/di/dependency_injection.dart';
import '../domain/character.dart';

class CharactersState extends ChangeNotifier {
  final _repository = DependencyInjection.getRepository();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Character> _characters = [];
  List<Character> get characters => _characters;
  List<Character> _favouriteCharacters = [];
  List<Character> get favouriteCharacters => _favouriteCharacters;
  List<Character> newCharacters = [];

  void init() async {
    if (_characters.isEmpty) {
      await loadCharacters();
    }
  }

  Future<List<Character>> getAllCharacters() async {
    _characters = await _repository.getAllCharacters();
    return _characters;
  }

  Future<List<Character>> loadCharacters() async {
    _isLoading = true;
    newCharacters = await _repository.loadNewCharacters();
    _favouriteCharacters = await _repository.getFavouriteCharacters();
    _characters = await getAllCharacters();
    _isLoading = false;
    notifyListeners();
    for (var character in newCharacters) {
      _repository.saveImageToDeviceFromUrl(character);
    }
    return newCharacters;
  }

  Future<List<Character>> getFavouriteCharacters() async {
    _favouriteCharacters = await _repository.getFavouriteCharacters();
    return favouriteCharacters;
  }

  void addToFavourite(Character character) async {
    await _repository.addToFavourite(character);
    await getFavouriteCharacters();
    for (int i = 0; i < _characters.length; i++) {
      if (character.name == _characters[i].name) {
        var newCharacter = Character.favourite(character);
        _characters[i] = newCharacter;
      }
    }
    notifyListeners();
  }

  void sortFavouriteByName() {
    _favouriteCharacters.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  void sortFavouriteByStatus() {
    _favouriteCharacters.sort(
      (a, b) => a.status.statusText.compareTo(b.status.statusText),
    );
    notifyListeners();
  }

  void sortFavouriteByLocation() {
    _favouriteCharacters.sort((a, b) => a.location.compareTo(b.location));
    notifyListeners();
  }
}
