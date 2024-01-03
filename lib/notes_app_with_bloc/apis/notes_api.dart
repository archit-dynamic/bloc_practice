import 'package:bloc_practice/notes_app_with_bloc/models.dart';
import 'package:flutter/material.dart';

@immutable
abstract class NotesApiProtocol {
  const NotesApiProtocol();

  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  });
}

@immutable
class NotesApi implements NotesApiProtocol {
  //singleton pattern
  // const NotesApi._sharedInstance();
  //
  // static const NotesApi _shared = NotesApi._sharedInstance();
  //
  // factory NotesApi.instance() => _shared;

  @override
  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  }) =>
      Future.delayed(
        const Duration(seconds: 2),
        () => loginHandle == const LoginHandle.archit() ? mockNotes : null,
      );
}
