import 'package:flutter/material.dart';
class FlashCardSetListItem extends StatelessWidget {
  const FlashCardSetListItem({required this.name, required this.colorHex, super.key});
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
      tileColor: hexToColor(colorHex),
    );
}
