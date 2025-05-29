import 'package:flutter/material.dart';

class QuizGameEndPage extends StatelessWidget{
  const QuizGameEndPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Results'),
    ),
    body: const Center(
        child: Text('You did it!'),
      ),
  );
}