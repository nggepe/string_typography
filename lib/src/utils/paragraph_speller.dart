import 'package:flutter/material.dart';
import 'package:string_typography/src/configs/private/main_setting.dart';
import 'package:string_typography/src/configs/private/tag_setting.dart';
import 'package:string_typography/src/configs/public/common_setting.dart';
import 'package:string_typography/src/configs/public/configuration.dart';
import 'package:string_typography/src/configs/public/st_code_block.dart';
import 'package:string_typography/src/configs/public/st_paragraph.dart';
import 'package:string_typography/src/utils/paragraph_checker.dart';
import 'package:string_typography/src/widgets/code_block.dart';
import 'package:string_typography/src/widgets/image.dart';
import 'package:string_typography/src/widgets/paragraph.dart';

class ParagraphSpeller {
  final StCodeBlockConfig codeBlockConfig;
  final List<CommonSetting> commonSetting;
  final StConfig inlineCodeConfiguration;
  final TextStyle? globalStyle;
  final StConfig emailConfiguration;
  final StConfig tagConfiguration;

  ///url or hyperlink setup is here. Styling or gesture event.
  final StConfig linkConfiguration;
  final StParagraphConfig paragraphConfig;

  ParagraphSpeller(
      {required this.codeBlockConfig,
      required this.commonSetting,
      required this.inlineCodeConfiguration,
      this.globalStyle,
      required this.emailConfiguration,
      required this.tagConfiguration,
      required this.linkConfiguration,
      required this.paragraphConfig});

  final String _separator = "™»\n«™";
  final String _paragraphSeparator = "™»p\np«™";

  List<Widget> process(String? text) {
    if (text == "" || text == null) return [];
    List<Widget> widgets = [];
    int i = 0;
    List<MainSetting> mainsettings = [];

    text = text.replaceAllMapped(TagSetting.imageSetting.regExp,
        (match) => _paragraphSeparator + match.group(0)! + _paragraphSeparator);

    text = text.replaceAllMapped(TagSetting.codeBlock.regExp,
        (match) => _paragraphSeparator + match.group(0)! + _paragraphSeparator);

    List<String> paragraphs = text.split(this._paragraphSeparator);

    paragraphs.forEach((paragraph) {
      if (paragraph != "")
        switch (ParagraphChecker(paragraph).getType) {
          case ParagraphType.image:
            widgets.add(StImage(
              paragraph,
            ));
            break;
          case ParagraphType.codeBlock:
            widgets.add(StCodeBlock(
                configuration: this.codeBlockConfig, text: paragraph));
            break;
          default:
            this.commonSetting.forEach((element) {
              RegExp exp = new RegExp(
                  r"" + element.open + "(\\S.*?)" + element.close,
                  caseSensitive: false,
                  multiLine: true,
                  dotAll: true);
              String open = "™»${i.toString()}O«™",
                  close = "™»${i.toString()}C«™";
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
              i++;
            });

            int j = 0;
            TagSetting.defaultconfiguration.forEach((element) {
              String open = "™»${j.toString()}Q«™",
                  close = "™»${j.toString()}D«™";
              paragraph = paragraph.replaceAllMapped(element.regExp, (match) {
                String confirm = "";

                if (paragraph.length > match.end)
                  confirm = paragraph.substring(match.end, match.end + 1);
                if (match.start > 0)
                  confirm = paragraph.substring(match.start - 1, match.start);

                if (confirm == "" || confirm == " " || confirm == "\n")
                  return this._separator +
                      "$open${match.group(0)}$close" +
                      this._separator;
                else
                  return match.group(0)!;
              });
              mainsettings.add(MainSetting(
                  open: open,
                  close: close,
                  style: element.style,
                  type: element.type));
              j++;
            });

            int k = 0;
            TagSetting.inlineCode.forEach((iC) {
              String open = "™»${k.toString()}R«™",
                  close = "™»${k.toString()}E«™";
              paragraph = paragraph.replaceAllMapped(iC.regExp, (match) {
                String confirm = "";

                if (paragraph.length > match.end)
                  confirm = paragraph.substring(match.end, match.end + 1);
                if (match.start > 0)
                  confirm = paragraph.substring(match.start - 1, match.start);

                if (confirm == "" || confirm == " " || confirm == "\n")
                  return this._separator +
                      "$open${match.group(2)}$close" +
                      this._separator;
                else
                  return match.group(0)!;
              });

              mainsettings.add(MainSetting(
                  open: open,
                  close: close,
                  type: iC.type,
                  style: this.inlineCodeConfiguration.style));

              k++;
            });
            List<String> stParagraph = paragraph.split(this._separator);
            widgets.add(StParagraph(stParagraph,
                globalStyle: this.globalStyle,
                mainsettings: mainsettings,
                emailConfiguration: this.emailConfiguration,
                inlineCodeConfiguration: this.inlineCodeConfiguration,
                linkConfiguration: this.linkConfiguration,
                paragraphConfig: this.paragraphConfig,
                tagConfiguration: this.tagConfiguration));
        }
    });

    return widgets;
  }
}
