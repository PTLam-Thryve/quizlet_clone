import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:quizlet_clone/bloc/authentication_bloc/authentication_bloc_state.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/pages/sign_up_page.dart';
import 'package:quizlet_clone/ui/router/app_router.dart';
import 'package:quizlet_clone/ui/utils/show_app_snack_bar.dart';
import 'package:quizlet_clone/ui/widgets/forms/authorization_form.dart';
import 'package:quizlet_clone/ui/widgets/loading_overlay.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  late final AuthenticationBloc _authenticationBloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authenticationBloc = context.read<AuthenticationBloc>()
      ..addListener(_authenticationStatusListener);
  }

  @override
  void dispose() {
    _authenticationBloc.removeListener(_authenticationStatusListener);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _authenticationStatusListener() {
    switch (_authenticationBloc.state) {
      case AuthenticationAuthenticated _:
        showAppSnackBar(
          context,
          message: AppTexts.signInSuccess,
          status: SnackBarStatus.success,
        );
        unawaited(Navigator.of(context).pushReplacementNamed(RouteNames.home));
      case AuthenticationError errorState:
        showAppSnackBar(
          context,
          message: errorState.errorMessage,
          status: SnackBarStatus.error,
        );
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) => Consumer<AuthenticationBloc>(
        builder: (context, bloc, _) => LoadingOverlay(
          isLoading: bloc.state.isLoading,
          canPop: !bloc.state.isLoading,
          child: Scaffold(
            appBar: AppBar(
              title: const Text(AppTexts.signIn),
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                AuthorizationForm(
                  formKey: _formKey,
                  emailController: _emailController,
                  emailValidator: _validateEmail,
                  passwordController: _passwordController,
                  passwordValidator: _validatePassword,
                  onPressed: _onSignInPressed,
                  buttonLabel: AppTexts.signIn,
                ),
                TextButton(
                  onPressed: _onSignUpPressed,
                  child: const Text(AppTexts.signUp),
                ),
              ],
            ),
          ),
        ),
      );

  void _onSignInPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        _authenticationBloc.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  Future<void> _onSignUpPressed() async {
    unawaited(Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const SignUpPage())));
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppTexts.pleaseEnterPassword;
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return AppTexts.pleaseEnterEmail;
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return AppTexts.pleaseEnterValidEmail;
    }

    return null;
  }
}
