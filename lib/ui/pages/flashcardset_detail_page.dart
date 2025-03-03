import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/flashcard_list_bloc/flashcard_list_bloc.dart';
import 'package:quizlet_clone/data/flashcard_service.dart';
import 'package:quizlet_clone/ui/widgets/flashcard_list.dart';

class FlashCardSetDetailPage extends StatefulWidget {
  const FlashCardSetDetailPage({required this.flashCardSetid, super.key});

  final String flashCardSetid;

  @override
  State<FlashCardSetDetailPage> createState() => _FlashCardSetDetailPageState();
}

class _FlashCardSetDetailPageState extends State<FlashCardSetDetailPage> {
  late final FlashCardListBloc _flashCardListBloc;
  @override
  void initState() {
    super.initState();
    _flashCardListBloc = FlashCardListBloc(FlashCardService());
    _flashCardListBloc.getFlashcards(widget.flashCardSetid);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => _flashCardListBloc,
    child: Scaffold(
          appBar: AppBar(
            title: const Text('Flashcard Detail Page'),
          ),
          body: FlashcardList(),
        ),
  );
}
