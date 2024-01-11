import 'dart:io';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:bloc_practice/bloc_app_with_firebase/bloc/firebase_app_bloc.dart';
import 'package:bloc_practice/bloc_app_with_firebase/bloc/firebase_app_event.dart';
import 'package:bloc_practice/bloc_app_with_firebase/bloc/firebase_app_state.dart';
import 'package:bloc_practice/bloc_app_with_firebase/views/firebase_login_view.dart';
import 'package:bloc_practice/bloc_app_with_firebase/views/firebase_registration_view.dart';
import 'package:bloc_practice/bloc_app_with_firebase/views/photo_gallery_view.dart';
import 'package:bloc_practice/dialogs/loading_screen.dart';
import 'package:bloc_practice/dialogs/show_auth_error.dart';
import 'package:bloc_practice/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<FirebaseAppBloc>(
      create: (_) => FirebaseAppBloc()
        ..add(
          const AppEventInitialize(),
        ),
      child: MaterialApp(
        title: 'Photo Library',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: BlocProvider(
        //   create: (_) => ProductBloc(),
        //   child: const FirstBlocExampleHome(),
        // ),
        // home: const NotesHome(),
        // home: const MultiBlocHome(),
        home: BlocConsumer<FirebaseAppBloc, FirebaseAppState>(
          listener: (context, appState) {
            if (appState.isLoading) {
              LoadingScreen.instance()
                  .show(context: context, text: "Loading...");
            } else {
              LoadingScreen.instance().hide();
            }
            final authError = appState.authError;
            if (authError != null) {
              showAuthError(context: context, authError: authError);
            }
          },
          builder: (context, appState) {
            if (appState is AppStateLoggedOut) {
              return const FirebaseLoginView();
            } else if (appState is AppStateLoggedIn) {
              return const PhotoGalleryView();
            } else if (appState is AppStateIsInRegistrationView) {
              return const FirebaseRegistrationView();
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

const names = ["Foo", "Bar", "Baz"];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);

  void pickRandomName() => emit(
        names.getRandomElement(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NamesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    super.dispose();
    cubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (context, snapshot) {
          final button = TextButton(
            onPressed: () => cubit.pickRandomName(),
            child: const Text("Pick a random name"),
          );
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return button;
            case ConnectionState.waiting:
              return button;
            case ConnectionState.active:
              return Column(
                children: [
                  Text(snapshot.data ?? ""),
                  button,
                ],
              );
            case ConnectionState.done:
              return const SizedBox();
          }
        },
      ),
    );
  }
}
