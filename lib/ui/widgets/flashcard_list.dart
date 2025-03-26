import 'dart:async';

import 'package:color_hex/color_hex.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/flashcard_list_bloc/flashcard_list_bloc.dart';
import 'package:quizlet_clone/bloc/flashcard_list_bloc/flashcard_list_bloc_state.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/utils/show_app_snack_bar.dart';
import 'package:quizlet_clone/ui/widgets/flashcard_list_tile.dart';

class FlashcardList extends StatefulWidget {
  const FlashcardList({required this.flashCardSetId, required this.flashCardColorHex, super.key});
  final String flashCardSetId;
  final String flashCardColorHex;

  @override
  State<FlashcardList> createState() => _FlashcardListState();
}

class _FlashcardListState extends State<FlashcardList> {
  late final FlashCardListBloc _flashCardListBloc;

  @override
  void initState() {
    super.initState();
    _flashCardListBloc = context.read<FlashCardListBloc>()
      ..addListener(_flashcardBlocDeletionStatusListener);
  }

  @override
  void dispose() {
    _flashCardListBloc.removeListener(_flashcardBlocDeletionStatusListener);
    super.dispose();
  }

  void _flashcardBlocDeletionStatusListener() {
    switch (_flashCardListBloc.state) {
      case FlashCardListSuccessState flashCardListSuccessState:
        if (flashCardListSuccessState.isFirstLoad) {
          return;
        }
        final hasNoDeletionError =
            flashCardListSuccessState.deletionError == null;
        if (hasNoDeletionError) {
          showAppSnackBar(
            context,
            message: AppTexts.deleteByIdSuccess,
            status: SnackBarStatus.success,
          );
        } else {
          showAppSnackBar(
            context,
            message: AppTexts.deleteByIdError,
            status: SnackBarStatus.error,
          );
        }
      default:
        return;
    }
  }

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
                      itemBuilder: (context, index) => Dismissible(
                        key: Key(state.flashcards[index].id),
                        onDismissed: (direction) {
                          unawaited(
                            _flashCardListBloc.deleteFlashcardById(
                              state.flashcards[index].question,
                              state.flashcards[index].answer,
                              widget.flashCardSetId,
                              state.flashcards[index].id,
                            ),
                          );
                        },
                        child: Card.outlined(
                          color: widget.flashCardColorHex.convertToColor.withAlpha(50),
                          child: FlashcardListTile(
                            question: state.flashcards[index].question,
                            answer: state.flashcards[index].answer,
                            id: widget.flashCardSetId,
                            flashCardId: state.flashcards[index].id,
                            flashCardColorHex: widget.flashCardColorHex,
                          ),
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
