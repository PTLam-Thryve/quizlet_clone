import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizlet_clone/bloc/create_bloc/create_flash_card_set_form_bloc_state.dart';
import 'package:quizlet_clone/data/flash_card_set_service.dart';

class CreateFlashCardSetFormBloc extends ChangeNotifier {
  CreateFlashCardSetFormBloc(this._flashCardSetService);

  CreateFlashCardSetFormBlocState _state = CreateFlashCardInitialState();

  final FlashCardSetService _flashCardSetService;

  CreateFlashCardSetFormBlocState get state => _state;

  Future<void> createFlashCardSet(
      {required String name, required String colorHex}) async {
    _state = CreateFlashCardLoadingState();
    notifyListeners();
    try {
      final flashCardSetAdded = await _flashCardSetService.createFlashCardSet(
        name: name,
        colorHex: colorHex,
      );
      _state = CreateFlashCardSuccessState(flashCardSetAdded);
    } on FirebaseException catch (error) {
      throw FlashCardSetServiceException.fromFirebaseException(error);
    } finally {
      notifyListeners();
    }
  }
}
