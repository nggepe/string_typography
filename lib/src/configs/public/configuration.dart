import 'package:flutter/material.dart';

class StConfig {
  final TextStyle? style;

  final void Function(String word, Key key)? onTap;
  final void Function(String word, Key key)? onDoubleTap;
  final void Function(String word, Key key)? onLongPress;

  const StConfig({
    this.style,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  });
}
