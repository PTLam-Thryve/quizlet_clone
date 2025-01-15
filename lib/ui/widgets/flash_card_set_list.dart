import 'package:flutter/material.dart';
import 'package:quizlet_clone/bloc/flash_card_set_list_bloc.dart';
import 'package:quizlet_clone/models/flash_card_set.dart';
import 'package:quizlet_clone/ui/widgets/flash_card_set_list_tile.dart';

class FlashCardSetList extends StatefulWidget {
  const FlashCardSetList({super.key});

  @override
  State<FlashCardSetList> createState() => _FlashCardSetListState();
}

class _FlashCardSetListState extends State<FlashCardSetList> {
  Future<List<FlashCardSet>>? _flashCardSets;

  @override
  void initState(){
    super.initState();
    _flashCardSets = FlashCardSetListBloc().getFlashCard();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder(
        future: _flashCardSets,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('An error has ocurred: ${snapshot.error}'),
            );
          } else {
            final flashCardSets = snapshot.data;
            if(flashCardSets == null || flashCardSets.isEmpty){
              return const Center(
                child: Text('Flash Card Set is empty'),
              );
            }
            return ListView.builder(itemCount: flashCardSets.length,itemBuilder: (context, index) => FlashCardSetListTile(
                name: flashCardSets[index].name,
                colorHex: flashCardSets[index].colorHex,
              ),
            );
          }
        });
}
