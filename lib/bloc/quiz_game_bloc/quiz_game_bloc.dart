import 'package:flutter/material.dart';
import 'package:quizlet_clone/bloc/quiz_game_bloc/quiz_game_bloc_state.dart';
import 'package:quizlet_clone/data/quiz_game_service.dart';

class QuizGameBloc extends ChangeNotifier {
  QuizGameBloc(this._quizGameService);

  QuizGameBlocState _state = QuizGameInitState();

  QuizGameBlocState get state => _state;

  final QuizGameService _quizGameService;

  Future<void> initQuiz(
      final List<String> flashcardSetIds) async {
    _state = QuizGameLoadingState();
    notifyListeners();

    try {
      final quizFlashcardsReceived =
          await _quizGameService.getQuizFlashcards(flashcardSetIds);
      _state = QuizGameSuccessState(quizFlashcards: quizFlashcardsReceived);
    } on QuizGameServiceException catch (e) {
      _state = QuizGameErrorState(e);
    } finally {
      notifyListeners();
    }
  }
}
