import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizlet_clone/models/flashcard.dart';

class FlashCardService{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<List<Flashcard>> getFlashcards() async{
    try{
      final getFromCollection = await _fireStore.collection('flashcard').get();
      final flashcards = getFromCollection.docs.map((doc){
        final question = doc['question'].toString();
        final answer = doc['answer'].toString();
        return Flashcard(
          answer: answer,
          question: question,
          id: doc.id,
        );
      }).toList();
      return flashcards;
    } on FirebaseException catch(error){
      throw FlashcardServiceException.fromFirebaseException(error);
    } catch(error){
      rethrow;
    }
  }
}

sealed class FlashcardServiceException implements Exception {
  static FlashcardServiceException fromFirebaseException(
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

class InsufficientPermissionException extends FlashcardServiceException {}

class InternalErrorException extends FlashcardServiceException {}

class GenericFirestoreException extends FlashcardServiceException {}