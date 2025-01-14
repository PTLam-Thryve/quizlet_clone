import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:quizlet_clone/ui/constants/app_icons.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/router/app_router.dart';
import 'package:quizlet_clone/ui/widgets/flash_card_set_list.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = context.read<AuthenticationBloc>()
      ..addListener(
        _authenticationStatusListener,
      );
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(AppTexts.appName),
          actions: [
            IconButton(
              icon: const Icon(AppIcons.singOut),
              onPressed: () => unawaited(_authenticationBloc.signOut()),
            )
          ],
        ),
        body: const FlashCardSetList(),
      );
}
