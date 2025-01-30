import 'package:color_hex/color_hex.dart';
import 'package:flutter/material.dart';

//Presents a tile of Flashcard from the the Flashcard Set
class FlashCardSetListTile extends StatelessWidget {
  const FlashCardSetListTile({required this.name, required this.colorHex, super.key});
  final String name;
  final String colorHex;

  //Converts hex code to RGB color for Flutter
  Color hexToColor(String hexCode) => Color(
        int.parse(
          hexCode.replaceFirst('#', '0xFF'),
        ),
      );

  @override
  Widget build(BuildContext context) => ListTile(
      title: Text(name),
      leading: CircleAvatar(
        backgroundColor: colorHex.convertToColor,
      )
    );
}
