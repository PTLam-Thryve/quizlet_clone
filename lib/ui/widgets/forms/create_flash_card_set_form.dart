import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/widgets/forms/form_fields/color_picker_form.dart';
import 'package:quizlet_clone/ui/widgets/forms/form_fields/flash_card_name_form.dart';

class CreateFlashCardSetForm extends StatelessWidget {
  const CreateFlashCardSetForm({
    required this.formKey,
    required this.nameController,
    super.key,
    this.nameValidator,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController nameController;

  final FormFieldValidator<String>? nameValidator;

  @override
  Widget build(BuildContext context) => Form(
      key: formKey,
      child: Center(
        child: Column(
          children: [
            FlashCardNameForm(
              nameController: nameController,
              validator: nameValidator,
            ),
            const SizedBox(height: 16),
            const ColorPickerForm(),
          ],
        ),
      ));
}