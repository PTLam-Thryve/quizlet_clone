import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizlet_clone/bloc/flash_card_set_list_bloc_state.dart';
import 'package:quizlet_clone/models/flash_card_set.dart';
import 'package:flutter/foundation.dart';

class FlashCardSetListBloc extends ChangeNotifier{
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  FlashCardSetListState _state = FlashCardSetListInitialState();

  /// Getter for the current authentication state.
  FlashCardSetListState get state => _state;

  Future<void> getFlashCardSets() async {
    _state = FlashCardSetListLoadingState();
    notifyListeners();

    try {
      final getFromCollection =
        await _fireStore.collection('flashcard-sets').get();
        final flashCardSets = getFromCollection.docs.map((doc) {
        final name = doc['name'].toString();
        final colorHex = doc['color'].toString();
        return FlashCardSet(name: name, colorHex: colorHex);
      }).toList();
      _state = FlashCardSetListSuccessState(flashCardSets);
    } on FirebaseException catch (e) {
      _state = FlashCardSetListErrorState(e);
    } catch (e) {
      _state = FlashCardSetListErrorState(Exception('An unknown error occurred.'));
    } finally {
      notifyListeners();
    }
  }
}
