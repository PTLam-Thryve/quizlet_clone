import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:quizlet_clone/bloc/create_bloc/create_flash_card_set_form_bloc.dart';
import 'package:quizlet_clone/bloc/flash_card_set_list_bloc.dart';
import 'package:quizlet_clone/data/flash_card_set_service.dart';
import 'package:quizlet_clone/ui/constants/app_icons.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/pages/create_flash_card_set_page.dart';
import 'package:quizlet_clone/ui/router/app_router.dart';
import 'package:quizlet_clone/ui/widgets/flash_card_set_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AuthenticationBloc _authenticationBloc;
  late final FlashCardSetListBloc _flashCardListBloc;
  List<bool> isChecked = List<bool>.filled(3, false);
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
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(23),
                    color: Colors.lightBlue.withAlpha(50),
                  ),
                  margin: const EdgeInsets.only(bottom: 100),
                  child: TextButton(
                    onPressed: () {
                      //_flashCardListBloc.getFlashCardSets();
                      showDialog(
                        context: context,
                        builder: (context) => StatefulBuilder(builder: (context, setState)=> AlertDialog(
                          title: const Text('Select 1 or more Categories'),
                          content: SizedBox(
                            width: double.maxFinite,
                            height: double.maxFinite,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: isChecked.length,
                              itemBuilder: (context, index) => CheckboxListTile(
                                selected: isChecked[index],
                                value: isChecked[index],
                                title: Text('text $index'),
                                onChanged: (value) {
                                  setState((){
                                    isChecked[index] = value!;
                                    print('value $index has been changed to $value');
                                  });
                                },
                              ),
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
                              onPressed: () {
                                //TODO: navigates to QuizPage
                              },
                              child: const Text('Ok!'),
                            ),
                          ],
                        ),),
                      );
                    },
                    child: const Text(
                      'Start Quiz',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ),
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
