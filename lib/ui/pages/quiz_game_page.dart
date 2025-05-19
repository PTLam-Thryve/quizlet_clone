import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/quiz_game_bloc/quiz_game_bloc.dart';
import 'package:quizlet_clone/bloc/quiz_game_bloc/quiz_game_bloc_state.dart';
import 'package:quizlet_clone/data/quiz_game_service.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/widgets/app_progress_indicator.dart';

class QuizGamePage extends StatefulWidget {
  const QuizGamePage(
      {required this.selectedFlashCardSetIds, required this.setId, super.key});
  final List<String> selectedFlashCardSetIds;
  final String setId;

  @override
  State<QuizGamePage> createState() => _QuizGamePageState();
}

class _QuizGamePageState extends State<QuizGamePage> {
  late final QuizGameBloc _quizGameBloc;

  @override
  void initState() {
    super.initState();
    _quizGameBloc = QuizGameBloc(QuizGameService());
    _quizGameBloc.initQuiz(widget.selectedFlashCardSetIds);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => _quizGameBloc,
        child: Scaffold(
            appBar: AppBar(
              title: const Text(AppTexts.quizGameWelcome),
            ),
            body: Consumer<QuizGameBloc>(
              builder: (context, bloc, child) {
                if (bloc.state.isLoading) {
                  return const Center(
                    child: AppProgressIndicator(),
                  );
                } else if (bloc.state.isSuccessful) {
                  final quizFlashcards =
                      (bloc.state as QuizGameSuccessState).quizFlashcards;
                  return ListView.builder(
                      itemCount: quizFlashcards.length,
                      itemBuilder: (context, index) {
                        final flashcard = quizFlashcards[index];
                        return ListTile(
                          title: Text(flashcard.question),
                          subtitle: Text(flashcard.options.toString()),
                          trailing: Text(flashcard.answer),
                        );
                      });
                } else if (bloc.state is QuizGameErrorState) {
                  final errorMessage =
                      (bloc.state as QuizGameErrorState).errorMessage;
                  return Center(
                    child: Text(errorMessage),
                  );
                } else{
                  return const SizedBox.shrink();
                }
              },
            )),
      );
}
