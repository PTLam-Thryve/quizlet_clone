import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizlet_clone/data/flash_card_set_service.dart';
import 'package:quizlet_clone/models/flashcard.dart';
import 'package:quizlet_clone/models/quiz_flashcard.dart';

class QuizGameService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<List<QuizFlashcard>> getQuizFlashcards(
      final List<String> flashcardSetIds) async {
    try {
      final allFlashcardsResult =
          await _fireStore.collectionGroup('flashcards').get();
      final allFlashcards = allFlashcardsResult.docs
          .map((doc) => Flashcard(
                id: doc.id,
                question: doc['question'].toString(),
                answer: doc['answer'].toString(),
                setId: doc['setId'].toString(),
              ))
          .toList();
      final filteredFlashcardsBySetId = allFlashcards
          .where((flashCard) => flashcardSetIds.contains(flashCard.setId))
          .toList();
      final random = Random();

      final selectedFlashcards = List<Flashcard>.from(filteredFlashcardsBySetId)
        ..shuffle(random); //shuffle selected sets

      final quizFlashcards = selectedFlashcards.take(5).map((flashcard) {
        final unrelatedAnswers = selectedFlashcards
            .where((f) =>
                f.id !=
                flashcard
                    .id) //only ids that are different from the answer's id are selected
            .map((f) => f.answer)
            .toList() //compare ids of flashcards within those sets
          ..shuffle(random);
        final options = [flashcard.answer, ...unrelatedAnswers.take(2)]
          ..shuffle(random);
        return QuizFlashcard(
            question: flashcard.question,
            answer: flashcard.answer,
            options: options);
      }).toList();
      return quizFlashcards;
    } on FirebaseException catch (error) {
      throw FlashCardSetServiceException.fromFirebaseException(error);
    } catch (error) {
      rethrow;
    }
  }
}

sealed class QuizGameServiceException implements Exception {
  static QuizGameServiceException fromFirebaseException(
      FirebaseException firebaseException) {
    switch (firebaseException.code) {
      case 'insufficient-permission':
        return InsufficientPermissionException();
      case 'internal-error':
        return InternalErrorException();
      default:
        return GenericFirestoreException();
    }
  }
}

class InsufficientPermissionException extends QuizGameServiceException {}

class InternalErrorException extends QuizGameServiceException {}

class GenericFirestoreException extends QuizGameServiceException {}
