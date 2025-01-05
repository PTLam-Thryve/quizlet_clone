import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';
import 'package:quizlet_clone/ui/widgets/forms/form_fields/email_form_field.dart';
import 'package:quizlet_clone/ui/widgets/forms/form_fields/password_form_field.dart';

/// A form widget for user authorization (sign in and sign up), including email and password fields.
///
/// This widget displays a form with email and password input fields, and a submit button.
/// It also shows a loading indicator when the form is being submitted.
class AuthorizationForm extends StatelessWidget {
  /// Creates an [AuthorizationForm] widget.
  ///
  /// The [formKey], [emailController], and [passwordController] parameters are required.
  /// The [onPressed] callback is optional and will be called when the submit button is pressed.
  /// The [isLoading] parameter indicates whether the form is in a loading state.
  const AuthorizationForm({
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    this.emailValidator,
    this.passwordValidator,
    this.onPressed,
    this.isLoading = false,
    super.key,
  });

  /// The key for the form.
  final GlobalKey<FormState> formKey;

  /// The controller for the email input field.
  final TextEditingController emailController;

  /// The validator for the email input field.
  final FormFieldValidator<String>? emailValidator;

  /// The controller for the password input field.
  final TextEditingController passwordController;

  /// The validator for the email input field.
  final FormFieldValidator<String>? passwordValidator;

  /// The callback to be called when the submit button is pressed.
  final VoidCallback? onPressed;

  /// Indicates whether the form is in a loading state.
  final bool isLoading;

  @override
  Widget build(BuildContext context) => Form(
        key: formKey,
        child: Column(
          children: [
            EmailFormField(
                controller: emailController, validator: emailValidator),
            const SizedBox(height: 16),
            PasswordFormField(
                controller: passwordController, validator: passwordValidator),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : onPressed,
              child: const Text(AppTexts.signUp),
            ),
          ],
        ),
      );
}
