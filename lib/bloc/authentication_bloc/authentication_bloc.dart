import 'package:flutter/foundation.dart';
import 'package:quizlet_clone/bloc/authentication_bloc/authentication_bloc_state.dart';
import 'package:quizlet_clone/models/app_user.dart';

/// A ChangeNotifier class that manages the authentication state of the application.
class AuthenticationChangeNotifier extends ChangeNotifier {
  /// The current state of authentication.
  AuthenticationState _state = AuthenticationInitial();

  /// Getter for the current authentication state.
  AuthenticationState get state => _state;

  /// Fetches the current user and updates the state accordingly.
  Future<void> getCurrentUser() async {
    _state = AuthenticationLoading();
    notifyListeners();

    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      final user = null;
      if (user != null) {
        _state = AuthenticationAuthenticated(
          const AppUser(
            uid: 'user.uid',
            email: 'user.email',
          ),
        );
      } else {
        _state = AuthenticationInitial();
      }
    } catch (e) {
      _state = AuthenticationError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  /// Signs up a user with the provided email and password, and updates the state.
  ///
  /// Parameters:
  /// - `email`: The email address of the user.
  /// - `password`: The password for the user.
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _state = AuthenticationLoading();
    notifyListeners();

    try {
      await Future<void>.delayed(const Duration(seconds: 2));
      final user = AppUser(
        uid: password,
        email: email,
      );
      _state = AuthenticationAuthenticated(user);
    } catch (e) {
      _state = AuthenticationError(e.toString());
    } finally {
      notifyListeners();
    }
  }

  /// Signs in a user with the provided email and password.
  ///
  /// Parameters:
  /// - `email`: The email address of the user.
  /// - `password`: The password for the user.
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // TODO: Implement sign in with email and password
    throw UnimplementedError();
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    // TODO: Implement sign out
    throw UnimplementedError();
  }
}
