import 'package:flutter/material.dart';
import 'package:string_typography/src/configs/public/common_setting.dart';
import 'package:string_typography/src/configs/public/configuration.dart';
import 'package:string_typography/src/configs/public/st_code_block.dart';
import 'package:string_typography/src/configs/public/st_paragraph.dart';
import 'package:string_typography/src/utils/paragraph_speller.dart';
import 'package:string_typography/src/widgets/code_block.dart';
import 'package:string_typography/src/widgets/image.dart';
import 'package:string_typography/src/configs/private/main_setting.dart';
import 'package:string_typography/src/utils/paragraph_checker.dart';
import 'package:string_typography/src/configs/private/tag_setting.dart';
import 'package:string_typography/src/widgets/paragraph.dart';

///this is a widget that convert text to be widgets
///you can use it for your text converter or others.
///[StringTypography] handle the text with replacement, i.e.
///* `*text*` will be *italic* `text` and
///`* text*` will not convert.
///* `#text` will be #hastagstyle but # text will be heading style.
class StringTypography extends StatefulWidget {
  ///common typography setting, these are the default setting of this argument:
  ///* `**bold**` will be **bold**
  ///* `*italic` will be *italic*
  ///* `_underline_` will be underline text
  final List<CommonSetting>? commonSetting;

  ///your `String` that you will convert to be widget typography
  final String text;

  ///This is a `TextStyle`. All text depend on this style. '''**REMINDER**, when you use a `FontWeight.bold`,
  ///all of your text weight will be **bold**, so you can't expect that the **bold** on default of `commonSetting` can be in a higher level.
  ///you have to resetting the `commonSetting`'''
  final TextStyle? globalStyle;

  ///This parameter is to setUp your tag style and some gesture event. **What tags which provided?** for now,
  ///we just provide @ and #, feel free to discuss it on github issue.
  final StConfig tagConfiguration;

  ///url or hyperlink setup is here. Styling or gesture event.
  final StConfig linkConfiguration;

  ///email setup is here. Styling or gesture event.
  final StConfig emailConfiguration;

  final StParagraphConfig paragraphConfig;

  ///[inlinCodeConfiguration] is, like `this` <--- is inline code.
  ///it needs styling. We create any arguments on it for you, so you can customiza it.
  final StConfig inlineCodeConfiguration;

  final StCodeBlockConfig codeBlockConfiguration;

  ///this is a widget that convert text to be widgets
  ///you can use it for your text converter or others.
  ///[StringTypography] handle the text with replacement, i.e.
  ///* `*text*` will be *italic* `text` and
  ///`* text*` will not convert.
  ///* `#text` will be #hastagstyle but # text will be heading style.
  const StringTypography(
      {Key? key,
      this.globalStyle,
      this.paragraphConfig: const StParagraphConfig(),
      this.commonSetting: CommonSetting.defaultconfiguration,
      this.linkConfiguration:
          const StConfig(style: TextStyle(color: Colors.blue)),
      this.emailConfiguration:
          const StConfig(style: TextStyle(color: Colors.blue)),
      required this.text,
      this.tagConfiguration:
          const StConfig(style: TextStyle(color: Colors.blue)),
      this.inlineCodeConfiguration:
          const StConfig(style: TextStyle(color: Color(0xff333333))),
      this.codeBlockConfiguration: const StCodeBlockConfig()})
      : super(key: key);

  @override
  _StringTypographyState createState() => _StringTypographyState();
}

class _StringTypographyState extends State<StringTypography> {
  List<MainSetting> _mainsettings = [];
  final String _separator = "™»\n«™";
  final String _paragraphSeparator = "™»p\np«™";
  List<Widget> _widgets = [];

  bool loading = true;

  @override
  void initState() {
    _process(widget.text);
    super.initState();
  }

  void _process(String text) {
    _mainsettings = [];

    text = text.replaceAllMapped(TagSetting.imageSetting.regExp,
        (match) => _paragraphSeparator + match.group(0)! + _paragraphSeparator);

    text = text.replaceAllMapped(TagSetting.codeBlock.regExp,
        (match) => _paragraphSeparator + match.group(0)! + _paragraphSeparator);

    List<String> paragraphs = text.split(this._paragraphSeparator);

    paragraphs.forEach((paragraph) {
      switch (ParagraphChecker(paragraph).getType) {
        case ParagraphType.image:
          _widgets.add(StImage(paragraph));
          break;
        case ParagraphType.codeBlock:
          _widgets.add(StCodeBlock(
              configuration: this.widget.codeBlockConfiguration,
              text: paragraph));
          break;
        default:
          final ParagraphSpeller speller = ParagraphSpeller();
          var common =
              speller.commonSetting(widget.commonSetting ?? [], paragraph);
          paragraph = common.paragraph;
          _mainsettings.addAll(common.mainSettings);

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
            _mainsettings.add(MainSetting(
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

            _mainsettings.add(MainSetting(
                open: open,
                close: close,
                type: iC.type,
                style: this.widget.inlineCodeConfiguration.style));

            k++;
          });

          _widgets.add(StParagraph(paragraph.split(this._separator),
              globalStyle: this.widget.globalStyle,
              mainsettings: this._mainsettings,
              emailConfiguration: this.widget.emailConfiguration,
              inlineCodeConfiguration: this.widget.inlineCodeConfiguration,
              linkConfiguration: this.widget.linkConfiguration,
              paragraphConfig: this.widget.paragraphConfig,
              tagConfiguration: this.widget.tagConfiguration));
      }
    });

    setState(() {
      loading = false;
    });
  }

  @override
  void didUpdateWidget(covariant StringTypography oldWidget) {
    setState(() {
      loading = true;
    });
    _widgets = [];
    _process(widget.text);
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    if (loading == true)
      return Container(
        child: CircularProgressIndicator(),
      );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _widgets.map((e) => e).toList(),
    );
  }
}
