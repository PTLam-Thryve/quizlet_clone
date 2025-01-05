import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text(AppTexts.appName),
        ),
        body: const Center(
          child: Text(AppTexts.appName),
        ),
      );
}
