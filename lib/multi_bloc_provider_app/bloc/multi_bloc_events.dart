import 'package:flutter/material.dart';

@immutable
abstract class MultiBlocAppEvent {
  const MultiBlocAppEvent();
}

@immutable
class LoadNextUrlEvent implements MultiBlocAppEvent {
  const LoadNextUrlEvent();
}
