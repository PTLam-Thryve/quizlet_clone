import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizlet_clone/models/flashcard.dart';

class FlashCardService{
  FlashCardService(this.flashCardSetid){
    if(flashCardSetid.isEmpty){
      throw ArgumentError('FlashCardSetid is empty!');
    }
  }
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final String flashCardSetid;

  Future<List<Flashcard>> getFlashcards() async{
    try{
      final getFromCollection = await _fireStore.collection('flashcard-sets').doc(flashCardSetid).collection('flashcards').get();
      final flashcards = getFromCollection.docs.map((doc){
        final question = doc.data().containsKey('question')?doc['question'].toString():'';
        final answer = doc.data().containsKey('answer')?doc['answer'].toString():'';
        return Flashcard(
          answer: answer,
          question: question,
          id: doc.id,
        );
      }).toList();
      return flashcards;
    } on FirebaseException catch(error){
      throw FlashCardServiceException.fromFirebaseException(error);
    } catch(error){
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

class InternalErrorException extends FlashCardServiceException{}

class GenericFirestoreException extends FlashCardServiceException {}