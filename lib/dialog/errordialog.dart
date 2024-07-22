import 'package:flutter/material.dart';
import 'package:freecodecamp/dialog/generic_dialog.dart';

Future<void> errordialog({
  required BuildContext context,
  required String error,
}) {
  return genericDialog<void>(
    title: 'error occured',
    content: error,
    context: context,
    optionsbuilder: () {
      return {
        'ok': null,
      };
    },
  );
}
