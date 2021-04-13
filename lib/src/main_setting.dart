import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class MainSetting {
  final String open;
  final String close;
  final GestureRecognizer? recognizer;
  final TextStyle? style;
  final SettingType type;
  MainSetting({
    required this.open,
    required this.close,
    this.recognizer,
    this.style,
    required this.type,
  });

  MainSetting copyWith({
    String? open,
    String? close,
    GestureRecognizer? recognizer,
    TextStyle? style,
    SettingType? type,
  }) {
    return MainSetting(
      open: open ?? this.open,
      close: close ?? this.close,
      recognizer: recognizer ?? this.recognizer,
      style: style ?? this.style,
      type: type ?? this.type,
    );
  }
}

enum SettingType { common, tag, url, email, hyperlink, image, inlineCode }
