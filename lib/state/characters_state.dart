import 'package:flutter/cupertino.dart';
import 'package:test_task_for_effective_mobile/domain/repository.dart';

import '../domain/character.dart';
import '../domain/status.dart';

class CharactersState extends ChangeNotifier {
  late Repository repository;
  List<Character> _characters = List<Character>.generate(5, ((index) {
    return Character(
      name: 'Test name $index',
      image: 'Test image',
      species: 'Test species',
      location: 'Test location',
      status: Status.unknown,
    );
  }));
  List<Character> get characters => _characters;
  List<Character> _favouriteCharacters = List<Character>.generate(5, ((index) {
    return Character(
      name: 'Test favourite name $index',
      image: 'Test image',
      species: 'Test species',
      location: 'Test location',
      status: Status.unknown,
    );
  }));
  List<Character> get favouriteCharacters => _favouriteCharacters;

  Future<List<Character>> getAllCharacters() async {
    notifyListeners();
    return characters;

  }

  Future<void> loadNewCharacters() async {
    notifyListeners();
  }

  Future<List<Character>> getFavouriteCharacters() async {
    notifyListeners();
    return favouriteCharacters;
  }

  void addToFavourite(Character character) async {
    notifyListeners();
  }
}
