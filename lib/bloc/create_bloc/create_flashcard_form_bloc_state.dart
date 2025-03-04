import 'package:quizlet_clone/data/flashcard_service.dart';
import 'package:quizlet_clone/models/flashcard.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';

sealed class CreateFlashcardFormBlocState {
  bool get isSuccessful => this is CreateSuccessState;

  bool get isLoading => this is CreateLoadingState;
}

class CreateInitialState extends CreateFlashcardFormBlocState {}

class CreateLoadingState extends CreateFlashcardFormBlocState {}

class CreateSuccessState extends CreateFlashcardFormBlocState {
  CreateSuccessState(this.flashcard,);

  final Flashcard flashcard;
}

class CreateErrorState extends CreateFlashcardFormBlocState {
  CreateErrorState(this.error);

  final FlashCardServiceException error;

  String get errorMessage {
    switch (error) {
      case InsufficientPermissionException():
        return AppTexts.insufficientPermission;
      case InternalErrorException():
        return AppTexts.internalError;
      case GenericFirestoreException():
        return AppTexts.unknownError;
    }
  }
}
