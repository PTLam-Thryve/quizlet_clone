import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/widgets/forms/form_fields/answer_form.dart';
import 'package:quizlet_clone/ui/widgets/forms/form_fields/question_form.dart';

class FlashcardForm extends StatelessWidget {
  const FlashcardForm(
      {required this.formKey,
      required this.questionController,
      required this.questionValidator,
      required this.answerController,
      required this.answerValidator,
      required this.onPressed,
      this.isLoading = false,
      required this.buttonLabel,
      super.key});

  final GlobalKey<FormState> formKey;

  final TextEditingController questionController;

  final FormFieldValidator<String>? questionValidator;

  final TextEditingController answerController;

  final FormFieldValidator<String>? answerValidator;

  final String buttonLabel;

  final VoidCallback? onPressed;

  final bool isLoading;
  @override
  Widget build(BuildContext context) => Form(
        key: formKey,
        child: Column(
          children: [
            QuestionForm(
              questionController: questionController,
              validator: questionValidator,
            ),
            const SizedBox(height: 20),
            AnswerForm(
              answerController: answerController,
              validator: answerValidator,
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: onPressed,
              child: Text(buttonLabel),
            ),
          ],
        ),
      );
}
