import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/quiz_game_bloc/quiz_game_bloc.dart';
import 'package:quizlet_clone/bloc/quiz_game_bloc/quiz_game_bloc_state.dart';
import 'package:quizlet_clone/data/quiz_game_service.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/pages/quiz_game_end_page.dart';
import 'package:quizlet_clone/ui/widgets/app_progress_indicator.dart';
import 'package:quizlet_clone/ui/widgets/quiz_game_ui.dart';

class QuizGamePage extends StatefulWidget {
  const QuizGamePage(
      {required this.selectedFlashCardSetIds, required this.setId, super.key});
  final List<String> selectedFlashCardSetIds;
  final String setId;

  @override
  State<QuizGamePage> createState() => _QuizGamePageState();
}

class _QuizGamePageState extends State<QuizGamePage> {
  late final QuizGameBloc _quizGameBloc;
  late PageController _pageController;
  final bool canScroll = true;
  int correctSelected = 0;
  int incorrectSelected = 0;

  @override
  void initState() {
    super.initState();
    _quizGameBloc = QuizGameBloc(QuizGameService());
    _quizGameBloc.initQuiz(widget.selectedFlashCardSetIds);
    _pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void _onCorrectAnswerSelected(bool isCorrect) {
    setState(() {
      if (isCorrect) {
        correctSelected++;
      } else {
        incorrectSelected++;
      }
    });
    _pageController.nextPage(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeIn,
    );
    if (_pageController.page ==
        (_quizGameBloc.state as QuizGameSuccessState).quizFlashcards.length -
            1) {
      unawaited(
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => QuizGameEndPage(
              correctAmount: correctSelected,
              incorrectAmount: incorrectSelected,
              totalQuestions: (_quizGameBloc.state as QuizGameSuccessState)
                  .quizFlashcards
                  .length,
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => _quizGameBloc,
        child: Scaffold(
            appBar: AppBar(
              title: const Text(AppTexts.quizGameWelcome),
            ),
            body: Consumer<QuizGameBloc>(
              builder: (context, bloc, child) {
                if (bloc.state.isLoading) {
                  return const Center(
                    child: AppProgressIndicator(),
                  );
                } else if (bloc.state.isSuccessful) {
                  final quizFlashcards =
                      (bloc.state as QuizGameSuccessState).quizFlashcards;
                  return PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {},
                      children: quizFlashcards
                          .map((flashcard) => QuizGameUI(
                                question: flashcard.question,
                                options: flashcard.options,
                                correctAnswer: flashcard.answer,
                                onCorrectSelected: () =>
                                    _onCorrectAnswerSelected(true),
                                onIncorrectSelected: () =>
                                    _onCorrectAnswerSelected(false),
                              ))
                          .toList());
                } else if (bloc.state is QuizGameErrorState) {
                  final errorMessage =
                      (bloc.state as QuizGameErrorState).errorMessage;
                  return Center(
                    child: Text(errorMessage),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            )),
      );
}
