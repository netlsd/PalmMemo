import 'package:flutter/material.dart';

extension IsNullOrEmpty on List {
  bool get isNullOrEmpty {
    return this == null || this.isEmpty;
  }
}

extension Utility on BuildContext {
  void nextEditableTextFocus() {
    do {
      FocusScope.of(this).nextFocus();
    } while (FocusScope.of(this).focusedChild.context.widget is! EditableText);
  }
}
