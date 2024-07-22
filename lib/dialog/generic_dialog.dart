import 'package:flutter/material.dart';

typedef GenericOptions<T> = Map<String, T?> Function();
Future<T?> genericDialog<T>(
    {required String title,
    required String content,
    required BuildContext context,
    required GenericOptions optionsbuilder}) {
  final options = optionsbuilder();
  return showDialog<T>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: options.keys.map((name) {
          final T value = options[name];
          return TextButton(
            onPressed: () {
              if (value != null) {
                Navigator.of(context).pop(value);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: Text(name),
          );
        }).toList(),
      );
    },
  );
}
