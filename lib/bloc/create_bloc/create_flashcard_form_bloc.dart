import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:quizlet_clone/bloc/create_bloc/create_flashcard_form_bloc_state.dart';
import 'package:quizlet_clone/data/flashcard_service.dart';

class CreateFlashcardFormBloc extends ChangeNotifier {
  CreateFlashcardFormBloc(this._flashCardService);

  CreateFlashcardFormBlocState _state = CreateFlashcardFormInitialState();

  final FlashCardService _flashCardService;

  CreateFlashcardFormBlocState get state => _state;

  Future<void> createFlashcard(
      {required String question,
      required String answer,
      required String flashCardSetId}) async {
    _state = CreateFlashcardLoadingState();
    notifyListeners();
    try {
      final flashCardAdded = await _flashCardService.createFlashcard(
        question: question,
        answer: answer,
        flashCardSetId: flashCardSetId,
      );
      _state = CreateFlashcardSuccessState(flashCardAdded);
    } on FirebaseException catch (error) {
      throw FlashCardServiceException.fromFirebaseException(error);
    } finally{
      notifyListeners();
    }
  }
}
