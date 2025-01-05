import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';

class EmailFormField extends StatelessWidget {
  const EmailFormField({required this.controller, super.key, this.validator});

  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: controller,
        decoration: const InputDecoration(labelText: AppTexts.email),
        validator: validator,
        autocorrect: false,
        textInputAction: TextInputAction.next,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      );
}
