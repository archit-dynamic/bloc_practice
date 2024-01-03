import 'package:bloc_practice/notes_app_with_bloc/models.dart';
import 'package:flutter/material.dart';

@immutable
class AppState {
  final bool isLoading;
  final LoginErrors? loginError;
  final LoginHandle? loginHandle;
  final Iterable<Note>? fetchedNotes;

  const AppState.empty()
      : isLoading = false,
        loginError = null,
        loginHandle = null,
        fetchedNotes = null;

  const AppState({
    required this.isLoading,
    required this.loginError,
    required this.loginHandle,
    required this.fetchedNotes,
  });

  @override
  String toString() => {
        "isLoading": isLoading,
        "loginError": loginError,
        "loginHandle": loginHandle,
        "fetchedNotes": fetchedNotes,
      }.toString();
}
