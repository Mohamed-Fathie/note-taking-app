import 'package:flutter/material.dart';

typedef Closedialog = void Function();

Closedialog loadingdialog({
  required BuildContext context,
  required String text,
}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(
            height: 10,
          ),
          Text(text),
        ],
      ),
    ),
  );
  return () => Navigator.of(context).pop();
}
