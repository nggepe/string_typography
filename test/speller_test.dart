import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:string_typography/src/utils/paragraph_speller.dart';
import 'package:string_typography/string_typography.dart';

void main() async {
  test("counter check", () {
    final speller = ParagraphSpeller(
      codeBlockConfig: StCodeBlockConfig(),
      commonSetting: CommonSetting.defaultconfiguration,
      emailConfiguration: StConfig(style: TextStyle(color: Colors.blue)),
      globalStyle: TextStyle(),
      inlineCodeConfiguration:
          StConfig(style: TextStyle(color: Color(0xff333333))),
      linkConfiguration: StConfig(style: TextStyle(color: Colors.blue)),
      paragraphConfig: StParagraphConfig(),
      tagConfiguration: StConfig(style: TextStyle(color: Colors.blue)),
    );

    expect(speller.process("*bold*").length, 1);
    expect(
        speller
            .process(
                "*italic* <img src='https://avatars.githubusercontent.com/u/20833635?v=4' />")
            .length,
        2);

    expect(
        speller
            .process(
                "*italic* <img src='https://avatars.githubusercontent.com/u/20833635?v=4' /> ```function(){}```")
            .length,
        3);
  });
}
