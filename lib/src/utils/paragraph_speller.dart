import 'package:string_typography/src/configs/private/main_setting.dart';
import 'package:string_typography/src/configs/private/tag_setting.dart';
import 'package:string_typography/string_typography.dart';

class ParagraphSpeller {
  final String _separator = "™»\n«™";
  final String _hyperlinkSeparator = "™»hy«™";
  int counter = 0;

  ParagraphSpellerOutput commonSetting(
      List<CommonSetting> commonSetting, String paragraph) {
    List<MainSetting> mainsettings = [];

    commonSetting.forEach((element) {
      RegExp exp = new RegExp(r"" + element.open + "(\\S.*?)" + element.close,
          caseSensitive: false, multiLine: true, dotAll: true);
      String open = "™»${counter.toString()}O«™",
          close = "™»${counter.toString()}C«™";
      paragraph = paragraph.replaceAllMapped(exp, (match) {
        return this._separator +
            "$open${match.group(1)}$close" +
            this._separator;
      });
      mainsettings.add(MainSetting(
        open: open,
        close: close,
        type: SettingType.common,
        style: element.style,
        recognizer: element.recognizer,
      ));
      this.counter++;
    });
    return ParagraphSpellerOutput(
        paragraph: paragraph, mainSettings: mainsettings);
  }

  ParagraphSpellerOutput hyperlink(String paragraph) {
    String open = "™»${counter.toString()}O«™",
        close = "™»${counter.toString()}C«™";
    this.counter++;

    paragraph = paragraph.replaceAllMapped(
        TagSetting.hyperlink.regExp, (match) => match.group(0)!);
    return ParagraphSpellerOutput(paragraph: paragraph, mainSettings: [
      MainSetting(open: open, close: close, style: TagSetting.hyperlink.style)
    ]);
  }

  ParagraphSpellerOutput tagSetting(String paragraph) {
    List<MainSetting> mainSettings = [];
    var hype = hyperlink(paragraph);
    mainSettings.addAll(hype.mainSettings);

    String newParagraph = "";

    hype.paragraph.split(this._hyperlinkSeparator).forEach((element) {
      if (element != "") {
        if (isHyperlink(element)) newParagraph += element;
      }
    });

    return hype;
  }

  bool isHyperlink(String text) {
    return TagSetting.hyperlink.regExp.hasMatch(text);
  }
}

class ParagraphSpellerOutput {
  String paragraph;
  List<MainSetting> mainSettings;
  ParagraphSpellerOutput({
    required this.paragraph,
    required this.mainSettings,
  });
}
