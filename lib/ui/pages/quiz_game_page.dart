import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';

class QuizGamePage extends StatelessWidget{
  const QuizGamePage({required this.selectedFlashCardSetIds, super.key});
  final Set<String> selectedFlashCardSetIds;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text(AppTexts.quizGameWelcome),
    ),
  );

}