import 'package:flutter/widgets.dart';
import 'package:freecodecamp/dialog/generic_dialog.dart';

Future<void> restpassword({required BuildContext context}) {
  return genericDialog(
      title: "rest password",
      content: "check your email ",
      context: context,
      optionsbuilder: () => {"ok": null});
}
