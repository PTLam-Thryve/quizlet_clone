import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizlet_clone/models/flash_card_set.dart';

class FlashCardSetService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<List<FlashCardSet>> getFlashCardSet() async {
    //if nothing is getting fetched, please check and update the expiration date
    //in the rule section of Firestore
    try {
      final getFromCollection =
          await _fireStore.collection('flashcard-sets').get();
      final flashCardSets = getFromCollection.docs.map((doc) {
        final name = doc['name'].toString();
        final colorHex = doc['color'].toString();
        return FlashCardSet(
          name: name,
          colorHex: colorHex,
          id: doc.id,
        );
      }).toList();
      return flashCardSets;
    } on FirebaseException catch (error) {
      throw FlashCardSetServiceException.fromFirebaseException(error);
    } catch (error) {
      rethrow;
    }
  }

  Future<FlashCardSet> createFlashCardSet({
    required String name,
    required String colorHex,
  }) async {
    try {
      final addedFlashCard = await _fireStore.collection('flashcard-sets').add({
        'name': name,
        'color': colorHex,
      });
      final retrievedFlashCard = await addedFlashCard.get();
      if (!retrievedFlashCard.exists) {
        throw GenericFirestoreException();
      } else {
        return FlashCardSet(
          name: retrievedFlashCard['name'].toString(),
          colorHex: retrievedFlashCard['color'].toString(),
          id: retrievedFlashCard.id,
        );
      }
    } on FirebaseException catch (error) {
      throw FlashCardSetServiceException.fromFirebaseException(error);
    } catch (error) {
      rethrow;
    }
  }

  Future<FlashCardSet> editFlashCardSet({
    required String newName,
    required String newColor,
    required String flashCardId,
  }) async {
    try {
      var collection = _fireStore.collection('flashcard-sets');
      await collection.doc(flashCardId).update(
        {
          'name': newName,
          'color': newColor,
        },
      );
      return FlashCardSet(
        name: newName,
        colorHex: newColor,
        id: flashCardId,
      );
    } on FirebaseException catch (error) {
      throw FlashCardSetServiceException.fromFirebaseException(error);
    } catch (error) {
      rethrow;
    }
  }

  Future<FlashCardSet> deleteFlashCardSet({
    required String name,
    required String color,
    required String flashCardId,
  }) async {
    try {
      var collection = _fireStore.collection('flashcard-sets');
      await collection.doc(flashCardId).delete();
      return FlashCardSet(
        name: name,
        colorHex: color,
        id: flashCardId,
      );
    } on FirebaseException catch (error) {
      throw FlashCardSetServiceException.fromFirebaseException(error);
    } catch (error) {
      rethrow;
    }
  }
}

//Class for handling Firestore related exceptions
sealed class FlashCardSetServiceException implements Exception {
  static FlashCardSetServiceException fromFirebaseException(
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

class InsufficientPermissionException extends FlashCardSetServiceException {}

class InternalErrorException extends FlashCardSetServiceException {}

class GenericFirestoreException extends FlashCardSetServiceException {}
