import 'package:flutter/material.dart';

extension GetArgument on BuildContext {
  T? getargument<T>() {
    final modolroute = ModalRoute.of(this);
    if (modolroute != null) {
      final args = modolroute.settings.arguments;
      if (args != null && args is T) {
        return args as T;
      }
    }
    return null;
  }
}
