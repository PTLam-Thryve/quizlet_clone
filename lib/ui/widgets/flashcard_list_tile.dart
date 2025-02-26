import 'package:flutter/material.dart';

class FlashcardListTile extends StatelessWidget {
  const FlashcardListTile({
    required this.question,
    required this.answer,
    required this.id,
    super.key,
  });

  final String question;
  final String answer;
  final String id;

  @override
  Widget build(BuildContext context) => ListTile(
        title: Text(
          question,
          style: const TextStyle(fontSize: 20),
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Text(
          answer,
          style: const TextStyle(fontSize: 20),
          overflow: TextOverflow.ellipsis,
        ),
      );
}
