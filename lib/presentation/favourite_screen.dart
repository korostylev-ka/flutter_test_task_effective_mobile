import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/characters_state.dart';
import 'character_card.dart';

class FavouriteScreen extends StatefulWidget {
  const FavouriteScreen({super.key});

  @override
  State<FavouriteScreen> createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<CharactersState>(
        builder: (context, state, child) {
          return Center(
            child: ListView.builder(
              itemCount: state.characters.length,
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CharacterCard(character: state.characters[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
