import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizlet_clone/models/app_user.dart';

/// A service that handles authentication using Firebase.
class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Retrieves the currently authenticated user.
  ///
  /// Returns an [AppUser] if a user is authenticated, otherwise returns null.
  Future<AppUser> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      throw UnauthorizedException();
    }

    return AppUser.fromFirebaseUser(firebaseUser);
  }

  /// Creates a new user with the provided email and password.
  ///
  /// Throws an [AuthenticationException] if the sign-up process fails.
  ///
  /// Parameters:
  /// - `email`: The email address of the user.
  /// - `password`: The password for the user.
  ///
  /// Returns an [AppUser] representing the newly created user.
  Future<AppUser> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw UserNotFoundException();
      }

      return AppUser.fromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException.fromFirebaseAuthException(e);
    } catch (_) {
      rethrow;
    }
  }

  /// Signs in a user with the provided email and password.
  ///
  /// Throws an [AuthenticationException] if the sign-in process fails.
  ///
  /// Parameters:
  /// - `email`: The email address of the user.
  /// - `password`: The password for the user.
  ///
  /// Returns an [AppUser] representing the signed-in user.
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    // TODO: Implement sign in with email and password
    throw UnimplementedError();
  }

  /// Signs out the currently authenticated user.
  ///
  /// Throws an [AuthenticationException] if the sign-out process fails.
  Future<void> signOut() async {
    // TODO: Implement sign out
    throw UnimplementedError();
  }
}

/// A base class for authentication-related exceptions.
sealed class AuthenticationException implements Exception {
  static AuthenticationException fromFirebaseAuthException(
    FirebaseAuthException firebaseAuthException,
  ) {
    switch (firebaseAuthException.code) {
      case 'user-not-found':
        return UserNotFoundException();
      case 'wrong-password' || 'wrong-email':
        return WrongEmailOrPasswordException();
      case 'email-already-in-use':
        return EmailAlreadyInUseException();
      case 'invalid-email':
        return InvalidEmailException();
      case 'weak-password':
        return WeakPasswordException();
      default:
        return GenericAuthException();
    }
  }
}

class UnauthorizedException extends AuthenticationException {}

class UserNotFoundException extends AuthenticationException {}

class WrongEmailOrPasswordException extends AuthenticationException {}

class EmailAlreadyInUseException extends AuthenticationException {}

class InvalidEmailException extends AuthenticationException {}

class WeakPasswordException extends AuthenticationException {}

class GenericAuthException extends AuthenticationException {}
