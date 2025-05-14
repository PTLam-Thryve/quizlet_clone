class QuizFlashcard {
  QuizFlashcard({
    required this.question,
    required this.answer,
    required this.options,
  });
  final String question;
  final String answer;
  final List<String> options;
}
