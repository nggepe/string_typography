import 'package:flutter/material.dart';
import 'package:string_typography/src/main_setting.dart';

class TagSetting {
  final RegExp regExp;
  final TextStyle? style;
  final SettingType type;

  TagSetting({
    required this.regExp,
    this.style,
    this.type: SettingType.tag,
  });

  TagSetting copyWith({
    RegExp? regExp,
    TextStyle? style,
  }) {
    return TagSetting(
      regExp: regExp ?? this.regExp,
      style: style ?? this.style,
    );
  }

  static List<TagSetting> defaultconfiguration = [
    TagSetting(
      regExp:
          RegExp(r"\[(.*?)\]\((.*?)\)", caseSensitive: false, multiLine: true),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
      type: SettingType.hyperlink,
    ),
    TagSetting(
      regExp: RegExp(r"\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b",
          caseSensitive: false, multiLine: true),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
      type: SettingType.email,
    ),
    TagSetting(
      regExp: RegExp(r"#(\w+)", caseSensitive: false, multiLine: true),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
    TagSetting(
      regExp: RegExp(r"@(\w+)", caseSensitive: false, multiLine: true),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    ),
    TagSetting(
      regExp: RegExp(
          r"[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:._\+-~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:_\+.~#?&\/\/=]*)",
          caseSensitive: false,
          multiLine: true),
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.red,
      ),
      type: SettingType.url,
    ),
  ];

  static TagSetting imageSetting = TagSetting(
    regExp: RegExp(r"<img (.*?)\/>", caseSensitive: false, multiLine: true),
  );

  static List<TagSetting> inlineCode = <TagSetting>[
    TagSetting(regExp: RegExp(r"(`(.*?)`)"), type: SettingType.inlineCode),
    TagSetting(
        regExp: RegExp(r"(<code>(.*?)</code>)"), type: SettingType.inlineCode)
  ];
}
