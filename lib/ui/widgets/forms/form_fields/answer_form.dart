import 'package:flutter/material.dart';

class AnswerForm extends StatelessWidget {
  const AnswerForm({
    required this.answerController,
    required this.validator,
    super.key,
  });

  final TextEditingController answerController;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) => TextFormField(
      controller: answerController,
      decoration: const InputDecoration(labelText: 'Answer'),
      validator: validator,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      maxLength: 50,
    );
}
