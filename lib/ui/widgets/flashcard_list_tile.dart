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
          style: TextStyle(fontSize: 20),
        ),
        trailing: Text(
          answer,
          style: TextStyle(fontSize: 20),
        ),
      );
}
