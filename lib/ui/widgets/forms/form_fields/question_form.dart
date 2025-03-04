import 'package:flutter/material.dart';

class QuestionForm extends StatelessWidget {
  const QuestionForm({
    required this.questionController,
    required this.validator,
    super.key,
  });

  final TextEditingController questionController;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) => TextFormField(
      controller: questionController,
      decoration: const InputDecoration(labelText: 'Question'),
      validator: validator,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 50,
    );
}
