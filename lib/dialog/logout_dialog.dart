import 'package:flutter/material.dart';
import 'package:freecodecamp/dialog/generic_dialog.dart';

Future<bool> conformationDialog(
    {required BuildContext context,
    required String title,
    required String content,
    required String button}) {
  return genericDialog<bool?>(
      title: title,
      content: content,
      context: context,
      optionsbuilder: () => {
            'cancel': false,
            button: true,
          }).then((value) => value ?? false);
}
