import 'package:flutter/material.dart';
import 'package:freecodecamp/dialog/generic_dialog.dart';

Future<void> shareemptynote(BuildContext context) async {
  return genericDialog(
    title: "sharing empty note",
    content: "you can't share empty note",
    context: context,
    optionsbuilder: () => {
      "ok": null,
    },
  );
}
