import 'dart:typed_data';

import 'package:flutter/material.dart';

@immutable
class MultiBlocAppState {
  final bool isLoading;
  final Uint8List? data;
  final Object? error;

  const MultiBlocAppState({
    required this.isLoading,
    required this.data,
    required this.error,
  });

  const MultiBlocAppState.empty()
      : isLoading = false,
        data = null,
        error = null;

  @override
  String toString() => {
        "isLoading": isLoading,
        "hasData": data != null,
        "error": error,
      }.toString();
}
