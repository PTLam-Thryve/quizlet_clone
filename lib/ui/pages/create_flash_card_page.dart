import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/widgets/forms/create_flash_card_set_form.dart';

class CreateFlashCardPage extends StatelessWidget {
  CreateFlashCardPage({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Create Flash Card'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CreateFlashCardSetForm(
                formKey: _formKey, nameController: _nameController),
            TextButton(
              onPressed: (){
                //TODO: Save entered card's data to Firebase
              },
              child: const Text('Create'),
            ),
          ],
        ),
      );
}
