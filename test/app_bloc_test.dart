import 'package:bloc_practice/notes_app_with_bloc/apis/login_api.dart';
import 'package:bloc_practice/notes_app_with_bloc/apis/notes_api.dart';
import 'package:bloc_practice/notes_app_with_bloc/bloc/actions.dart';
import 'package:bloc_practice/notes_app_with_bloc/bloc/app_bloc.dart';
import 'package:bloc_practice/notes_app_with_bloc/bloc/app_state.dart';
import 'package:bloc_practice/notes_app_with_bloc/models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const Iterable<Note> mockNotes = [
  Note(title: "Note 1"),
  Note(title: "Note 2"),
  Note(title: "Note 3"),
];

const acceptedLoginHandle = LoginHandle(token: "ABC");

@immutable
class DummyNotesApi extends NotesApiProtocol {
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturnForAcceptedLoginHandle;

  const DummyNotesApi({
    required this.acceptedLoginHandle,
    required this.notesToReturnForAcceptedLoginHandle,
  });

  const DummyNotesApi.empty()
      : acceptedLoginHandle = const LoginHandle.archit(),
        notesToReturnForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    if (loginHandle == acceptedLoginHandle) {
      return notesToReturnForAcceptedLoginHandle;
    } else {
      return null;
    }
  }
}

@immutable
class DummyLoginApi extends LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandle handleToReturn;

  const DummyLoginApi({
    required this.acceptedEmail,
    required this.acceptedPassword,
    required this.handleToReturn,
  });

  const DummyLoginApi.empty()
      : acceptedEmail = "",
        acceptedPassword = "",
        handleToReturn = const LoginHandle.archit();

  @override
  Future<LoginHandle?> login(
      {required String email, required String password}) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return handleToReturn;
    } else {
      return null;
    }
  }
}

void main() {
  blocTest<AppBloc, AppState>(
    "Initial state of the bloc should be AppState.empty()",
    build: () => AppBloc(
      loginApi: const DummyLoginApi.empty(),
      notesApi: const DummyNotesApi.empty(),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    verify: (appState) => expect(
      appState.state,
      const AppState.empty(),
    ),
  );

  blocTest<AppBloc, AppState>(
    "Can we login with correct credentials",
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: "archit@122.com",
        acceptedPassword: "1234",
        handleToReturn: acceptedLoginHandle,
      ),
      notesApi: const DummyNotesApi.empty(),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    act: (bloc) => bloc.add(
      const LoginAction(
        email: "archit@122.com",
        password: "1234",
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptedLoginHandle,
        fetchedNotes: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    "We should not be able to login with incorrect credentials",
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: "archit@122.com",
        acceptedPassword: "1234",
        handleToReturn: acceptedLoginHandle,
      ),
      notesApi: const DummyNotesApi.empty(),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    act: (bloc) => bloc.add(
      const LoginAction(
        email: "archit@1223.com",
        password: "12345",
      ),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: LoginErrors.invalidHandle,
        loginHandle: null,
        fetchedNotes: null,
      ),
    ],
  );

  blocTest<AppBloc, AppState>(
    "Load some notes with valid login handle",
    build: () => AppBloc(
      loginApi: const DummyLoginApi(
        acceptedEmail: "archit@123.com",
        acceptedPassword: "12345",
        handleToReturn: acceptedLoginHandle,
      ),
      notesApi: const DummyNotesApi(
        acceptedLoginHandle: acceptedLoginHandle,
        notesToReturnForAcceptedLoginHandle: mockNotes,
      ),
      acceptedLoginHandle: acceptedLoginHandle,
    ),
    act: (bloc) {
      bloc.add(
        const LoginAction(
          email: "archit@123.com",
          password: "12345",
        ),
      );
      bloc.add(
        const LoadNotesAction(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptedLoginHandle,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: acceptedLoginHandle,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptedLoginHandle,
        fetchedNotes: mockNotes,
      )
    ],
  );
}
