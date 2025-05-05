import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';

class QuizGamePage extends StatelessWidget{
  const QuizGamePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(AppTexts.quizGameWelcome),
    ),
  );

}