import 'package:flutter/material.dart';

class StCodeBlockConfig {
  final bool copyClipboard;
  final CodeBlockTheme theme;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  const StCodeBlockConfig({
    this.copyClipboard: true,
    this.theme: CodeBlockTheme.dark,
    this.borderRadius: 5,
    this.padding,
  });
}

enum CodeBlockTheme { dark }
