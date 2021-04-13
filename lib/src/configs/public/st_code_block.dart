import 'package:flutter/material.dart';

class StCodeBlockConfig {
  final bool copyClipboard;
  final TextStyle? textStyle;
  final BoxDecoration? decoration;
  const StCodeBlockConfig({
    this.copyClipboard: true,
    this.textStyle,
    this.decoration,
  });
}
