import 'package:bloc_practice/bloc_app_with_firebase/auth/auth_error.dart';
import 'package:bloc_practice/dialogs/generic_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showAuthError({
  required BuildContext context,
  required AuthError authError,
}) {
  return showGenericDialog<void>(
    context: context,
    title: authError.dialogTitle,
    content: authError.dialogText,
    optionBuilder: () => {
      "OK": true,
    },
  );
}
