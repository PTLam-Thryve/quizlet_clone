class QuizFlashcard {
  QuizFlashcard({
    required this.question,
    required this.answer,
    required this.options,
  });
  final String question;
  final String answer;
  final List<String> options;

  @override
  String toString() => '(question: $question, answer: $answer, options: $options)';
  //this is for checking if everything is added correctly
}
