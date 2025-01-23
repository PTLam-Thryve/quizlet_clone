import 'package:flutter/foundation.dart';
import 'package:quizlet_clone/bloc/flash_card_set_list_bloc_state.dart';
import 'package:quizlet_clone/data/flash_card_set_service.dart';

class FlashCardSetListBloc extends ChangeNotifier{

  FlashCardSetListState _state = FlashCardSetListInitialState();

  /// Getter for the current authentication state.
  FlashCardSetListState get state => _state;

  Future<void> getFlashCardSets() async {
    _state = FlashCardSetListLoadingState();
    notifyListeners();

    try {
      final flashCardSetReceived = await FlashCardSetService().getFlashCardSet();
      _state = FlashCardSetListSuccessState(flashCardSetReceived);
    } on FlashCardSetServiceException catch (e) {
      _state = FlashCardSetListErrorState(e);
    } finally {
      notifyListeners();
    }
  }
}
