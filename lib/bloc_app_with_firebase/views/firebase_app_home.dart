import 'package:flutter/material.dart';

class FirebaseAppHome extends StatelessWidget {
  const FirebaseAppHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Firebase App"),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
