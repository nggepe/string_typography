import 'package:string_typography/src/configs/private/tag_setting.dart';

class ParagraphChecker {
  final String text;
  ParagraphChecker(this.text);
  ParagraphType get getType {
    if (TagSetting.imageSetting.regExp.hasMatch(this.text))
      return ParagraphType.image;
    else if (TagSetting.codeBlock.regExp.hasMatch(this.text))
      return ParagraphType.codeBlock;
    else
      return ParagraphType.plain;
  }
}

enum ParagraphType { image, plain, codeBlock }
