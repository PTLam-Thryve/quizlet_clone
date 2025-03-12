import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/flashcard_list_bloc/flashcard_list_bloc.dart';
import 'package:quizlet_clone/bloc/flashcard_list_bloc/flashcard_list_bloc_state.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/widgets/flashcard_list_tile.dart';

class FlashcardList extends StatefulWidget {
  const FlashcardList({required this.flashCardSetId, super.key});
  final String flashCardSetId;

  @override
  State<FlashcardList> createState() => _FlashcardListState();
}

class _FlashcardListState extends State<FlashcardList> {
  @override
  Widget build(BuildContext context) => Consumer<FlashCardListBloc>(
        builder: (_, bloc, __) {
          final state = bloc.state;
          switch (state) {
            case FlashCardListInitialState():
              return const Center(child: CircularProgressIndicator());
            case FlashCardListLoadingState():
              return const Center(child: CircularProgressIndicator());
            case FlashCardListSuccessState():
              return state.flashcards.isEmpty
                  ? const Center(child: Text(AppTexts.flashCardSetEmpty))
                  : ListView.builder(
                      itemCount: state.flashcards.length,
                      itemBuilder: (context, index) => Card.outlined(
                        color: Colors.green[50],
                        child: FlashcardListTile(
                          question: state.flashcards[index].question,
                          answer: state.flashcards[index].answer,
                          id: widget.flashCardSetId,
                          flashCardId: state.flashcards[index].id,
                        ),
                      ),
                    );
            case FlashCardListErrorState():
              return Center(
                child: Text(state.errorMessage),
              );
          }
        },
      );
}
