import 'dart:io';

import 'package:bloc_practice/bloc_app_with_firebase/auth/auth_error.dart';
import 'package:bloc_practice/bloc_app_with_firebase/bloc/firebase_app_event.dart';
import 'package:bloc_practice/bloc_app_with_firebase/bloc/firebase_app_state.dart';
import 'package:bloc_practice/bloc_app_with_firebase/utils/upload_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FirebaseAppBloc extends Bloc<FirebaseAppEvent, FirebaseAppState> {
  FirebaseAppBloc()
      : super(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        ) {
    on<AppEventGoToRegistration>((event, emit) {
      emit(
        const AppStateIsInRegistrationView(
          isLoading: false,
        ),
      );
    });

    on<AppEventLogIn>((event, emit) async {
      //start loading
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );
      //log the user in
      try {
        final email = event.email;
        final password = event.password;
        final userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        final user = userCredential.user!;
        final images = await getImages(user.uid);
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedOut(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    on<AppEventGoToLogin>((event, emit) {
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    });

    on<AppEventRegister>((event, emit) async {
      //start loading
      emit(
        const AppStateIsInRegistrationView(
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final credentials =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: credentials.user!,
            images: const [],
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateIsInRegistrationView(
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      }
    });

    on<AppEventInitialize>((event, emit) async {
      //get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
        return;
      } else {
        //go grab the user's uploaded images
        final images = await getImages(user.uid);
        emit(
          AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: images,
          ),
        );
      }
    });

    //log out event
    on<AppEventLogOut>((event, emit) async {
      //start loading
      emit(
        const AppStateLoggedOut(
          isLoading: true,
        ),
      );
      //log the user out
      await FirebaseAuth.instance.signOut();
      //log the user out in the ui
      emit(
        const AppStateLoggedOut(
          isLoading: false,
        ),
      );
    });

    //handle account deletion
    on<AppEventDeleteAccount>((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      //logout user if we don't have a current user
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
        return;
      }
      //start loading
      emit(
        AppStateLoggedIn(
          user: user,
          images: state.images ?? [],
          isLoading: true,
        ),
      );
      //delete the user folder
      try {
        //delete user folder
        final folder = await FirebaseStorage.instance.ref(user.uid).listAll();
        for (final item in folder.items) {
          await item.delete().catchError((_) {}); //maybe handle the error
        }
        //delete the folder itself
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) {});
        //delete the user
        await user.delete();
        //log the user out
        await FirebaseAuth.instance.signOut();
        //log the user out in the ui
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      } on FirebaseAuthException catch (e) {
        emit(
          AppStateLoggedIn(
            user: user,
            images: state.images ?? [],
            isLoading: false,
            authError: AuthError.from(e),
          ),
        );
      } on FirebaseException {
        //we might not be able to delete the folder
        //log the user out
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
      }
    });

    //handle uploading images
    on<AppEventUploadImage>((event, emit) async {
      final user = state.user;
      //logout user if we don't have an actual user in app state
      if (user == null) {
        emit(
          const AppStateLoggedOut(
            isLoading: false,
          ),
        );
        return;
      }
      //start the loading process
      emit(
        AppStateLoggedIn(
          user: user,
          images: state.images ?? [],
          isLoading: true,
        ),
      );

      //upload the file
      final file = File(event.filePathToUpload);
      await uploadImage(
        file: file,
        userId: user.uid,
      );
      //after upload is complete grab the latest file references
      final images = await getImages(user.uid);
      //emit new images and turn off loading
      emit(
        AppStateLoggedIn(
          user: user,
          images: images,
          isLoading: false,
        ),
      );
    });
  }

  Future<Iterable<Reference>> getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
