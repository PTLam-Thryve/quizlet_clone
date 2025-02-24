import 'package:flutter/material.dart';

class FlashcardSetDetailPage extends StatelessWidget {
  const FlashcardSetDetailPage({required this.flashCardId, super.key});

  final flashCardId;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Flashcard Detail Page'),
        ),
        body: const Center(
          child: Text('Placeholder Text'),
        ),
      );
}
