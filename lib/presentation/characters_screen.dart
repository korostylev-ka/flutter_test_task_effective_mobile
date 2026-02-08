import 'dart:io';
import 'package:flutter/foundation.dart';
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
  final _scrollController = ScrollController();

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
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        print('SCroll position is ${_scrollController.offset}');
        Provider.of<CharactersState>(context, listen: false).loadCharacters();
      }
    });
    Provider.of<CharactersState>(context, listen: false).init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<CharactersState>(
        builder: (context, state, child) {
          return Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                ListView.builder(
                  key: PageStorageKey<String>('controller'),
                  controller: _scrollController,
                  itemCount: state.characters.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return CharacterCard(
                      character: state.characters[index],
                      onClickCallback: () {
                        Provider.of<CharactersState>(
                          context,
                          listen: false,
                        ).addToFavourite(state.characters[index]);
                      },
                      image: _loadImage(state.characters[index].image),
                    );
                  },
                ),
                Visibility(
                  visible: state.isLoading,
                  child: CircularProgressIndicator(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
