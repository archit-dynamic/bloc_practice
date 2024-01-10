import 'package:bloc_practice/extension/stream/start_with.dart';
import 'package:bloc_practice/multi_bloc_provider_app/bloc/app_state.dart';
import 'package:bloc_practice/multi_bloc_provider_app/bloc/multi_bloc_app_bloc.dart';
import 'package:bloc_practice/multi_bloc_provider_app/bloc/multi_bloc_events.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocView<T extends MultiBlocAppBloc> extends StatelessWidget {
  const AppBlocView({Key? key}) : super(key: key);

  void startUpdatingBloc(BuildContext context) {
    Stream.periodic(
      const Duration(seconds: 10),
      (_) => const LoadNextUrlEvent(),
    ).startWith(const LoadNextUrlEvent()).forEach((event) {
      context.read<T>().add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    startUpdatingBloc(context);
    return Expanded(
      child: BlocBuilder<T, MultiBlocAppState>(
        builder: (context, appState) {
          if (appState.error != null) {
            return const Text("Error");
          } else if (appState.data != null) {
            return Image.memory(
              appState.data!,
              fit: BoxFit.fitHeight,
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
