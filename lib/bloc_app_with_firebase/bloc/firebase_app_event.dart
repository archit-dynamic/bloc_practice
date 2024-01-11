import 'package:flutter/material.dart';

@immutable
abstract class FirebaseAppEvent {
  const FirebaseAppEvent();
}

@immutable
class AppEventUploadImage implements FirebaseAppEvent {
  final String filePathToUpload;

  const AppEventUploadImage({
    required this.filePathToUpload,
  });
}

@immutable
class AppEventDeleteAccount implements FirebaseAppEvent {
  const AppEventDeleteAccount();
}

@immutable
class AppEventLogOut implements FirebaseAppEvent {
  const AppEventLogOut();
}

@immutable
class AppEventInitialize implements FirebaseAppEvent {
  const AppEventInitialize();
}

@immutable
class AppEventLogIn implements FirebaseAppEvent {
  final String email;
  final String password;

  const AppEventLogIn({
    required this.email,
    required this.password,
  });
}

@immutable
class AppEventGoToRegistration implements FirebaseAppEvent {
  const AppEventGoToRegistration();
}

@immutable
class AppEventGoToLogin implements FirebaseAppEvent {
  const AppEventGoToLogin();
}

@immutable
class AppEventRegister implements FirebaseAppEvent {
  final String email;
  final String password;

  const AppEventRegister({
    required this.email,
    required this.password,
  });
}
