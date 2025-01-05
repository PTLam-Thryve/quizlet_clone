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
  late final AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();

    // The post-frame callback is executed after the first frame is rendered.
    // This ensures that the [context] is available for use.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        if (mounted) {
          _authenticationBloc = context.read<AuthenticationBloc>()
            ..addListener(_authenticationStatusListener);
          // Add a delay to ensure the splash screen is visible for at least 1 second, enhancing user experience.
          await Future<void>.delayed(const Duration(seconds: 1));
          unawaited(_authenticationBloc.getCurrentUser());
        }
      },
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
    if (_authenticationBloc.state.isAuthenticated) {
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
