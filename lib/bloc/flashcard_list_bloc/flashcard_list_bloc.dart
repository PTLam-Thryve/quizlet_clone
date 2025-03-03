import 'package:flutter/foundation.dart';
import 'package:quizlet_clone/bloc/flashcard_list_bloc/flashcard_list_bloc_state.dart';
import 'package:quizlet_clone/data/flashcard_service.dart';

class FlashCardListBloc extends ChangeNotifier{
  FlashCardListBloc(this._flashCardService);

  FlashCardListState _state = FlashCardListInitialState();

  FlashCardListState get state => _state;

  final FlashCardService _flashCardService;

  Future<void> getFlashcards(final String flashCardSetid) async{
    _state = FlashCardListLoadingState();
    notifyListeners();

    try{
      final flashCardsReceived = await _flashCardService.getFlashcards(flashCardSetid);
      _state = FlashCardListSuccessState(flashCardsReceived);
    } on FlashCardServiceException catch(e){
      _state = FlashCardListErrorState(e);
    } finally{
      notifyListeners();
    }
  }
}