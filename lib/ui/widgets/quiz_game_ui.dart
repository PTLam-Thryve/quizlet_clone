import 'package:flutter/material.dart';

class QuizGameUI extends StatefulWidget {
  const QuizGameUI(
      {required this.question,
      required this.options,
      required this.correctAnswer,
      required this.onCorrectSelected,
      super.key});
  final String question;
  final List<String> options;
  final String correctAnswer;
  final VoidCallback onCorrectSelected;

  @override
  State<QuizGameUI> createState() => _QuizGameUIState();
}

class _QuizGameUIState extends State<QuizGameUI> {
  int? _selectedOption;
  @override
  Widget build(BuildContext context) => Column(
        spacing: 30,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.deepPurple.withAlpha(50),
              ),
              child: Text(
                widget.question,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          ListView.builder(
              shrinkWrap: true,
              itemCount: widget.options.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedOption == index;
                final isCorrect = widget.options[index] == widget.correctAnswer;
                final tileColor = isSelected
                    ? (isCorrect
                        ? Colors.green.withAlpha(50)
                        : Colors.red.withAlpha(50))
                    : Colors.deepPurple.withAlpha(50);
                return Center(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: tileColor
                    ),
                    child: InkWell(
                      child: ListTile(
                        title: Text(widget.options[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                            )),
                        tileColor: tileColor,
                      ),
                      onTap: () {
                        setState(() {
                          _selectedOption = index;
                          if (isCorrect) {
                            widget.onCorrectSelected();
                          }
                        });
                      },
                    ),
                  ),
                );
              }),
        ],
      );
}
