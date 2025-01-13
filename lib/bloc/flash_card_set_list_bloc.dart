import 'package:cloud_firestore/cloud_firestore.dart';

class FlashCardSetListBloc {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<void> getFlashCard() async {
    final getFromCollection =
        await _fireStore.collection('flashcard-sets').get();

    try {
      for (var card in getFromCollection.docs) {
        final name = card['name'];
        final colorHex = card['color'];

        print('Name: $name, Color: $colorHex');
      }
    } on FirebaseException catch (e) {
      print('Firebase error from flash_card_set_list_bloc: $e, ${e.message}');
    } catch(e){
      print('Error from flash_card_set_list_bloc: $e');
    }
  }
}
