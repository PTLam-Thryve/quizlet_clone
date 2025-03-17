import 'package:flutter/foundation.dart';
import 'package:quizlet_clone/bloc/flashcard_list_bloc/flashcard_list_bloc_state.dart';
import 'package:quizlet_clone/data/flashcard_service.dart';

class FlashCardListBloc extends ChangeNotifier {
  FlashCardListBloc(this._flashCardService);

  FlashCardListState _state = FlashCardListInitialState();

  FlashCardListState get state => _state;

  final FlashCardService _flashCardService;

  Future<void> getFlashcards(final String flashCardSetid) async {
    _state = FlashCardListLoadingState();
    notifyListeners();

    try {
      final flashCardsReceived =
          await _flashCardService.getFlashcards(flashCardSetid);
      _state = FlashCardListSuccessState(flashcards: flashCardsReceived);
    } on FlashCardServiceException catch (e) {
      _state = FlashCardListErrorState(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteFlashcardById(
    final String question,
    final String answer,
    final String flashcardSetId,
    final String flashcardId,
  ) async {
    final cachedSuccessState = _state as FlashCardListSuccessState;
    _state = FlashCardListLoadingState();
    notifyListeners();

    try {
      await _flashCardService.deleteFlashcardById(
        question: question,
        answer: answer,
        flashcardSetId: flashcardSetId,
        flashcardId: flashcardId,
      );
      final flashcardReceived =
          await _flashCardService.getFlashcards(flashcardSetId);
      _state = FlashCardListSuccessState(
        flashcards: flashcardReceived,
        isFirstLoad: false,
        //the get flashcard method is used again, which means it is not the first load
      );
    } on FlashCardServiceException catch (e) {
      _state = FlashCardListSuccessState(
        flashcards: cachedSuccessState.flashcards,
        isFirstLoad: false,
        deletionError: e,
      );
    } finally {
      notifyListeners();
    }
  }
}
