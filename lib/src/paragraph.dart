import 'package:string_typography/src/tag_setting.dart';

class ParagraphChecker {
  final String text;
  ParagraphChecker(this.text);
  ParagraphType get getType {
    if (TagSetting.imageSetting.regExp.hasMatch(this.text))
      return ParagraphType.image;
    else
      return ParagraphType.plain;
  }
}

enum ParagraphType { image, plain }
