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
import 'package:quizlet_clone/ui/widgets/flashcard_set_selection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AuthenticationBloc _authenticationBloc;
  late final FlashCardSetListBloc _flashCardListBloc;
  final Set<String> _selectedFlashCardSetIds = <String>{};

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
                          unawaited(showDialog(
                            context: context,
                            builder: (context) => StatefulBuilder(
                              builder: (context, setState) => AlertDialog(
                                title:
                                    const Text('Select 1 or more Categories'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  height: double.maxFinite,
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: flashCardSetList.length,
                                    itemBuilder: (_, index) {
                                      final flashCardSet =
                                          flashCardSetList[index];
                                      return CheckboxListTile(
                                        value: _selectedFlashCardSetIds
                                            .contains(flashCardSet.id),
                                        title: Text(flashCardSet.name),
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == true) {
                                              _selectedFlashCardSetIds
                                                  .add(flashCardSet.id);
                                            } else {
                                              _selectedFlashCardSetIds
                                                  .remove(flashCardSet.id);
                                            }
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'Cancel',
                                      style: TextStyle(color: Colors.redAccent),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed:
                                        _selectedFlashCardSetIds.isNotEmpty
                                            ? () {
                                                //TODO: navigates to QuizPage
                                              }
                                            : null,
                                    child: Text(
                                      'Start',
                                      style: _selectedFlashCardSetIds.isNotEmpty
                                          ? const TextStyle(color: Colors.blue)
                                          : const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ));
                        },
                        child: const Text(
                          'Start Quiz',
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
