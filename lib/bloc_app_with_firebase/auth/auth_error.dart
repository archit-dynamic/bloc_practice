import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter/material.dart';

const Map<String, AuthError> authErrorMapping = {
  "user-not-found": AuthErrorUserNotFound(),
  "weak-password": AuthErrorWeakPassword(),
  "invalid-email": AuthErrorInvalidEmail(),
  "operation-not-allowed": AuthErrorOperationNotAllowed(),
  "email-already-in-use": AuthErrorEmailAlreadyInUse(),
  "requires-recent-login": AuthErrorRequiresRecentLogin(),
  "no-current-user": AuthErrorNoCurrentUser(),
};

@immutable
abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  const AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory AuthError.from(FirebaseAuthException exception) =>
      authErrorMapping[exception.code.toLowerCase().trim()] ??
      const AuthErrorUnKnown();
}

@immutable
class AuthErrorUnKnown extends AuthError {
  const AuthErrorUnKnown()
      : super(
          dialogTitle: "Authentication Error",
          dialogText: "Unknown Authentication Error",
        );
}

@immutable
class AuthErrorNoCurrentUser extends AuthError {
  const AuthErrorNoCurrentUser()
      : super(
          dialogTitle: "No current user!",
          dialogText: "No current user with this information found!",
        );
}

@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  const AuthErrorRequiresRecentLogin()
      : super(
          dialogTitle: "Requires recent login",
          dialogText:
              "You need to log out and log in again in order to perform this operation",
        );
}

@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  const AuthErrorOperationNotAllowed()
      : super(
          dialogTitle: "Operation not allowed",
          dialogText: "You cannot register using this method at this moment!",
        );
}

@immutable
class AuthErrorUserNotFound extends AuthError {
  const AuthErrorUserNotFound()
      : super(
          dialogTitle: "User not found",
          dialogText: "The given user was not found on the server!",
        );
}

@immutable
class AuthErrorWeakPassword extends AuthError {
  const AuthErrorWeakPassword()
      : super(
          dialogTitle: "Weak Password",
          dialogText:
              "Please choose a stronger password consisting of more characters!",
        );
}

@immutable
class AuthErrorInvalidEmail extends AuthError {
  const AuthErrorInvalidEmail()
      : super(
          dialogTitle: "Invalid Email",
          dialogText: "Please double check your email and try again!",
        );
}

@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  const AuthErrorEmailAlreadyInUse()
      : super(
          dialogTitle: "Email already in use",
          dialogText: "Please choose another email to register with!",
        );
}
