import 'package:quizlet_clone/data/flashcard_service.dart';
import 'package:quizlet_clone/models/flashcard.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';

sealed class FlashCardListState{
  bool get isLoading => this is FlashCardListLoadingState;

  bool get isSuccessful => this is FlashCardListSuccessState;
}

class FlashCardListInitialState extends FlashCardListState {}

class FlashCardListLoadingState extends FlashCardListState {}

class FlashCardListSuccessState extends FlashCardListState{
  FlashCardListSuccessState(this.flashcards);
  final List<Flashcard> flashcards;
}

class FlashCardListErrorState extends FlashCardListState {
  FlashCardListErrorState(this.error);

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