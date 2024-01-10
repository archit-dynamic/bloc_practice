import 'package:bloc_practice/multi_bloc_provider_app/bloc/multi_bloc_app_bloc.dart';

class BottomBloc extends MultiBlocAppBloc {
  BottomBloc({
    Duration? waitBeforeLoading,
    required Iterable<String> urls,
  }) : super(
          waitBeforeLoading: waitBeforeLoading,
          urls: urls,
        );
}
