import 'dart:math';

import 'package:bloc_practice/multi_bloc_provider_app/bloc/app_state.dart';
import 'package:bloc_practice/multi_bloc_provider_app/bloc/multi_bloc_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(
        Random().nextInt(length),
      );
}

@immutable
class MultiBlocAppBloc extends Bloc<MultiBlocAppEvent, MultiBlocAppState> {
  String pickRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();

  MultiBlocAppBloc({
    required Iterable<String> urls,
    Duration? waitBeforeLoading,
    AppBlocRandomUrlPicker? urlPicker,
  }) : super(
          const MultiBlocAppState.empty(),
        ) {
    on<LoadNextUrlEvent>((event, emit) async {
      //start loading
      emit(
        const MultiBlocAppState(
          isLoading: true,
          data: null,
          error: null,
        ),
      );
      final url = (urlPicker ?? pickRandomUrl)(urls);
      try {
        if (waitBeforeLoading != null) {
          await Future.delayed(waitBeforeLoading);
        }
        final bundle = NetworkAssetBundle(Uri.parse(url));
        final data = (await bundle.load(url)).buffer.asUint8List();
        emit(
          MultiBlocAppState(
            isLoading: true,
            data: data,
            error: null,
          ),
        );
      } catch (e) {
        emit(
          MultiBlocAppState(
            isLoading: false,
            data: null,
            error: e,
          ),
        );
      }
    });
  }
}
