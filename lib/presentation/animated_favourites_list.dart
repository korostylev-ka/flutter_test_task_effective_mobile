import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_task_for_effective_mobile/state/characters_state.dart';
import '../domain/character.dart';
import 'character_card.dart';

class AnimatedFavouritesList extends StatefulWidget {
  const AnimatedFavouritesList({super.key, required this.favourites});
  final List<Character> favourites;

  @override
  State<AnimatedFavouritesList> createState() => _AnimatedFavouritesListState();
}

class _AnimatedFavouritesListState extends State<AnimatedFavouritesList> {
  final GlobalKey<AnimatedListState> _animatedListKey = GlobalKey();

  Image _loadImage(String imageName) {
    if (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.windows ||
        defaultTargetPlatform == TargetPlatform.iOS) {
      try {
        final file = File(imageName);
        final imageFromCache = Image.file(file);
        return imageFromCache;
      } catch (e) {
        return Image.network(
          imageName,
          errorBuilder: (context, object, stacktrace) {
            return Image.asset('assets/images/no_photo.jpg');
          },
        );
      }
    } else {
      return Image.network(
        imageName,
        errorBuilder: (context, object, stacktrace) {
          return Image.asset('assets/images/no_photo.jpg');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _animatedListKey,
      initialItemCount: widget.favourites.length,
      itemBuilder: (context, index, animation) {
        return _buildCharacterItem(widget.favourites[index], animation);
      },
    );
  }

  Widget _buildCharacterItem(Character character, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: CharacterCard(
        character: character,
        image: _loadImage(character.image),
        onClickCallback: () {
          _removeFavourite(character);
        },
      ),
    );
  }

  void _removeFavourite(Character character) async {
    _animatedListKey.currentState!.removeItem(
      widget.favourites.indexOf(character),
      (context, animation) => _buildCharacterItem(character, animation),
    );
    Provider.of<CharactersState>(
      context,
      listen: false,
    ).addToFavourite(character);
  }
}
