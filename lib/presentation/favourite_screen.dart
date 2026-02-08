import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../resources/strings.dart';
import '../state/characters_state.dart';
import 'character_card.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  void sortByName() {
    Provider.of<CharactersState>(context, listen: false).sortFavouriteByName();
  }

  void sortByStatus() {
    Provider.of<CharactersState>(
      context,
      listen: false,
    ).sortFavouriteByStatus();
  }

  void sortByLocation() {
    Provider.of<CharactersState>(
      context,
      listen: false,
    ).sortFavouriteByLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<CharactersState>(
        builder: (context, state, child) {
          return Container(
            child: Column(
              children: [
                Container(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(Strings.sort),
                        PopupMenuButton(
                          icon: Icon(Icons.sort),
                          tooltip: Strings.sort,
                          itemBuilder: (context) {
                            return [
                              PopupMenuItem(
                                child: Text(Strings.sortByName),
                                onTap: () {
                                  sortByName();
                                },
                              ),
                              PopupMenuItem(
                                child: Text(Strings.sortByStatus),
                                onTap: () {
                                  sortByStatus();
                                },
                              ),
                              PopupMenuItem(
                                child: Text(Strings.sortByLocation),
                                onTap: () {
                                  sortByLocation();
                                },
                              ),
                            ];
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.favouriteCharacters.length,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return CharacterCard(
                        character: state.favouriteCharacters[index],
                        image: Image.network(
                          state.favouriteCharacters[index].image),

                        //image: Image.file(File(state.favouriteCharacters[index].image)),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
