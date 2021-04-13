import 'package:flutter/material.dart';

class StConfiguration {
  final TextStyle? style;

  final void Function(String word, Key key)? onTap;
  final void Function(String word, Key key)? onDoubleTap;
  final void Function(String word, Key key)? onLongPress;

  const StConfiguration({
    this.style,
    this.onTap,
    this.onDoubleTap,
    this.onLongPress,
  });
}

class StInlineCodeConfiguration {
  final Color backgroundColor;
  final TextStyle style;
  final EdgeInsetsGeometry padding;
  final double boxRadius;
  const StInlineCodeConfiguration({
    this.backgroundColor: const Color(0xff999999),
    this.style: const TextStyle(color: Color(0xff000000)),
    this.padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    this.boxRadius: 5,
  });
}
