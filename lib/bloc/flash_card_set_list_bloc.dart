import 'package:flutter/foundation.dart';
import 'package:quizlet_clone/bloc/flash_card_set_list_bloc_state.dart';
import 'package:quizlet_clone/data/flash_card_set_service.dart';

class FlashCardSetListBloc extends ChangeNotifier {
  FlashCardSetListBloc(this._flashCardSetService);

  FlashCardSetListState _state = FlashCardSetListInitialState();

  /// Getter for the current flashCardSetList state.
  FlashCardSetListState get state => _state;

  final FlashCardSetService _flashCardSetService;

  Future<void> getFlashCardSets() async {
    _state = FlashCardSetListLoadingState();
    notifyListeners();

    try {
      final flashCardSetReceived = await _flashCardSetService.getFlashCardSet();
      _state = FlashCardSetListSuccessState(flashCardSets: flashCardSetReceived);
    } on FlashCardSetServiceException catch (e) {
      _state = FlashCardSetListErrorState(e);
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteFlashCardSetById({
    required String name,
    required String color,
    required String flashCardId,
  }) async {
    final cachedSuccessState = _state as FlashCardSetListSuccessState;
    _state = FlashCardSetListLoadingState();
    notifyListeners();

    try {
      await _flashCardSetService.deleteFlashCardSet(
        name: name,
        color: color,
        flashCardId: flashCardId,
      );
      final flashCardSetReceived = await _flashCardSetService.getFlashCardSet();
      _state = FlashCardSetListSuccessState(
        flashCardSets: flashCardSetReceived,
        isFirstLoad: false,
      );
    } on FlashCardSetServiceException catch (e) {
      _state = FlashCardSetListSuccessState(
        flashCardSets: cachedSuccessState.flashCardSets,
        deletionError: e,
        isFirstLoad: false,
      );
    } finally {
      notifyListeners();
    }
  }
}
