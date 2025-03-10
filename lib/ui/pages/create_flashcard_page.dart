import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/create_bloc/create_flashcard_form_bloc.dart';
import 'package:quizlet_clone/bloc/create_bloc/create_flashcard_form_bloc_state.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/pages/flashcardset_detail_page.dart';
import 'package:quizlet_clone/ui/utils/show_app_snack_bar.dart';
import 'package:quizlet_clone/ui/widgets/forms/flashcard_form.dart';
import 'package:quizlet_clone/ui/widgets/loading_overlay.dart';

class CreateFlashcardPage extends StatefulWidget {
  const CreateFlashcardPage({required this.flashCardSetId, super.key});
  final String flashCardSetId;

  @override
  State<CreateFlashcardPage> createState() => _CreateFlashcardPageState();
}

class _CreateFlashcardPageState extends State<CreateFlashcardPage> {
  late final CreateFlashcardFormBloc _createFlashcardFormBloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _createFlashcardFormBloc = context.read<CreateFlashcardFormBloc>()
      ..addListener(createStatusListener);
  }

  @override
  void dispose() {
    _createFlashcardFormBloc.removeListener(createStatusListener);
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void createStatusListener() {
    switch (_createFlashcardFormBloc.state) {
      case CreateFlashcardSuccessState _:
        showAppSnackBar(context,
            message: AppTexts.createFlashcardSuccess,
            status: SnackBarStatus.success);
            Navigator.of(context).pop();
        unawaited(
          //Navigator.of(context).pop() only returns to the old version of the page instead of
          //the new version with newly created flashcard
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => FlashCardSetDetailPage(
                flashCardSetid: widget.flashCardSetId,
              ),
            ),
          ),
        );
      case CreateFlashcardErrorState errorState:
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
  Widget build(BuildContext context) => Consumer<CreateFlashcardFormBloc>(
        builder: (context, bloc, _) => LoadingOverlay(
          isLoading: bloc.state.isLoading,
          canPop: !bloc.state.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Create your Flashcard'),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                FlashcardForm(
                  formKey: _formKey,
                  questionController: _questionController,
                  questionValidator: _validateQuestionAndAnswer,
                  answerController: _answerController,
                  answerValidator: _validateQuestionAndAnswer,
                  onPressed: onCreatePressed,
                  buttonLabel: AppTexts.create,
                )
              ],
            ),
          ),
        ),
      );
  void onCreatePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        _createFlashcardFormBloc.createFlashcard(
          question: _questionController.text,
          answer: _answerController.text,
          flashCardSetId: widget.flashCardSetId,
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
