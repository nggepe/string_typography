import 'package:flutter/material.dart';
import 'package:string_typography/src/configs/public/common_setting.dart';
import 'package:string_typography/src/configs/public/configuration.dart';
import 'package:string_typography/src/configs/public/st_code_block.dart';
import 'package:string_typography/src/configs/public/st_paragraph.dart';
import 'package:string_typography/src/utils/paragraph_speller.dart';

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
  List<Widget> _widgets = [];

  bool loading = true;

  @override
  void initState() {
    _process(widget.text);
    super.initState();
  }

  void _process(String text) {
    final ParagraphSpeller speller = ParagraphSpeller(
        codeBlockConfig: widget.codeBlockConfiguration,
        commonSetting: widget.commonSetting ?? [],
        inlineCodeConfiguration: widget.inlineCodeConfiguration,
        globalStyle: widget.globalStyle,
        emailConfiguration: widget.emailConfiguration,
        tagConfiguration: widget.tagConfiguration,
        linkConfiguration: widget.linkConfiguration,
        paragraphConfig: widget.paragraphConfig);
    _widgets = speller.process(text);

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
