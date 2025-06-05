import 'package:flutter/material.dart';

class QuizGameEndPage extends StatefulWidget {
  const QuizGameEndPage(
      {required this.correctAmount,
      required this.incorrectAmount,
      required this.totalQuestions,
      super.key});
  final int correctAmount;
  final int incorrectAmount;
  final int totalQuestions;

  @override
  State<QuizGameEndPage> createState() => _QuizGameEndPageState();
}

class _QuizGameEndPageState extends State<QuizGameEndPage> {
  String resultMessage() {
    if (widget.correctAmount == widget.totalQuestions) {
      return 'Flawless victory!';
    } else if (widget.correctAmount == 0) {
      return 'Oh...';
    } else {
      return 'Better luck next time!';
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Results'),
        ),
        body: Column(
          spacing: 40,
          children: [
            const Center(
              child: Text(
                'Result summary: ',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(50),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  '${widget.correctAmount}/${widget.totalQuestions} correct!',
                  style: const TextStyle(
                    fontSize: 25,
                  ),
                ),
              ),
            ),
            Center(
              child: Text(resultMessage()),
            )
          ],
        ),
      );
}
