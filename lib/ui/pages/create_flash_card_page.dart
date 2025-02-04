import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/create_bloc/create_flash_card_set_form_bloc.dart';
import 'package:quizlet_clone/bloc/create_bloc/create_flash_card_set_form_bloc_state.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/router/app_router.dart';
import 'package:quizlet_clone/ui/utils/show_app_snack_bar.dart';
import 'package:quizlet_clone/ui/widgets/forms/create_flash_card_set_form.dart';
import 'package:quizlet_clone/ui/widgets/loading_overlay.dart';

class CreateFlashCardPage extends StatefulWidget {
  const CreateFlashCardPage({super.key});

  @override
  State<CreateFlashCardPage> createState() => _CreateFlashCardPageState();
}

class _CreateFlashCardPageState extends State<CreateFlashCardPage> {
  late final CreateFlashCardSetFormBloc _createFlashCardBloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _colorHexController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _createFlashCardBloc = context.read<CreateFlashCardSetFormBloc>()//Error with Provider
      ..addListener(createFlashCardStatusListener);
  }

  @override
  void dispose() {
    _createFlashCardBloc.removeListener(createFlashCardStatusListener);
    _nameController.dispose();
    _colorHexController.dispose();
    super.dispose();
  }

  void createFlashCardStatusListener() {
    switch (_createFlashCardBloc.state) {
      case CreateFlashCardSuccessState _:
        showAppSnackBar(
          context,
          message: AppTexts.createSuccess,
          status: SnackBarStatus.success,
        );
        unawaited(Navigator.of(context).pushReplacementNamed(RouteNames.home));
      case CreateFlashCardErrorState errorState:
        showAppSnackBar(
          context,
          message: errorState.errorMessage,
          status: SnackBarStatus.error,
        );
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => Consumer<CreateFlashCardSetFormBloc>(
        builder: (context, bloc, _) => LoadingOverlay(
          isLoading: bloc.state.isLoading,
          canPop: !bloc.state.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Create Flash Card'),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                CreateFlashCardSetForm(
                  formKey: _formKey,
                  nameController: _nameController,
                  nameValidator: _validateName,
                  colorHex: _colorHexController,
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: onCreatePressed,
                  child: const Text('Create'),
                ),
              ],
            ),
          ),
        ),
      );
  void onCreatePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        _createFlashCardBloc.createFlashCardSet(
          name: _nameController.text,
          colorHex: _colorHexController.text,
        ),
      );
    }
  }
}

String? _validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a name';
  }
  return null;
}
