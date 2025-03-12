import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/edit_bloc/edit_flashcard_form_bloc_state.dart';
import 'package:quizlet_clone/bloc/edit_bloc/edit_flashcard_form_bloc.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/pages/flashcardset_detail_page.dart';
import 'package:quizlet_clone/ui/utils/show_app_snack_bar.dart';
import 'package:quizlet_clone/ui/widgets/forms/flashcard_form.dart';
import 'package:quizlet_clone/ui/widgets/loading_overlay.dart';

class EditFlashcardPage extends StatefulWidget {
  const EditFlashcardPage(
      {required this.flashCardId, required this.flashCardSetId, super.key});
  final String flashCardId;
  final String flashCardSetId;

  @override
  State<EditFlashcardPage> createState() => _EditFlashcardPageState();
}

class _EditFlashcardPageState extends State<EditFlashcardPage> {
  late final EditFlashcardFormBloc _editFormBloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _editFormBloc = context.read<EditFlashcardFormBloc>()
      ..addListener(editFormStatusListener);
  }

  @override
  void dispose() {
    _editFormBloc.removeListener(editFormStatusListener);
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void editFormStatusListener() {
    switch (_editFormBloc.state) {
      case EditFlashcardFormSuccessState _:
        showAppSnackBar(
          context,
          message: AppTexts.editFlashcardSuccess,
          status: SnackBarStatus.success,
        );
        Navigator.of(context).pop();
        unawaited(
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => FlashCardSetDetailPage(
                flashCardSetid: widget.flashCardSetId,
              ),
            ),
          ),
        );

      case EditFlashcardFormErrorState errorState:
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
  Widget build(BuildContext context) => Consumer<EditFlashcardFormBloc>(
        builder: (context, bloc, _) => LoadingOverlay(
            isLoading: bloc.state.isLoading,
            canPop: !bloc.state.isLoading,
            child: Scaffold(
              appBar: AppBar(title: const Text('Edit your Flashcard'),),
              body: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  FlashcardForm(
                      formKey: _formKey,
                      questionController: _questionController,
                      questionValidator: _validateQuestionAndAnswer,
                      answerController: _answerController,
                      answerValidator: _validateQuestionAndAnswer,
                      onPressed: onEditPressed,
                      buttonLabel: AppTexts.edit)
                ],
              ),
            )),
      );
  void onEditPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        _editFormBloc.editFlashcard(
          newQuestion: _questionController.text,
          newAnswer: _answerController.text,
          flashCardSetId: widget.flashCardSetId,
          flashCardId: widget.flashCardId,
        ),
      );
    }
  }
}

String? _validateQuestionAndAnswer(String? value) {
  if (value == null || value.isEmpty) {
    return 'This field cannot be empty';
  }
  if (value.length > 50) {
    return 'This field cannot be more than 50 characters';
  }
  return null;
}
