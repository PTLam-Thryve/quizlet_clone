import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/flash_card_set_list_bloc.dart';
import 'package:quizlet_clone/bloc/flash_card_set_list_bloc_state.dart';
import 'package:quizlet_clone/ui/widgets/flash_card_set_list_tile.dart';

class FlashCardSetList extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Consumer<FlashCardSetListBloc>(builder: (_, bloc, __) {
        final state = bloc.state;
        switch(state){
          
          case FlashCardSetListInitialState():
            return const Center(child: CircularProgressIndicator());
          case FlashCardSetListLoadingState():
            return const Center(child: CircularProgressIndicator());
          case FlashCardSetListSuccessState():
            return ListView.builder(itemCount: state.flashCardSets.length,itemBuilder: (context, index) => FlashCardSetListTile(
                name: state.flashCardSets[index].name,
                colorHex: state.flashCardSets[index].colorHex,
              ),
            );
          case FlashCardSetListErrorState():
            return Center(
              child: Text(state.errorMessage),
            );
        }
      });
}
