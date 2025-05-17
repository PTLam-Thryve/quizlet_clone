class Flashcard {
  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    this.setId,
  });
  final String id;//id of a singular flashcard
  final String question;
  final String answer;
  final String? setId; //id of the set

  @override
  String toString() => 'Flashcard(id: $id, question: $question, answer: $answer, setId: $setId)';
}
