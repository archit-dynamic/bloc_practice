import 'package:bloc_practice/notes_app_with_bloc/views/email_text_field.dart';
import 'package:bloc_practice/notes_app_with_bloc/views/login_button.dart';
import 'package:bloc_practice/notes_app_with_bloc/views/password_text_field.dart';
import 'package:flutter/material.dart';

class LoginView extends StatelessWidget {
  final OnLoginTapped onLoginTapped;

  const LoginView({
    Key? key,
    required this.onLoginTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          EmailTextField(
            emailController: emailController,
          ),
          PasswordTextField(
            passwordController: passwordController,
          ),
          LoginButton(
            emailController: emailController,
            passwordController: passwordController,
            onLoginTapped: onLoginTapped,
          ),
        ],
      ),
    );
  }
}
