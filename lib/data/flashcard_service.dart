import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizlet_clone/models/flashcard.dart';

class FlashCardService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<List<Flashcard>> getFlashcards(final String flashCardSetid) async {
    try {
      final getFromCollection = await _fireStore
          .collection('flashcard-sets')
          .doc(flashCardSetid)
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
          id: doc.id
        );
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
      });
      final retrievedFlashCard = await addedFlashcard.get();
      if (!retrievedFlashCard.exists) {
        throw GenericFirestoreException();
      } else {
        return Flashcard(
          id: flashCardSetId,
          question: question,
          answer: answer,
        );
      }
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
        return InsufficientPermissionException();
      case 'internal-error':
        return InternalErrorException();
      default:
        return GenericFirestoreException();
    }
  }
}

class InsufficientPermissionException extends FlashCardServiceException {}

class InternalErrorException extends FlashCardServiceException {}

class GenericFirestoreException extends FlashCardServiceException {}
