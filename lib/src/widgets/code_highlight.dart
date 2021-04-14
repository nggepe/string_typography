import 'package:flutter/material.dart';
import 'package:string_typography/src/configs/private/main_setting.dart';
import 'package:string_typography/src/configs/public/st_code_block.dart';

class StCodeHighLight extends StatelessWidget {
  final String text;
  const StCodeHighLight(
    this.text, {
    Key? key,
    CodeBlockTheme theme: CodeBlockTheme.dark,
  }) : super(key: key);

  final String _cmtSeparator = "™»cmnt«™";
  final String _strSeparator = "™»str«™";
  final String _cmnSeparator = "™»mmmm«™";

  List<InlineSpan> _process() {
    List<InlineSpan> spans = [];

    String sentences = this.text.replaceAllMapped(
        _HighlightSetting.comment.regExp,
        (match) => this._cmtSeparator + match.group(0)! + this._cmtSeparator);
    sentences.split(this._cmtSeparator).forEach((cmt) {
      if (cmt != "") {
        if (_HighlightSetting.comment.regExp.hasMatch(cmt)) {
          spans.add(TextSpan(
            text: cmt,
            style: TextStyle(color: _HighlightSetting.comment.color),
          ));
        } else {
          String str = cmt.replaceAllMapped(
              _HighlightSetting.string.regExp,
              (match) =>
                  this._strSeparator + match.group(0)! + this._strSeparator);

          str.split(this._strSeparator).forEach((words) {
            if (words != "") {
              if (_HighlightSetting.string.regExp.hasMatch(words))
                spans.add(TextSpan(
                  text: words,
                  style: TextStyle(color: Color(0XFF6DB87E)),
                ));
              else {
                spans.addAll(_createSpans(words));
              }
            }
          });
        }
      }
    });

    return spans;
  }

  List<TextSpan> _createSpans(String words) {
    List<MainSetting> settings = [];
    List<TextSpan> spans = [];

    int i = 0;
    _HighlightSetting.list.forEach((element) {
      TextStyle style = TextStyle();
      String open = "™»${i.toString()}O«™";
      words = words.replaceAllMapped(element.regExp, (match) {
        style = style.copyWith(color: element.color);
        return this._cmnSeparator + open + match.group(0)! + this._cmnSeparator;
      });

      settings.add(MainSetting(open: open, close: open, style: style));
      i++;
    });

    words.split(this._cmnSeparator).forEach((word) {
      if (word != "") {
        TextStyle style = TextStyle(color: Color(0XFFAAB3BE));
        settings.forEach((cmn) {
          print("detected");
          if (word.contains(cmn.open)) {
            word = word.replaceAll(cmn.open, "");
            style = cmn.style!;
          }
        });

        spans.add(TextSpan(text: word, style: style));
      }
    });

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    return RichText(text: TextSpan(children: _process()));
  }
}

class _HighlightSetting {
  final RegExp regExp;
  final Color color;
  _HighlightSetting({
    required this.regExp,
    required this.color,
  });

  static List<_HighlightSetting> list = [
    _HighlightSetting(regExp: RegExp(r"(\w+)\("), color: Color(0XFF40AAE7)),
    _HighlightSetting(
        regExp: RegExp(r"(\(|\)|\[\]|\{|\})"), color: Color(0XFFF2F2F2)),
    _HighlightSetting(
        regExp: RegExp(
            r"(function|const|var|let|class|final|\$\w+|def|import|covariant)"),
        color: Color(0XFFBC7CD9)),
    _HighlightSetting(
        regExp: RegExp(r"([0-9A-Fa-f]{6})"), color: Color(0XFFBA9358)),
    _HighlightSetting(
        regExp: RegExp("true|false", caseSensitive: false, unicode: true),
        color: Color(0XFFBA9358)),
    _HighlightSetting(
        regExp: RegExp(
            "this|return|switch|case|break|super|assert|while|for|if|else",
            caseSensitive: false,
            unicode: true),
        color: Color(0XFFCF6B75)),
    _HighlightSetting(
        regExp: RegExp(r"(\|\||\:|\;|\*|\+|\=)", caseSensitive: false),
        color: Color(0XFFDD73D2)),
    _HighlightSetting(regExp: RegExp(r"([A-Z]\w+)"), color: Color(0XFFEBBE7B)),
  ];

  static _HighlightSetting comment = _HighlightSetting(
      regExp: RegExp(
          r"(\/\/\/(.*?)\n|\/\*(.*?)\*\/)|\/\/(.*?)\n|<\!--(.*?)-->|# (.*?)\n",
          dotAll: true,
          multiLine: true),
      color: Color(0XFF56686C));

  static _HighlightSetting string = _HighlightSetting(
      regExp: RegExp("(\"(.*?)\"|\'(.*?)\')", dotAll: true, multiLine: true),
      color: Color(0XFF6DB87E));
}
