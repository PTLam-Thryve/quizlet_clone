import 'package:color_hex/color_hex.dart';
import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/constants/app_icons.dart';

//Presents a tile of Flashcard from the the Flashcard Set
class FlashCardSetListTile extends StatelessWidget {
  const FlashCardSetListTile({
    required this.name,
    required this.colorHex,
    required this.flashCardId,
    required this.onNavigateEditPressed,
    super.key,
  });
  final String name;
  final String colorHex;
  final String flashCardId;
  final VoidCallback onNavigateEditPressed;

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
        ),
        trailing: IconButton(
          onPressed: onNavigateEditPressed,
          icon: const Icon(AppIcons.edit),
        ),
      );
}
