import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:string_typography/src/configs/private/main_setting.dart';
import 'package:string_typography/src/configs/public/st_paragraph.dart';
import 'package:string_typography/src/utils/debounce.dart';

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

  final StParagraphConfig paragraphConfig;

  ///[inlinCodeConfiguration] is, like `this` <--- is inline code.
  ///it needs styling. We create any arguments on it for you, so you can customiza it.
  final StConfig inlineCodeConfiguration;

  StParagraph(this.words,
      {Key? key,
      required this.globalStyle,
      required this.mainsettings,
      required this.emailConfiguration,
      required this.inlineCodeConfiguration,
      required this.linkConfiguration,
      required this.paragraphConfig,
      required this.tagConfiguration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<TextSpan> stSpans = [];
    List<TextStyle> styless = [];
    final DebounceTap _debounceTap = DebounceTap((tt, st, w, local, global) {
      print(w);
      print(st);
      switch (st) {
        case SettingType.email:
          _gestureEmail(w, tt, local, global);
          break;
        case SettingType.url:
          _gestureUrl(w, tt, local, global);
          break;
        case SettingType.inlineCode:
          _gestureInlineCode(w, tt, local, global);
          break;
        case SettingType.tag:
          _gestureTag(w, tt, local, global);
          break;
        default:
      }
    });

    GestureRecognizer _recognizer(String word, SettingType settingType) {
      return TapGestureRecognizer()
        ..onTapDown = (details) {
          _debounceTap.tapDown(settingType, word, details);
        }
        ..onTapUp = (details) {
          _debounceTap.tapUp(settingType, word, details);
        };
    }

    words.forEach((w) {
      if (w != "") {
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
              span = _mergeSpan(span,
                  text: " " + word + " ",
                  style: this.inlineCodeConfiguration.style,
                  recognizer: _recognizer(word, SettingType.inlineCode));
            } else {
              if (r.type == SettingType.hyperlink) {
                var replacement = _hyperlinkReplacement(word);
                word = replacement['word']!;
                print(replacement);
                print("disini ");
                span = _mergeSpan(span,
                    style: span.style!.merge(this.linkConfiguration.style),
                    text: word,
                    recognizer:
                        _recognizer(replacement['url']!, SettingType.url));
              } else
                span = _mergeSpan(span,
                    text: word,
                    style: span.style!.merge(r.type == SettingType.tag
                        ? this.tagConfiguration.style
                        : r.type == SettingType.url
                            ? this.linkConfiguration.style
                            : this.emailConfiguration.style),
                    recognizer: _recognizer(word, r.type));
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
        child: this.paragraphConfig.selectable
            ? SelectableText.rich(
                TextSpan(children: stSpans),
                textAlign: this.paragraphConfig.textAlign,
                textDirection: this.paragraphConfig.textDirection,
              )
            : RichText(
                text: TextSpan(children: stSpans),
                textAlign: this.paragraphConfig.textAlign,
                textDirection: this.paragraphConfig.textDirection,
              ),
      );
    });
  }

  void _gestureTag(
      String w, TapType type, Offset localPosition, Offset globalPosition) {
    switch (type) {
      case TapType.tap:
        if (this.tagConfiguration.onTap != null)
          this.tagConfiguration.onTap!(w, localPosition, globalPosition);
        break;

      case TapType.longTap:
        if (this.tagConfiguration.onLongPress != null)
          this.tagConfiguration.onLongPress!(w, localPosition, globalPosition);
        break;
      default:
    }
  }

  void _gestureUrl(
      String w, TapType type, Offset localPosition, Offset globalPosition) {
    switch (type) {
      case TapType.tap:
        if (this.linkConfiguration.onTap != null)
          this.linkConfiguration.onTap!(w, localPosition, globalPosition);
        break;

      case TapType.longTap:
        if (this.linkConfiguration.onLongPress != null)
          this.linkConfiguration.onLongPress!(w, localPosition, globalPosition);
        break;
      default:
    }
  }

  void _gestureEmail(
      String w, TapType type, Offset localPosition, Offset globalPosition) {
    switch (type) {
      case TapType.tap:
        if (this.emailConfiguration.onTap != null)
          this.emailConfiguration.onTap!(w, localPosition, globalPosition);
        break;

      case TapType.longTap:
        if (this.emailConfiguration.onLongPress != null)
          this.emailConfiguration.onLongPress!(
              w, localPosition, globalPosition);
        break;
      default:
    }
  }

  void _gestureInlineCode(
      String w, TapType type, Offset localPosition, Offset globalPosition) {
    switch (type) {
      case TapType.tap:
        if (this.inlineCodeConfiguration.onTap != null)
          this.inlineCodeConfiguration.onTap!(w, localPosition, globalPosition);
        break;

      case TapType.longTap:
        if (this.inlineCodeConfiguration.onLongPress != null)
          this.inlineCodeConfiguration.onLongPress!(
              w, localPosition, globalPosition);
        break;
      default:
    }
  }
}

enum BracketType { none, open, close, bracket }

Map<String, String> _hyperlinkReplacement(String word) {
  String url = '';
  String newWord = word.replaceAllMapped(
      RegExp(r"\[(.*?)\]\((.*?)\)",
          multiLine: true, dotAll: true, unicode: true), (match) {
    url = match.group(2)!;
    return match.group(1)!;
  });

  return {'word': newWord, 'url': url};
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
