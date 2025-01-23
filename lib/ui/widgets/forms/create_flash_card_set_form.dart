import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/widgets/forms/form_fields/flash_card_name_form.dart';

class CreateFlashCardSetForm extends StatelessWidget {
  const CreateFlashCardSetForm({
    required this.formKey,
    required this.nameController,
    super.key,
    this.validator,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController nameController;

  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) => Form(
      key: formKey,
      child: Center(
        child: Column(
          children: [
            FlashCardNameForm(
              nameController: nameController,
              validator: validator,
            ),
          ],
        ),
      ));
}
