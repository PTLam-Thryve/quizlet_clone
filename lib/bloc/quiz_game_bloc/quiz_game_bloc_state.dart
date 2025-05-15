import 'package:quizlet_clone/data/quiz_game_service.dart';
import 'package:quizlet_clone/models/quiz_flashcard.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';

sealed class QuizGameBlocState {

  bool get isLoading => this is QuizGameLoadingState;

  bool get isSuccessful => this is QuizGameSuccessState;
}

class QuizGameInitState extends QuizGameBlocState{}

class QuizGameLoadingState extends QuizGameBlocState{}

class QuizGameSuccessState extends QuizGameBlocState{

  QuizGameSuccessState({required this.quizFlashcards});

  final List<QuizFlashcard> quizFlashcards;
}

class QuizGameErrorState extends QuizGameBlocState{
  QuizGameErrorState(this.error);

  final QuizGameServiceException error;

  String get errorMessage {
    switch(error){
      case InsufficientPermissionException():
        return AppTexts.insufficientPermission;
      case InternalErrorException():
        return AppTexts.internalError;
      case GenericFirestoreException():
        return AppTexts.unknownError;
    }
  }
}