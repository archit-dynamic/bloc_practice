import 'package:bloc/bloc.dart';
import 'package:bloc_practice/notes_app_with_bloc/apis/login_api.dart';
import 'package:bloc_practice/notes_app_with_bloc/apis/notes_api.dart';
import 'package:bloc_practice/notes_app_with_bloc/bloc/actions.dart';
import 'package:bloc_practice/notes_app_with_bloc/bloc/app_state.dart';
import 'package:bloc_practice/notes_app_with_bloc/models.dart';

class AppBloc extends Bloc<AppAction, AppState> {
  final LoginApiProtocol loginApi;
  final NotesApiProtocol notesApi;

  AppBloc({
    required this.loginApi,
    required this.notesApi,
  }) : super(const AppState.empty()) {
    on<LoginAction>((event, emit) async {
      //start loading
      emit(
        const AppState(
          isLoading: true,
          loginError: null,
          loginHandle: null,
          fetchedNotes: null,
        ),
      );
      //log the user in
      final loginHandle = await loginApi.login(
        email: event.email,
        password: event.password,
      );
      emit(
        AppState(
          isLoading: false,
          loginError: loginHandle == null ? LoginErrors.invalidHandle : null,
          loginHandle: loginHandle,
          fetchedNotes: null,
        ),
      );
    });

    on<LoadNotesAction>((event, emit) async {
      //start loading
      emit(
        AppState(
          isLoading: true,
          loginError: null,
          loginHandle: state.loginHandle,
          fetchedNotes: null,
        ),
      );
      //get the login handle
      final loginHandle = state.loginHandle;
      if (loginHandle != const LoginHandle.archit()) {
        //invalid login handle, cannot fetch notes
        emit(
          AppState(
            isLoading: true,
            loginError: LoginErrors.invalidHandle,
            loginHandle: loginHandle,
            fetchedNotes: null,
          ),
        );
        return;
      }

      //this is a valid login handle and fetch notes
      final notes = await notesApi.getNotes(loginHandle: loginHandle!);
      emit(
        AppState(
          isLoading: false,
          loginError: null,
          loginHandle: loginHandle,
          fetchedNotes: notes,
        ),
      );
    });
  }
}
