import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CommonSetting {
  final String open;
  final String close;
  final GestureRecognizer? recognizer;
  final TextStyle? style;
  const CommonSetting({
    required this.open,
    required this.close,
    this.recognizer,
    this.style,
  });

  CommonSetting copyWith({
    String? open,
    String? close,
    GestureRecognizer? recognizer,
    TextStyle? style,
  }) {
    return CommonSetting(
      open: open ?? this.open,
      close: close ?? this.close,
      recognizer: recognizer ?? this.recognizer,
      style: style ?? this.style,
    );
  }

  static const defaultconfiguration = <CommonSetting>[
    CommonSetting(
        open: "\\*\\*",
        close: "\\*\\*",
        style: TextStyle(fontWeight: FontWeight.w900)),
    CommonSetting(
        open: "\\*",
        close: "\\*",
        style: TextStyle(fontStyle: FontStyle.italic)),
    CommonSetting(
        open: "_",
        close: "_",
        style: TextStyle(decoration: TextDecoration.underline)),
  ];
}
