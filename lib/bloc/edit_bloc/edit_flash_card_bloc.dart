import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizlet_clone/bloc/edit_bloc/edit_flash_card_bloc_state.dart';
import 'package:quizlet_clone/data/flash_card_set_service.dart';

class EditFlashCardBloc extends ChangeNotifier {
  EditFlashCardBloc(this._flashCardSetService);

  EditFlashCardBlocState _state = EditFlashCardInitialState();

  final FlashCardSetService _flashCardSetService;

  EditFlashCardBlocState get state => _state;

  Future<void> editFlashCardSet({
    required String newName,
    required String newColor,
    required String flashCardId,
  }) async {
    _state = EditFlashCardLoadingState();
    notifyListeners();
    try {
      final flashCardSetEdited = await _flashCardSetService.editFlashCardSet(
        newName: newName,
        newColor: newColor,
        flashCardId: flashCardId,
      );
      _state = EditFlashCardSuccessState(flashCardSetEdited);
    } on FirebaseException catch (error) {
      throw FlashCardSetServiceException.fromFirebaseException(error);
    } finally {
      notifyListeners();
    }
  }
}
