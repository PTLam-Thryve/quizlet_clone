import 'package:flutter/material.dart';
import 'package:quizlet_clone/ui/pages/home_page.dart';
import 'package:quizlet_clone/ui/pages/not_found_page.dart';
import 'package:quizlet_clone/ui/pages/sign_up_page.dart';
import 'package:quizlet_clone/ui/pages/splash_page.dart';

part 'route_names.dart';

abstract base class AppRouter {
  const AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case RouteNames.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case RouteNames.signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      default:
        return MaterialPageRoute(builder: (_) => const NotFoundPage());
    }
  }
}
