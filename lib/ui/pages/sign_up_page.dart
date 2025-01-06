import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizlet_clone/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:quizlet_clone/bloc/authentication_bloc/authentication_bloc_state.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/pages/sign_in_page.dart';
import 'package:quizlet_clone/ui/router/app_router.dart';
import 'package:quizlet_clone/ui/utils/show_app_snack_bar.dart';
import 'package:quizlet_clone/ui/widgets/forms/authorization_form.dart';
import 'package:quizlet_clone/ui/widgets/loading_overlay.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({
    super.key,
  });

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
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
          message: AppTexts.signUpSuccess,
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
                title: const Text(AppTexts.signUp),
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
                    onPressed: _onSignUpPressed,
                    isLoading: bloc.state.isLoading,
                  ),
                  TextButton(onPressed: _onSignInPressed, child: const Text('Sign In'))
                ],
              ),
            ),
          ));

  void _onSignUpPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      unawaited(
        _authenticationBloc.signUpWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        ),
      );
    }
  }

  Future<void> _onSignInPressed() async{
    await Navigator.push(context, MaterialPageRoute(builder: (context)=> const SignInPage()));
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

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return AppTexts.pleaseEnterPassword;
    }

    if (value.length < 6) {
      return AppTexts.passwordMustBeAtLeast6Characters;
    }

    return null;
  }
}
