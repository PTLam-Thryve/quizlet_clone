import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/edit_bloc/edit_flashcard_form_bloc.dart';
import 'package:quizlet_clone/data/flashcard_service.dart';
import 'package:quizlet_clone/ui/pages/edit_flashcard_page.dart';

class FlashcardListTile extends StatelessWidget {
  const FlashcardListTile({
    required this.question,
    required this.answer,
    required this.id,
    required this.flashCardId,
    super.key,
  });

  final String question;
  final String answer;
  final String id;
  final String flashCardId;

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(
          question,
          style: const TextStyle(fontSize: 20),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          answer,
          style: const TextStyle(fontSize: 20),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: IconButton(
          onPressed: () {
            unawaited(Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                      create: (_) => EditFlashcardFormBloc(FlashCardService()),
                      child: EditFlashcardPage(
                          flashCardId: flashCardId,
                          flashCardSetId: id),
                    ))));
          },
          icon: const Icon(Icons.edit),
        ),
      );
}
