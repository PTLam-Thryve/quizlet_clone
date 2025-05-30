import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:quizlet_clone/bloc/create_bloc/create_flash_card_set_form_bloc.dart';
import 'package:quizlet_clone/bloc/flash_card_set_list_bloc.dart';
import 'package:quizlet_clone/bloc/flash_card_set_list_bloc_state.dart';
import 'package:quizlet_clone/data/flash_card_set_service.dart';
import 'package:quizlet_clone/ui/constants/app_icons.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/pages/create_flash_card_set_page.dart';
import 'package:quizlet_clone/ui/router/app_router.dart';
import 'package:quizlet_clone/ui/widgets/flash_card_set_list.dart';
import 'package:quizlet_clone/ui/widgets/flashcard_selection_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AuthenticationBloc _authenticationBloc;
  late final FlashCardSetListBloc _flashCardListBloc;
  final List<String> _selectedFlashCardSetIds = <String>[];

  @override
  void initState() {
    super.initState();
    _authenticationBloc = context.read<AuthenticationBloc>()
      ..addListener(
        _authenticationStatusListener,
      );
    _flashCardListBloc = FlashCardSetListBloc(FlashCardSetService());
    _flashCardListBloc.getFlashCardSets();
  }

  @override
  void dispose() {
    if (mounted) {
      _authenticationBloc.removeListener(_authenticationStatusListener);
    }
    super.dispose();
  }

  void _authenticationStatusListener() {
    if (!_authenticationBloc.state.isAuthenticated) {
      unawaited(Navigator.of(context).pushReplacementNamed(RouteNames.signUp));
    }
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => _flashCardListBloc,
        child: Scaffold(
          appBar: AppBar(
            title: const Text(AppTexts.appName),
            actions: [
              IconButton(
                icon: const Icon(AppIcons.singOut),
                onPressed: () => unawaited(_authenticationBloc.signOut()),
              ),
            ],
          ),
          body: Column(
            children: [
              const Expanded(child: FlashCardSetList()),
              Consumer<FlashCardSetListBloc>(builder: (_, bloc, __) {
                if (bloc.state.isSuccessful) {
                  final flashCardSetList =
                      (bloc.state as FlashCardSetListSuccessState)
                          .flashCardSets;
                  return Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(23),
                        color: Colors.lightBlue.withAlpha(50),
                      ),
                      margin: const EdgeInsets.only(bottom: 100),
                      child: TextButton(
                        onPressed: () {
                          // Reset the selected flash card set IDs
                          _selectedFlashCardSetIds.clear();
                          unawaited(
                            showDialog(
                              context: context,
                              builder: (context) => FlashcardSelectionDialog(
                                flashCardSetList: flashCardSetList,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          AppTexts.startQuiz,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  );
                }

                return const SizedBox.shrink();
              }),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(AppIcons.add),
            onPressed: () {
              unawaited(Navigator.of(context)
                  .push(
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (_) =>
                            CreateFlashCardSetFormBloc(FlashCardSetService()),
                        child: CreateFlashCardSetPage(),
                      ),
                    ),
                  )
                  .then((_) => setState(() {
                        _flashCardListBloc.getFlashCardSets();
                      })));
            },
          ),
        ),
      );
}
