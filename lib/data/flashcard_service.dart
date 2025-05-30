import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizlet_clone/models/flashcard.dart';

class FlashCardService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<List<Flashcard>> getFlashcards(final String flashCardSetId) async {
    try {
      final getFromCollection = await _fireStore
          .collection('flashcard-sets')
          .doc(flashCardSetId)
          .collection('flashcards')
          .get();
      final flashcards = getFromCollection.docs.map((doc) {
        final question = doc.data().containsKey('question')
            ? doc['question'].toString()
            : '';
        final answer =
            doc.data().containsKey('answer') ? doc['answer'].toString() : '';
        return Flashcard(
            answer: answer,
            question: question,
            id: doc.id,
            setId: flashCardSetId);
      }).toList();
      return flashcards;
    } on FirebaseException catch (error) {
      throw FlashCardServiceException.fromFirebaseException(error);
    } catch (error) {
      rethrow;
    }
  }

  Future<Flashcard> createFlashcard(
      {required String question,
      required String answer,
      required String flashCardSetId}) async {
    try {
      final addedFlashcard = await _fireStore
          .collection('flashcard-sets')
          .doc(flashCardSetId)
          .collection('flashcards')
          .add({
        'question': question,
        'answer': answer,
        'setId': flashCardSetId,
      });
      return Flashcard(
        id: addedFlashcard.id,
        question: question,
        answer: answer,
        setId: flashCardSetId,
      );
    } on FirebaseException catch (error) {
      throw FlashCardServiceException.fromFirebaseException(error);
    } catch (error) {
      rethrow;
    }
  }

  Future<Flashcard> editFlashcard({
    required String newQuestion,
    required String newAnswer,
    required String flashCardSetId,
    required String flashCardId,
  }) async {
    try {
      var flashcardCollection = _fireStore
          .collection('flashcard-sets')
          .doc(flashCardSetId)
          .collection('flashcards');
      await flashcardCollection.doc(flashCardId).update({
        'question': newQuestion,
        'answer': newAnswer,
      });
      return Flashcard(
        id: flashCardId,
        setId: flashCardSetId,
        question: newQuestion,
        answer: newAnswer,
      );
    } on FirebaseException catch (error) {
      throw FlashCardServiceException.fromFirebaseException(error);
    } catch (error) {
      rethrow;
    }
  }

  Future<Flashcard> deleteFlashcardById({
    required String question,
    required String answer,
    required String flashcardSetId,
    required String flashcardId,
  }) async {
    try {
      var flashcardCollection = _fireStore
          .collection('flashcard-sets')
          .doc(flashcardSetId)
          .collection('flashcards');
      await flashcardCollection.doc(flashcardId).delete();
      return Flashcard(
        id: flashcardId,
        setId: flashcardSetId,
        question: question,
        answer: answer,
      );
    } on FirebaseException catch (error) {
      throw FlashCardServiceException.fromFirebaseException(error);
    } catch (error) {
      rethrow;
    }
  }
}

sealed class FlashCardServiceException implements Exception {
  static FlashCardServiceException fromFirebaseException(
      FirebaseException firebaseException) {
    switch (firebaseException.code) {
      case 'insufficient-permission':
        return FlashCardServicePermissionException();
      case 'internal-error':
        return InternalFlashCardServiceException();
      default:
        return GenericFlashCardServiceException();
    }
  }
}

class FlashCardServicePermissionException extends FlashCardServiceException {}

class InternalFlashCardServiceException extends FlashCardServiceException {}

class GenericFlashCardServiceException extends FlashCardServiceException {}
