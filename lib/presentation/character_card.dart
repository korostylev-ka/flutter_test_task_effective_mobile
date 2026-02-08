import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../domain/character.dart';
import '../resources/decorations.dart';
import '../resources/dimens.dart';
import '../resources/strings.dart';
import '../resources/text_styles.dart';
import '../state/characters_state.dart';

class CharacterCard extends StatefulWidget {
  const CharacterCard({
    super.key,
    required this.character,
    required this.image,
    required this.onClickCallback,
  });

  final Character character;
  final void Function() onClickCallback;
  final Image image;

  @override
  State<CharacterCard> createState() => _CharacterCardState();
}

class _CharacterCardState extends State<CharacterCard> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: Decorations.characterCardDecoration,
      margin: EdgeInsets.all(Dimens.marginCharacterCardContainer),
      padding: EdgeInsets.all(Dimens.paddingCharacterCardContainer),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: widget.image,
            ),
          ),
          SizedBox(width: Dimens.spaceBetweenBlocks),
          Expanded(
            flex: 4,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Strings.name, style: TextStyles.characterCardField),
                      SizedBox(width: Dimens.spaceBetweenTextFields),
                      Expanded(child: Text(widget.character.name)),
                    ],
                  ),
                  SizedBox(height: Dimens.spaceBetweenTextFields),
                  Row(
                    children: [
                      Text(
                        Strings.status,
                        style: TextStyles.characterCardField,
                      ),
                      SizedBox(width: Dimens.spaceBetweenTextFields),
                      Text(widget.character.status.statusText),
                    ],
                  ),
                  SizedBox(height: Dimens.spaceBetweenTextFields),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Strings.location,
                        style: TextStyles.characterCardField,
                      ),
                      SizedBox(width: Dimens.spaceBetweenTextFields),
                      Expanded(child: Text(widget.character.location)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: FittedBox(
              child: IconButton(
                onPressed: () {
                  widget.onClickCallback();
                },
                icon: widget.character.isFavourite
                    ? Icon(Icons.star, color: Colors.red)
                    : Icon(Icons.star_border_outlined),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
