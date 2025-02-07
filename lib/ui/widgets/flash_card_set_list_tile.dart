import 'dart:async';

import 'package:color_hex/color_hex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/edit_bloc/edit_flash_card_bloc.dart';
import 'package:quizlet_clone/data/flash_card_set_service.dart';
import 'package:quizlet_clone/ui/constants/app_icons.dart';
import 'package:quizlet_clone/ui/pages/edit_flash_card_page.dart';

//Presents a tile of Flashcard from the the Flashcard Set
class FlashCardSetListTile extends StatelessWidget {
  const FlashCardSetListTile(
      {required this.name, required this.colorHex,super.key});
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
        ),
        trailing: IconButton(
          onPressed: () {
            unawaited(
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (_) => EditFlashCardBloc(FlashCardSetService()),
                    child: EditFlashCardPage(),
                  ),
                ),
              ),
            );
          },
          icon: const Icon(AppIcons.edit),
        ),
      );
}
