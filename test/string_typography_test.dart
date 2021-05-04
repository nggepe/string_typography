import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:string_typography/src/utils/paragraph_speller.dart';
import 'package:string_typography/string_typography.dart';

void main() {
  testWidgets("key-test, material", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: StringTypography(
        text: "Hello world!",
        key: Key("testWidget"),
      ),
    ));
    final textFinder = find.byKey(Key("testWidget"));

    expect(textFinder, findsOneWidget);
  });

  testWidgets("key-test, cupertino", (WidgetTester tester) async {
    await tester.pumpWidget(CupertinoApp(
      home: StringTypography(
        text: "Hello world!",
        key: Key("testWidget"),
      ),
    ));
    final textFinder = find.byKey(Key("testWidget"));

    expect(textFinder, findsOneWidget);
  });

  testWidgets("Text finder", (WidgetTester tester) async {
    await tester.pumpWidget(CupertinoApp(
      home: StringTypography(
        text: "Hello world!",
        key: Key("testWidget"),
      ),
    ));

    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is RichText && widget.text.toPlainText() == 'Hello world!'),
        findsOneWidget);
  });

  testWidgets("Image finder", (WidgetTester tester) async {
    await mockNetworkImages(() async {
      await tester.pumpWidget(CupertinoApp(
        home: StringTypography(
          text:
              "<img src='https://avatars.githubusercontent.com/u/20833635?v=4' />",
          key: Key("testWidget"),
        ),
      ));

      expect(find.byType(Image, skipOffstage: false), findsOneWidget);
    });
  });

  test("speller counter check", () {
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
    var single = speller.process("*bold*");
    expect(single.length, 1);
    var dbl = speller.process(
        "*italic* <img src='https://avatars.githubusercontent.com/u/20833635?v=4' />");
    expect(dbl.length, 2);

    var trpl = speller.process(
        "*italic* <img src='https://avatars.githubusercontent.com/u/20833635?v=4' /> ```function(){}```");
    expect(trpl.length, 3);
  });
}
