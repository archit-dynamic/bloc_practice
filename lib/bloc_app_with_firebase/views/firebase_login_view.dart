import 'package:bloc_practice/bloc_app_with_firebase/bloc/firebase_app_bloc.dart';
import 'package:bloc_practice/bloc_app_with_firebase/bloc/firebase_app_event.dart';
import 'package:bloc_practice/extension/if_debugging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirebaseLoginView extends StatelessWidget {
  const FirebaseLoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final emailController =
        TextEditingController(text: "archit@gmail.com".ifDebugging);
    final passwordController =
        TextEditingController(text: "123456789".ifDebugging);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Log in",
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                hintText: "Enter your email here...",
              ),
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              keyboardAppearance: Brightness.dark,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                hintText: "Enter your password here...",
              ),
              obscureText: true,
              autocorrect: false,
              keyboardAppearance: Brightness.dark,
            ),
            TextButton(
              onPressed: () {
                final email = emailController.text;
                final password = passwordController.text;
                context.read<FirebaseAppBloc>().add(
                      AppEventLogIn(
                        email: email,
                        password: password,
                      ),
                    );
              },
              child: const Text(
                "Log in",
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<FirebaseAppBloc>().add(
                      const AppEventGoToRegistration(),
                    );
              },
              child: const Text(
                "Not registered yet? Register here!",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
