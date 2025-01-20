import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizlet_clone/models/flash_card_set.dart';

class FlashCardSetService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<List<FlashCardSet>> getFlashCardSet() async{
    final getFromCollection = await _fireStore.collection('flashcard-sets').get();
    final flashCardSets = getFromCollection.docs.map((doc) {
      final name = doc['name'].toString();
      final colorHex = doc['color'].toString();
      return FlashCardSet(name: name, colorHex: colorHex);
    }).toList();
    return flashCardSets;
  }
}

//Class for handling Firestore related exceptions
sealed class FlashCardSetServiceException implements Exception{
  static FlashCardSetServiceException fromFirebaseException(FirebaseException firebaseException){
    switch(firebaseException.code){
      case 'insufficient-permission':
        return InsufficientPermissionException();
      case 'internal-error':
        return InternalErrorException();
      default:
        return GenericFirestoreException();
    }
  }
}

class InsufficientPermissionException extends FlashCardSetServiceException{}

class InternalErrorException extends FlashCardSetServiceException{}

class GenericFirestoreException extends FlashCardSetServiceException{}