import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quizlet_clone/bloc/edit_bloc/edit_flashcard_form_bloc_state.dart';
import 'package:quizlet_clone/data/flashcard_service.dart';

class EditFlashcardFormBloc extends ChangeNotifier{
  EditFlashcardFormBloc(this._flashCardService);

  EditFlashcardFormBlocState _state = EditFlashcardFormInitialState();

  final FlashCardService _flashCardService;

  EditFlashcardFormBlocState get state => _state;

  Future<void> editFlashcard({required String newQuestion,
    required String newAnswer,
    required String flashCardSetId,
    required String flashCardId,
    }) async{
      _state = EditFlashcardFormLoadingState();
      notifyListeners();
    try{
      final flashcardEdit = await _flashCardService.editFlashcard(newQuestion: newQuestion, newAnswer: newAnswer, flashCardSetId: flashCardSetId, flashCardId: flashCardId,);
      _state = EditFlashcardFormSuccessState(flashcardEdit);
    } on FirebaseException catch (error) {
      throw FlashCardServiceException.fromFirebaseException(error);
    } finally {
      notifyListeners();
    }
  }
}