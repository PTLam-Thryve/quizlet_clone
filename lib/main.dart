import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:quizlet_clone/app.dart';
import 'package:quizlet_clone/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}
