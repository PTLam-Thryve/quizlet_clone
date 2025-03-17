class Flashcard {
  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
  });
  final String id;//id of the set it belongs to aka FlashcardSetId
  final String question;
  final String answer;
}
