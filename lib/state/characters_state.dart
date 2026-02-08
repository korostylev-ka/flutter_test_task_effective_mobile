import 'package:flutter/cupertino.dart';
import '../data/repository_impl.dart';
import '../domain/character.dart';

class CharactersState extends ChangeNotifier {
  final _repository = RepositoryImpl();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Character> _characters = [];
  List<Character> get characters => _characters;
  List<Character> _favouriteCharacters = [];
  List<Character> get favouriteCharacters => _favouriteCharacters;

  void init() async {
    if (_characters.isEmpty) {
      loadCharacters();
    }
  }

  Future<List<Character>> getAllCharacters() async {
    _characters = await _repository.getAllCharacters();
    notifyListeners();
    return _characters;
  }

  Future<void> loadCharacters() async {
    _isLoading = true;
    await _repository.loadNewCharacters();
    _favouriteCharacters = await _repository.getFavouriteCharacters();
    _characters = await getAllCharacters();
    _isLoading = false;
    notifyListeners();
  }

  Future<List<Character>> getFavouriteCharacters() async {
    _favouriteCharacters = await _repository.getFavouriteCharacters();
    notifyListeners();
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
