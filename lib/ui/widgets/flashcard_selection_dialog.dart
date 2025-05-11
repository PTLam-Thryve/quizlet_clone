import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quizlet_clone/models/flash_card_set.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/pages/quiz_game_page.dart';

class FlashcardSelectionDialog extends StatefulWidget {
  const FlashcardSelectionDialog(
      {required this.flashCardSetList,
      super.key});
  final List<FlashCardSet> flashCardSetList;

  @override
  State<FlashcardSelectionDialog> createState() => _FlashcardSelectionDialogState();
}

class _FlashcardSelectionDialogState extends State<FlashcardSelectionDialog> {
  final Set<String> selectedFlashCardSetIds = <String>{};
  @override
  Widget build(BuildContext context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Select 1 or more Categories'),
          content: SizedBox(
            width: double.maxFinite,
            height: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.flashCardSetList.length,
              itemBuilder: (_, index) {
                final flashCardSet = widget.flashCardSetList[index];
                return CheckboxListTile(
                  value:
                      selectedFlashCardSetIds.contains(flashCardSet.id),
                  title: Text(flashCardSet.name),
                  onChanged: (value) {
                    setState(() {
                      if (value == true) {
                        selectedFlashCardSetIds.add(flashCardSet.id);
                      } else {
                        selectedFlashCardSetIds.remove(flashCardSet.id);
                      }
                    });
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                AppTexts.cancel,
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: selectedFlashCardSetIds.isNotEmpty
                  ? () {
                      Navigator.of(context).pop();
                      unawaited(Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => QuizGamePage(
                            selectedFlashCardSetIds:
                                selectedFlashCardSetIds,
                          ),
                        ),
                      ));
                    }
                  : null,
              child: Text(
                AppTexts.start,
                style: selectedFlashCardSetIds.isNotEmpty
                    ? const TextStyle(color: Colors.blue)
                    : const TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      );
}
