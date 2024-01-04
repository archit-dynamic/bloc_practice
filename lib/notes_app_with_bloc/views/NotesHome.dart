import 'package:bloc_practice/dialogs/generic_dialog.dart';
import 'package:bloc_practice/dialogs/loading_screen.dart';
import 'package:bloc_practice/notes_app_with_bloc/apis/login_api.dart';
import 'package:bloc_practice/notes_app_with_bloc/apis/notes_api.dart';
import 'package:bloc_practice/notes_app_with_bloc/bloc/actions.dart';
import 'package:bloc_practice/notes_app_with_bloc/bloc/app_bloc.dart';
import 'package:bloc_practice/notes_app_with_bloc/bloc/app_state.dart';
import 'package:bloc_practice/notes_app_with_bloc/models.dart';
import 'package:bloc_practice/notes_app_with_bloc/strings.dart';
import 'package:bloc_practice/notes_app_with_bloc/views/iterable_list_view.dart';
import 'package:bloc_practice/notes_app_with_bloc/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesHome extends StatelessWidget {
  const NotesHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(
        loginApi: LoginApi(),
        notesApi: NotesApi(),
        acceptedLoginHandle: const LoginHandle.archit(),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
          centerTitle: true,
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState) {
            // loading screen
            if (appState.isLoading) {
              LoadingScreen.instance().show(
                context: context,
                text: pleaseWait,
              );
            } else {
              LoadingScreen.instance().hide();
            }
            // display possible errors
            final loginError = appState.loginError;
            if (loginError != null) {
              showGenericDialog(
                context: context,
                title: loginErrorDialogTitle,
                content: loginErrorDialogContent,
                optionBuilder: () => {
                  ok: true,
                },
              );
            }
            //if we are logged in, but we have no fetch notes
            if (appState.isLoading == false &&
                appState.loginError == null &&
                appState.loginHandle == const LoginHandle.archit() &&
                appState.fetchedNotes == null) {
              context.read<AppBloc>().add(
                    const LoadNotesAction(),
                  );
            }
          },
          builder: (context, appState) {
            final notes = appState.fetchedNotes;
            if (notes == null) {
              return LoginView(
                onLoginTapped: (email, password) {
                  context.read<AppBloc>().add(
                        LoginAction(
                          email: email,
                          password: password,
                        ),
                      );
                },
              );
            } else {
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
