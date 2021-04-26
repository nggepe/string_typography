import 'package:flutter/material.dart';

class StConfig {
  final TextStyle? style;

  final void Function(String word, Offset localPosition, Offset globalPosition)?
      onTap;
  final void Function(String word, Offset localPosition, Offset globalPosition)?
      onLongPress;

  const StConfig({
    this.style,
    this.onTap,
    this.onLongPress,
  });
}
