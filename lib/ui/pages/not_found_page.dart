import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(AppTexts.notFound),
        ),
        body: Center(
          child: Text(
            AppTexts.notFound,
            style: Theme.of(context).textTheme.headlineLarge,
          ),
        ),
      );
}
