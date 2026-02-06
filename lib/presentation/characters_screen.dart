import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task_for_effective_mobile/state/characters_state.dart';

import 'character_card.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {

  @override
  void initState() {
    Provider.of<CharactersState>(context, listen: false).init();
    super.initState();
  }

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
