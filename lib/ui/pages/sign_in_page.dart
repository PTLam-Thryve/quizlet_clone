import 'package:flutter/material.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign In Page"),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: const Center(child: Text('Body Placeholder'),),
    );
  }
}
