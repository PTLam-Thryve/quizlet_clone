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
      return 'Perfect!';
    } else if (widget.correctAmount == 0) {
      return 'Oh...';
    } else {
      return 'Better luck next time!';
    }
  }

  String resultImageFile() {
    if (widget.correctAmount == widget.totalQuestions) {
      return 'lib/asset/result_images/perfect.png';
    } else if (widget.correctAmount == 0) {
      return 'lib/asset/result_images/zero.png';
    } else {
      return 'lib/asset/result_images/some.png';
    }
  }

  Color resultColor(){
    if (widget.correctAmount == widget.totalQuestions) {
      return Colors.green.withAlpha(50);
    } else if (widget.correctAmount == 0) {
      return Colors.red.withAlpha(70);
    } else {
      return Colors.yellow.withAlpha(60);
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
                  color: resultColor(),
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
              child: Text(
                resultMessage(),
                style: const TextStyle(fontSize: 25),
              ),
            ),
            Center(
              child: SizedBox(
                child: Image.asset(
                  resultImageFile(),
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
      );
}
