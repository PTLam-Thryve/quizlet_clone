import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

/// A class representing an application user.
class AppUser {
  /// Creates an instance of [AppUser].
  ///
  /// The [uid] and [email] parameters are required.
  const AppUser({
    required this.uid,
    required this.email,
  });

  /// Creates an [AppUser] instance from a [firebase_auth.User].
  ///
  /// Assumes that all users have an email.
  factory AppUser.fromFirebaseUser(firebase_auth.User firebaseUser) => AppUser(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
      );

  /// The unique identifier for the user.
  final String uid;

  /// The email address of the user.
  final String email;
}
