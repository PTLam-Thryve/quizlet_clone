import 'package:quizlet_clone/data/flash_card_set_service.dart';
import 'package:quizlet_clone/models/flash_card_set.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';

sealed class EditFlashCardBlocState {
  bool get isSuccessful => this is EditFlashCardSuccessState;

  bool get isLoading => this is EditFlashCardLoadingState;
}

class EditFlashCardInitialState extends EditFlashCardBlocState{}

class EditFlashCardLoadingState extends EditFlashCardBlocState{}

class EditFlashCardSuccessState extends EditFlashCardBlocState{
  EditFlashCardSuccessState(this.flashCardSet);

  final FlashCardSet flashCardSet;
}

class EditFlashCardErrorState extends EditFlashCardBlocState{
  EditFlashCardErrorState(this.error);

  final FlashCardSetServiceException error;

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