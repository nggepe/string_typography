import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:string_typography/src/common_setting.dart';
import 'package:string_typography/src/configuration.dart';
import 'package:string_typography/src/image.dart';
import 'package:string_typography/src/inline_code.dart';
import 'package:string_typography/src/main_setting.dart';
import 'package:string_typography/src/paragraph.dart';
import 'package:string_typography/src/tag_setting.dart';

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
  final StConfiguration tagConfiguration;

  ///url or hyperlink setup is here. Styling or gesture event.
  final StConfiguration linkConfiguration;

  ///email setup is here. Styling or gesture event.
  final StConfiguration emailConfiguration;

  ///the text alignment for paragraph (`text`).
  final TextAlign paragraphAlignment;

  ///[inlinCodeConfiguration] is, like `this` <--- is inline code.
  ///it needs styling. We create any arguments on it for you, so you can customiza it.
  final StInlineCodeConfiguration inlineCodeConfiguration;

  ///this is a widget that convert text to be widgets
  ///you can use it for your text converter or others.
  ///[StringTypography] handle the text with replacement, i.e.
  ///* `*text*` will be *italic* `text` and
  ///`* text*` will not convert.
  ///* `#text` will be #hastagstyle but # text will be heading style.
  const StringTypography(
      {Key? key,
      this.globalStyle,
      this.commonSetting: CommonSetting.defaultconfiguration,
      this.linkConfiguration:
          const StConfiguration(style: TextStyle(color: Colors.blue)),
      this.emailConfiguration:
          const StConfiguration(style: TextStyle(color: Colors.blue)),
      required this.text,
      this.tagConfiguration:
          const StConfiguration(style: TextStyle(color: Colors.blue)),
      this.paragraphAlignment: TextAlign.start,
      this.inlineCodeConfiguration: const StInlineCodeConfiguration()})
      : super(key: key);

  @override
  _StringTypographyState createState() => _StringTypographyState();
}

class _StringTypographyState extends State<StringTypography> {
  List<MainSetting> _mainsettings = [];
  final String _separator = "™»\n«™";
  final String _paragraphSeparator = "™»p\np«™";
  List<Widget> _widgets = [];

  @override
  void initState() {
    _process(widget.text);
    super.initState();
  }

  void _process(String text) {
    _mainsettings = [];
    int i = 0;

    text = text.replaceAllMapped(TagSetting.imageSetting.regExp,
        (match) => _paragraphSeparator + match.group(0)! + _paragraphSeparator);

    List<String> paragraphs = text.split(this._paragraphSeparator);

    paragraphs.forEach((paragraph) {
      switch (ParagraphChecker(paragraph).getType) {
        case ParagraphType.image:
          _widgets.add(StImage(paragraph));
          break;
        default:
          widget.commonSetting!.forEach((element) {
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
            _mainsettings.add(MainSetting(
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

          _widgets.add(_paragraph(paragraph.split(this._separator)));
      }
    });

    setState(() {});
  }

  Widget _paragraph(List<String> words) {
    List<InlineSpan> stSpans = [];
    List<TextStyle> styless = [];
    int key = 0;

    words.forEach((w) {
      if (w != "") {
        String globalKey = "St" + key.toString();
        key++;
        TextSpan span = TextSpan(text: w, style: widget.globalStyle);
        BracketType type = BracketType.none;

        _mainsettings.forEach((r) {
          if (w.contains(r.open) && w.contains(r.close)) {
            String word = w.replaceAll(r.open, "").replaceAll(r.close, "");
            type = BracketType.bracket;
            if (r.type == SettingType.common) {
              span = _mergeSpan(
                span,
                text: word,
                style: span.style!.merge(r.style),
                recognizer: r.recognizer,
              );
            } else if (r.type == SettingType.inlineCode) {
              print(r.type);
              print(word);

              span = TextSpan(
                children: [
                  WidgetSpan(
                      child: StInlineCode(
                    text: word,
                    codeConfiguration: this.widget.inlineCodeConfiguration,
                  ))
                ],
              );
            } else {
              if (r.type == SettingType.hyperlink) {
                var replacement = _hyperlinkReplacement(word);
                // print(replacement);
                word = replacement['word']!;
                span = _mergeSpan(span,
                    children: [
                      WidgetSpan(
                          child: GestureDetector(
                        onTap: () => _gestureHandler(replacement['url']!,
                            'onTap', Key(globalKey), r.type),
                        onDoubleTap: () => _gestureHandler(replacement['url']!,
                            'onDoubleTap', Key(globalKey), r.type),
                        onLongPress: () => _gestureHandler(replacement['url']!,
                            'onLongPress', Key(globalKey), r.type),
                        child: Text(
                          word,
                          key: Key(globalKey),
                          style: span.style!
                              .merge(this.widget.linkConfiguration.style),
                        ),
                      ))
                    ],
                    style: span.style,
                    text: "");
              } else
                span = _mergeSpan(span,
                    children: [
                      WidgetSpan(
                          child: GestureDetector(
                        onTap: () => _gestureHandler(
                            word, 'onTap', Key(globalKey), r.type),
                        onDoubleTap: () => _gestureHandler(
                            word, 'onDoubleTap', Key(globalKey), r.type),
                        onLongPress: () => _gestureHandler(
                            word, 'onLongPress', Key(globalKey), r.type),
                        child: Text(
                          word,
                          key: Key(globalKey),
                          style: span.style!.merge(r.type == SettingType.tag
                              ? this.widget.tagConfiguration.style
                              : r.type == SettingType.url
                                  ? this.widget.linkConfiguration.style
                                  : this.widget.emailConfiguration.style),
                        ),
                      ))
                    ],
                    style: span.style,
                    text: "");
            }
          } else if (w.contains(r.open)) {
            type = BracketType.open;

            span = _mergeSpan(
              span,
              text: w.replaceAll(r.open, ""),
              style: span.style!.merge(r.style),
              recognizer: r.recognizer,
            );
          } else if (w.contains(r.close)) {
            type = BracketType.close;

            span = _mergeSpan(
              span,
              text: w.replaceAll(r.close, ""),
              style: span.style!.merge(r.style),
              recognizer: r.recognizer,
            );
          }
        });

        if (type == BracketType.open) {
          if (styless.isNotEmpty) {
            styless.add(styless.last.merge(span.style));
          } else {
            styless.add(span.style!);
          }
          stSpans.add(_mergeSpan(span, style: styless.last));
        } else if (type == BracketType.close) {
          stSpans.add(_mergeSpan(span, style: styless.last.merge(span.style)));
          styless.removeLast();
        } else {
          stSpans.add(_mergeSpan(span,
              style: styless.isNotEmpty
                  ? styless.last.merge(span.style)
                  : span.style));
        }
      }
    });
    return LayoutBuilder(builder: (context, cs) {
      return Container(
        width: cs.maxWidth,
        child: RichText(
          text: TextSpan(children: stSpans),
          textAlign: this.widget.paragraphAlignment,
        ),
      );
    });
  }

  Map<String, String> _hyperlinkReplacement(String word) {
    String url = '';
    String newWord = word.replaceAllMapped(
        RegExp(r"\[(.*?)\]\((.*?)\)", caseSensitive: false, multiLine: true),
        (match) {
      url = match.group(2)!;
      return match.group(1)!;
    });

    return {'word': newWord, 'url': url};
  }

  void _gestureHandler(
      String word, String type, Key key, SettingType settingType) {
    switch (settingType) {
      case SettingType.tag:
        _gestureTag(word, type, key);
        break;
      case SettingType.url:
        _gestureUrl(word, type, key);
        break;
      case SettingType.email:
        _gestureEmail(word, type, key);
        break;
      case SettingType.hyperlink:
        _gestureUrl(word, type, key);
        break;
      default:
    }
  }

  void _gestureTag(String w, String type, Key key) {
    switch (type) {
      case 'onTap':
        if (this.widget.tagConfiguration.onTap != null)
          this.widget.tagConfiguration.onTap!(w, key);
        break;
      case 'onDoubleTap':
        if (this.widget.tagConfiguration.onDoubleTap != null)
          this.widget.tagConfiguration.onDoubleTap!(w, key);
        break;
      case 'onLongPress':
        if (this.widget.tagConfiguration.onLongPress != null)
          this.widget.tagConfiguration.onLongPress!(w, key);
        break;
      default:
    }
  }

  void _gestureUrl(String w, String type, Key key) {
    switch (type) {
      case 'onTap':
        if (this.widget.linkConfiguration.onTap != null)
          this.widget.linkConfiguration.onTap!(w, key);
        break;
      case 'onDoubleTap':
        if (this.widget.linkConfiguration.onDoubleTap != null)
          this.widget.linkConfiguration.onDoubleTap!(w, key);
        break;
      case 'onLongPress':
        if (this.widget.linkConfiguration.onLongPress != null)
          this.widget.linkConfiguration.onLongPress!(w, key);
        break;
      default:
    }
  }

  void _gestureEmail(String w, String type, Key key) {
    switch (type) {
      case 'onTap':
        if (this.widget.emailConfiguration.onTap != null)
          this.widget.emailConfiguration.onTap!(w, key);
        break;
      case 'onDoubleTap':
        if (this.widget.emailConfiguration.onDoubleTap != null)
          this.widget.emailConfiguration.onDoubleTap!(w, key);
        break;
      case 'onLongPress':
        if (this.widget.emailConfiguration.onLongPress != null)
          this.widget.emailConfiguration.onLongPress!(w, key);
        break;
      default:
    }
  }

  @override
  void didUpdateWidget(covariant StringTypography oldWidget) {
    _widgets = [];
    _process(widget.text);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    _widgets = [];
    _process(widget.text);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _widgets.map((e) => e).toList(),
    );
  }

  TextSpan _mergeSpan(
    TextSpan oldTS, {
    String? text,
    List<InlineSpan>? children,
    GestureRecognizer? recognizer,
    String? semanticsLabel,
    TextStyle? style,
  }) =>
      TextSpan(
          text: text ?? oldTS.text,
          children: children ?? oldTS.children,
          recognizer: recognizer ?? oldTS.recognizer,
          semanticsLabel: semanticsLabel ?? oldTS.semanticsLabel,
          style: style ?? oldTS.style);
}

enum BracketType { none, open, close, bracket }
enum StParentAlignment { start, center, end }
