import 'package:flutter/material.dart';

class FlashCardNameForm extends StatelessWidget{
  const FlashCardNameForm({required this.nameController, super.key, this.validator});

  final TextEditingController nameController;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) => TextFormField(
      controller: nameController,
      decoration: const InputDecoration(labelText: 'Name'),
      validator: validator,
      textInputAction: TextInputAction.next,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
}