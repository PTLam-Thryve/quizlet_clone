import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/flash_card_set_list_bloc.dart';
import 'package:quizlet_clone/bloc/flash_card_set_list_bloc_state.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/utils/show_app_snack_bar.dart';
import 'package:quizlet_clone/ui/widgets/flash_card_set_list_tile.dart';

class FlashCardSetList extends StatelessWidget {
  const FlashCardSetList({super.key});

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
                itemBuilder: (context, index) =>Dismissible(
                    key: Key(state.flashCardSets[index].id),
                    onDismissed: (direction) async {
                      print('Dismissible triggered');
                      try {
                        await bloc.deleteFlashCardSetById(
                          name: state.flashCardSets[index].name,
                          color: state.flashCardSets[index].colorHex,
                          flashCardId: state.flashCardSets[index].id,
                        );
                        if(context.mounted){
                          print('SnackBar is shown');
                          showAppSnackBar(
                          context,
                          message: AppTexts.deleteSuccess,
                          status: SnackBarStatus.success,
                        );
                        }
                      } catch (e) {
                        if(context.mounted){
                          print('uh oh');
                          showAppSnackBar(
                          context,
                          message: AppTexts.deleteError,
                          status: SnackBarStatus.error,
                        );
                        }
                      }
                    },
                    child: FlashCardSetListTile(
                      name: state.flashCardSets[index].name,
                      colorHex: state.flashCardSets[index].colorHex,
                      flashCardId: state.flashCardSets[index].id,
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
