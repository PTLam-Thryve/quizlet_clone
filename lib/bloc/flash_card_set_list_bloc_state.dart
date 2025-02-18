import 'package:quizlet_clone/data/flash_card_set_service.dart';
import 'package:quizlet_clone/models/flash_card_set.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';

sealed class FlashCardSetListState {
  bool get isSuccessful => this is FlashCardSetListSuccessState;

  bool get isLoading => this is FlashCardSetListLoadingState;
}


class FlashCardSetListInitialState extends FlashCardSetListState {}


class FlashCardSetListLoadingState extends FlashCardSetListState {}


class FlashCardSetListSuccessState extends FlashCardSetListState {
  FlashCardSetListSuccessState(this.flashCardSets);

  final List<FlashCardSet> flashCardSets;
}

class FlashCardSetListErrorState extends FlashCardSetListState {

  FlashCardSetListErrorState(this.error);

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
