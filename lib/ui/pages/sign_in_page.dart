import 'package:flutter/material.dart';
import 'package:quizlet_clone/bloc/authentication_bloc/authentication_bloc.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/widgets/forms/authorization_form.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  late final AuthenticationBloc _authenticationBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
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
              onPressed: () {
                final password = _passwordController.text;
                final email = _emailController.text;
                final passwordValidationResult = _validatePassword(password);
                final emailValidationResult = _validateEmail(email);
                if(emailValidationResult != null){
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(emailValidationResult),
                    ),
                  );
                }
                else if (passwordValidationResult != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(passwordValidationResult),
                    ),
                  );
                } else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(AppTexts.signInSuccess),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      );

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
