import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizlet_clone/data/flash_card_set_service.dart';
import 'package:quizlet_clone/models/flashcard.dart';
import 'package:quizlet_clone/models/quiz_flashcard.dart';

class QuizGameService {
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  Future<List<QuizFlashcard>> getQuizFlashcards(
      final List<String> flashcardSetIds, final String setId) async {
    try {
      final allFlashcardsResult =
          await _fireStore.collectionGroup('flashcards').get();
      final allFlashcards = allFlashcardsResult.docs
          .map((doc) => Flashcard(
                id: doc.id,
                question: doc['question'].toString(),
                answer: doc['answer'].toString(),
                setId: setId,
              ))
          .toList();
      final filteredFlashcardsBySetId = allFlashcards
          .where((flashcard) => flashcardSetIds.contains(flashcard.setId))
          .toList();//compare selected setIds and put them in a list

      final random = Random();

      final selectedFlashcards = List<Flashcard>.from(filteredFlashcardsBySetId)
        ..shuffle(random);//shuffle selected sets

      final quizFlashcards = selectedFlashcards.take(5).map((flashcard) {
        final unrelatedAnswers = selectedFlashcards
            .where((f) => f.id != flashcard.id)//only ids that are different from the answer's id are selected
            .map((f) => f.answer)
            .toList()//compare ids of flashcards within those sets
          ..shuffle(random);
        final options = [flashcard.answer, ...unrelatedAnswers.take(3)]
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
