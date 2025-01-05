import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:quizlet_clone/ui/router/app_router.dart';
import 'package:quizlet_clone/ui/widgets/app_progress_indicator.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({
    super.key,
  });

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (mounted) {
          final authenticationBloc = context.read<AuthenticationChangeNotifier>()
            ..addListener(_authenticationStatusListener);
          unawaited(authenticationBloc.getCurrentUser());
        }
      },
    );
  }

  @override
  void dispose() {
    if (mounted) {
      context.read<AuthenticationChangeNotifier>().removeListener(_authenticationStatusListener);
    }
    super.dispose();
  }

  void _authenticationStatusListener() {
    final authenticationBloc = context.read<AuthenticationChangeNotifier>();
    if (authenticationBloc.state.isAuthenticated) {
      unawaited(Navigator.of(context).pushReplacementNamed(RouteNames.home));
    } else {
      unawaited(Navigator.of(context).pushReplacementNamed(RouteNames.signUp));
    }
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
        body: AppProgressIndicator(),
      );
}
