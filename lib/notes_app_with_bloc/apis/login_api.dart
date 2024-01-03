import 'package:bloc_practice/notes_app_with_bloc/models.dart';
import 'package:flutter/material.dart';

@immutable
abstract class LoginApiProtocol {
  const LoginApiProtocol();

  Future<LoginHandle?> login({
    required String email,
    required String password,
  });
}

@immutable
class LoginApi implements LoginApiProtocol {
  //singleton pattern
/*  const LoginApi._sharedInstance();

  static const LoginApi _shared = LoginApi._sharedInstance();

  factory LoginApi.instance() => _shared;*/

  @override
  Future<LoginHandle?> login({
    required String email,
    required String password,
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => email == "archit@abc.com" && password == "12345",
      ).then(
        (isLoggedIn) => isLoggedIn ? const LoginHandle.archit() : null,
      );
}
