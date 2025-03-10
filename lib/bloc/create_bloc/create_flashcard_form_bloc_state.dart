import 'package:quizlet_clone/data/flashcard_service.dart';
import 'package:quizlet_clone/models/flashcard.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';

sealed class CreateFlashcardFormBlocState {
  bool get isSuccessful => this is CreateFlashcardSuccessState;

  bool get isLoading => this is CreateFlashcardLoadingState;
}

class CreateFlashcardFormInitialState extends CreateFlashcardFormBlocState {}

class CreateFlashcardLoadingState extends CreateFlashcardFormBlocState {}

class CreateFlashcardSuccessState extends CreateFlashcardFormBlocState {
  CreateFlashcardSuccessState(this.flashcard,);

  final Flashcard flashcard;
}

class CreateFlashcardErrorState extends CreateFlashcardFormBlocState {
  CreateFlashcardErrorState(this.error);

  final FlashCardServiceException error;

  String get errorMessage {
    switch (error) {
      case FlashCardServicePermissionException():
        return AppTexts.insufficientPermission;
      case InternalFlashCardServiceException():
        return AppTexts.internalError;
      case GenericFlashCardServiceException():
        return AppTexts.unknownError;
    }
  }
}
