import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/widgets/forms/form_fields/color_picker_form.dart';
import 'package:quizlet_clone/ui/widgets/forms/form_fields/flash_card_name_form.dart';

class FlashCardSetForm extends StatelessWidget {
  const FlashCardSetForm({
    required this.formKey,
    required this.colorHex,
    required this.nameController,
    this.nameValidator,
    required this.buttonLabel,
    this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final GlobalKey<FormState> formKey;

  final TextEditingController nameController;

  final TextEditingController colorHex;

  final FormFieldValidator<String>? nameValidator;

  final String buttonLabel;

  final VoidCallback? onPressed;

  final bool isLoading;

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
              ColorPickerForm(
                colorHex: colorHex,
              ),
              const SizedBox(height: 20),
                TextButton(
                  onPressed: onPressed,
                  child: Text(buttonLabel),
                ),
            ],
          ),
        ),
      );
}
