import 'package:quizlet_clone/data/authentication_service.dart';
import 'package:quizlet_clone/models/app_user.dart';
import 'package:quizlet_clone/ui/constants/app_texts.dart';

/// Base class for all authentication states.
sealed class AuthenticationState {
  bool get isAuthenticated => this is AuthenticationAuthenticated;

  bool get isLoading => this is AuthenticationLoading;
}

/// Represents the initial state of authentication.
class AuthenticationInitial extends AuthenticationState {}

/// Represents the loading state of authentication.
class AuthenticationLoading extends AuthenticationState {}

/// Represents the authenticated state with a user.
class AuthenticationAuthenticated extends AuthenticationState {
  /// Creates an instance of [AuthenticationAuthenticated].
  ///
  /// [user] is the authenticated user.
  AuthenticationAuthenticated(this.user);

  /// The authenticated user.
  final AppUser user;
}

/// Represents an error state in authentication.
class AuthenticationError extends AuthenticationState {
  /// Creates an instance of [AuthenticationError].
  ///
  /// [message] is the error message.
  AuthenticationError(this.error);

  /// The error message.
  final AuthenticationException error;

  String get errorMessage {
    switch (error) {
      case UnauthorizedException():
        return AppTexts.unauthorizedAccess;
      case UserNotFoundException():
        return AppTexts.userNotFound;
      case WrongEmailOrPasswordException():
        return AppTexts.wrongEmailOrPassword;
      case EmailAlreadyInUseException():
        return AppTexts.emailAlreadyInUse;
      case InvalidEmailException():
        return AppTexts.invalidEmail;
      case WeakPasswordException():
        return AppTexts.weakPassword;
      case GenericAuthException():
        return AppTexts.unknownError;
    }
  }
}
