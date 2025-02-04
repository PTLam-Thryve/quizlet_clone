import 'package:quizlet_clone/data/flash_card_set_service.dart';
import 'package:quizlet_clone/models/flash_card_set.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';

sealed class CreateFlashCardSetFormBlocState {
  bool get isSuccessful => this is CreateFlashCardSuccessState;

  bool get isLoading => this is CreateFlashCardLoadingState;
}

class CreateFlashCardInitialState extends CreateFlashCardSetFormBlocState{}

class CreateFlashCardLoadingState extends CreateFlashCardSetFormBlocState{}

class CreateFlashCardSuccessState extends CreateFlashCardSetFormBlocState{
  CreateFlashCardSuccessState(this.flashCardSet);

  final FlashCardSet flashCardSet;
}

class CreateFlashCardErrorState extends CreateFlashCardSetFormBlocState{
  CreateFlashCardErrorState(this.error);

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