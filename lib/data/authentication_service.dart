import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
import 'package:quizlet_clone/models/app_user.dart';

/// A service that handles authentication using Firebase.
class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Retrieves the currently authenticated user.
  ///
  /// Returns an [AppUser] if a user is authenticated, otherwise returns null.
  Future<AppUser?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) {
      return null;
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
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw UserNotFoundException();
      }

      return AppUser.fromFirebaseUser(firebaseUser);
    } on FirebaseAuthException catch (e) {
      //TODO: Implement proper error message handling for sign in
      debugPrint('FirebaseAuthException: ${e.code}');
      throw AuthenticationException.fromFirebaseAuthException(e);
    } catch (e) {
      rethrow;
    }
  }

  /// Signs out the currently authenticated user.
  ///
  /// Throws an [AuthenticationException] if the sign-out process fails.
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthenticationException.fromFirebaseAuthException(e);
    } catch (_) {
      rethrow;
    }
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
      case 'invalid-credential' || 'wrong-password':
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

class UserNotFoundException extends AuthenticationException {}

class WrongEmailOrPasswordException extends AuthenticationException {}

class EmailAlreadyInUseException extends AuthenticationException {}

class InvalidEmailException extends AuthenticationException {}

class WeakPasswordException extends AuthenticationException {}

class GenericAuthException extends AuthenticationException {}
