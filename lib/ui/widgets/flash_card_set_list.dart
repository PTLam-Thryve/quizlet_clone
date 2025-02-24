import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/flash_card_set_list_bloc.dart';
import 'package:quizlet_clone/bloc/flash_card_set_list_bloc_state.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/pages/flashcardset_detail_page.dart';
import 'package:quizlet_clone/ui/utils/show_app_snack_bar.dart';
import 'package:quizlet_clone/ui/widgets/flash_card_set_list_tile.dart';

class FlashCardSetList extends StatefulWidget {
  const FlashCardSetList({super.key});

  @override
  State<FlashCardSetList> createState() => _FlashCardSetListState();
}

class _FlashCardSetListState extends State<FlashCardSetList> {
  late final FlashCardSetListBloc _flashCardSetListBloc;

  @override
  void initState() {
    super.initState();
    _flashCardSetListBloc = context.read<FlashCardSetListBloc>()
      ..addListener(_flashCardSetListBlocDeletionResultListener);
  }

  @override
  void dispose() {
    _flashCardSetListBloc
        .removeListener(_flashCardSetListBlocDeletionResultListener);
    super.dispose();
  }

  void _flashCardSetListBlocDeletionResultListener() {
    switch (_flashCardSetListBloc.state) {
      case FlashCardSetListSuccessState flashCardSetListSuccessState:
        if (flashCardSetListSuccessState.isFirstLoad) {
          // Do nothing for the first load as it's not a deletion result.
          return;
        }

        final hasNoDeletionError =
            flashCardSetListSuccessState.deletionError == null;
        if (hasNoDeletionError) {
          showAppSnackBar(
            context,
            message: AppTexts.deleteSuccess,
            status: SnackBarStatus.success,
          );
        } else {
          showAppSnackBar(
            context,
            message: AppTexts.deleteError,
            status: SnackBarStatus.error,
          );
        }
      default:
        // Do nothing for other states as they don't have any deletion result to listen to.
        return;
    }
  }

  @override
  Widget build(BuildContext context) =>
      Consumer<FlashCardSetListBloc>(builder: (_, bloc, __) {
        final state = bloc.state;
        switch (state) {
          case FlashCardSetListInitialState():
            return const Center(child: CircularProgressIndicator());
          case FlashCardSetListLoadingState():
            return const Center(child: CircularProgressIndicator());
          case FlashCardSetListSuccessState():
            return ListView.builder(
              itemCount: state.flashCardSets.length,
              itemBuilder: (context, index) => Dismissible(
                key: Key(state.flashCardSets[index].id),
                onDismissed: (direction) {
                  unawaited(bloc.deleteFlashCardSetById(
                    name: state.flashCardSets[index].name,
                    color: state.flashCardSets[index].colorHex,
                    flashCardId: state.flashCardSets[index].id,
                  ));
                },
                child: InkWell(
                  onTap: () {
                    unawaited(
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => FlashcardSetDetailPage(
                                  flashCardId: state.flashCardSets[index].id,
                                )),
                      ),
                    );
                  },
                  child: FlashCardSetListTile(
                    name: state.flashCardSets[index].name,
                    colorHex: state.flashCardSets[index].colorHex,
                    flashCardId: state.flashCardSets[index].id,
                  ),
                ),
              ),
            );
          case FlashCardSetListErrorState():
            return Center(
              child: Text(state.errorMessage),
            );
        }
      });
}
