import 'package:quizlet_clone/data/flashcard_service.dart';
import 'package:quizlet_clone/models/flashcard.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';

sealed class EditFlashcardFormBlocState {
  bool get isSuccessful => this is EditFlashcardFormSuccessState;

  bool get isLoading => this is EditFlashcardFormLoadingState;
}

class EditFlashcardFormInitialState extends EditFlashcardFormBlocState{}

class EditFlashcardFormLoadingState extends EditFlashcardFormBlocState{}

class EditFlashcardFormSuccessState extends EditFlashcardFormBlocState{
  EditFlashcardFormSuccessState(this.flashCard);

  final Flashcard flashCard;
}

class EditFlashcardFormErrorState extends EditFlashcardFormBlocState{
  EditFlashcardFormErrorState(this.error);

  final FlashCardServiceException error;

  String get errorMessage{
    switch(error){
      case FlashCardServicePermissionException():
        return AppTexts.insufficientPermission;
      case InternalFlashCardServiceException():
        return AppTexts.internalError;
      case FlashCardServiceException():
        return AppTexts.unknownError;
    }
  }
}