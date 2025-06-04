import 'package:flutter/material.dart';

class QuizGameEndPage extends StatelessWidget {
  const QuizGameEndPage(
      {required this.correctAmount, required this.incorrectAmount, super.key});
  final int correctAmount;
  final int incorrectAmount;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Results'),
        ),
        body: Column(
          spacing: 35,
          children: [
            Center(
              child: Text(
                  'Quiz result summary: $correctAmount correct, $incorrectAmount incorrect'),
            ),
          ],
        ),
      );
}
