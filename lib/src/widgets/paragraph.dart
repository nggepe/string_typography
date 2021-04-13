import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:string_typography/src/configs/private/main_setting.dart';
import 'package:string_typography/src/widgets/inline_code.dart';
import 'package:string_typography/string_typography.dart';

class StParagraph extends StatelessWidget {
  final List<String> words;
  final TextStyle? globalStyle;
  final List<MainSetting> mainsettings;

  ///This parameter is to setUp your tag style and some gesture event. **What tags which provided?** for now,
  ///we just provide @ and #, feel free to discuss it on github issue.
  final StConfig tagConfiguration;

  ///url or hyperlink setup is here. Styling or gesture event.
  final StConfig linkConfiguration;

  ///email setup is here. Styling or gesture event.
  final StConfig emailConfiguration;

  ///the text alignment for paragraph (`text`).
  final TextAlign paragraphAlignment;

  ///[inlinCodeConfiguration] is, like `this` <--- is inline code.
  ///it needs styling. We create any arguments on it for you, so you can customiza it.
  final StInlineCodeConfig inlineCodeConfiguration;

  const StParagraph(this.words,
      {Key? key,
      required this.globalStyle,
      required this.mainsettings,
      required this.emailConfiguration,
      required this.inlineCodeConfiguration,
      required this.linkConfiguration,
      required this.paragraphAlignment,
      required this.tagConfiguration})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    List<InlineSpan> stSpans = [];
    List<TextStyle> styless = [];
    int key = 0;

    words.forEach((w) {
      if (w != "") {
        String globalKey = "St" + key.toString();
        key++;
        TextSpan span = TextSpan(text: w, style: this.globalStyle);
        BracketType type = BracketType.none;

        this.mainsettings.forEach((r) {
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
              span = TextSpan(
                children: [
                  WidgetSpan(
                      child: StInlineCode(
                    text: word,
                    codeConfiguration: this.inlineCodeConfiguration,
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
                          style:
                              span.style!.merge(this.linkConfiguration.style),
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
                              ? this.tagConfiguration.style
                              : r.type == SettingType.url
                                  ? this.linkConfiguration.style
                                  : this.emailConfiguration.style),
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
          textAlign: this.paragraphAlignment,
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

  void _gestureTag(String w, String type, Key key) {
    switch (type) {
      case 'onTap':
        if (this.tagConfiguration.onTap != null)
          this.tagConfiguration.onTap!(w, key);
        break;
      case 'onDoubleTap':
        if (this.tagConfiguration.onDoubleTap != null)
          this.tagConfiguration.onDoubleTap!(w, key);
        break;
      case 'onLongPress':
        if (this.tagConfiguration.onLongPress != null)
          this.tagConfiguration.onLongPress!(w, key);
        break;
      default:
    }
  }

  void _gestureUrl(String w, String type, Key key) {
    switch (type) {
      case 'onTap':
        if (this.linkConfiguration.onTap != null)
          this.linkConfiguration.onTap!(w, key);
        break;
      case 'onDoubleTap':
        if (this.linkConfiguration.onDoubleTap != null)
          this.linkConfiguration.onDoubleTap!(w, key);
        break;
      case 'onLongPress':
        if (this.linkConfiguration.onLongPress != null)
          this.linkConfiguration.onLongPress!(w, key);
        break;
      default:
    }
  }

  void _gestureEmail(String w, String type, Key key) {
    switch (type) {
      case 'onTap':
        if (this.emailConfiguration.onTap != null)
          this.emailConfiguration.onTap!(w, key);
        break;
      case 'onDoubleTap':
        if (this.emailConfiguration.onDoubleTap != null)
          this.emailConfiguration.onDoubleTap!(w, key);
        break;
      case 'onLongPress':
        if (this.emailConfiguration.onLongPress != null)
          this.emailConfiguration.onLongPress!(w, key);
        break;
      default:
    }
  }
}

enum BracketType { none, open, close, bracket }
