import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizlet_clone/models/flash_card_set.dart';

class FlashCardSetListBloc {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<List<FlashCardSet>> getFlashCard() async {
    final getFromCollection =
        await _fireStore.collection('flashcard-sets').get();

    try {
      return getFromCollection.docs.map((doc) {
        final name = doc['name'].toString();
        final colorHex = doc['color'].toString();
        return FlashCardSet(name: name, colorHex: colorHex);
      }).toList();
    } on FirebaseException catch (e) {
      print('Firebase error from flash_card_set_list_bloc: $e, ${e.message}');
      return [];
    } catch (e) {
      print('Error from flash_card_set_list_bloc: $e');
      return [];
    }
  }
}
