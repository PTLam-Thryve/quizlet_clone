import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/edit_bloc/edit_flash_card_bloc.dart';
import 'package:quizlet_clone/bloc/edit_bloc/edit_flash_card_bloc_state.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/router/app_router.dart';
import 'package:quizlet_clone/ui/utils/show_app_snack_bar.dart';
import 'package:quizlet_clone/ui/widgets/forms/flash_card_set_form.dart';
import 'package:quizlet_clone/ui/widgets/loading_overlay.dart';

class EditFlashCardPage extends StatefulWidget {
  const EditFlashCardPage({required this.flashCardId, super.key});
  final String flashCardId;

  @override
  State<EditFlashCardPage> createState() => _EditFlashCardPageState();
}

class _EditFlashCardPageState extends State<EditFlashCardPage> {
  late final EditFlashCardBloc _editFlashCardBloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _colorHexController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editFlashCardBloc = context.read<EditFlashCardBloc>()
      ..addListener(editFlashCardStatusListener);
  }

  @override
  void dispose() {
    _editFlashCardBloc.removeListener(editFlashCardStatusListener);
    _nameController.dispose();
    _colorHexController.dispose();
    super.dispose();
  }

  void editFlashCardStatusListener() {
    switch (_editFlashCardBloc.state) {
      case EditFlashCardSuccessState _:
        showAppSnackBar(
          context,
          message: AppTexts.editSuccess,
          status: SnackBarStatus.success,
        );
        unawaited(Navigator.of(context).pushReplacementNamed(RouteNames.home));
      case EditFlashCardErrorState errorState:
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
  Widget build(BuildContext context) => Consumer<EditFlashCardBloc>(
        builder: (context, bloc, _) => LoadingOverlay(
          isLoading: bloc.state.isLoading,
          canPop: !bloc.state.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Edit your Flashcard'),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                FlashCardSetForm(
                  formKey: _formKey,
                  colorHex: _colorHexController,
                  nameController: _nameController,
                  buttonLabel: AppTexts.edit,
                  onPressed: onEditPressed,
                ),
              ],
            ),
          ),
        ),
      );
  void onEditPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        _editFlashCardBloc.editFlashCardSet(
          newName: _nameController.text,
          newColor: _colorHexController.text,
          flashCardId: widget.flashCardId,
        ),
      );
    }
  }
}
