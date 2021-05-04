import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:string_typography/string_typography.dart';

void main() async {
  testWidgets("Text finder - cupertino", (WidgetTester tester) async {
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

  testWidgets("Text finder - material", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
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

  testWidgets("Bold & italic & underline finder - cupertino",
      (WidgetTester tester) async {
    await tester.pumpWidget(CupertinoApp(
      home: Scaffold(
        body: ListView(
          children: [
            StringTypography(
              text: "**Hello world!** _underline_ *italic*",
              key: Key("testWidget"),
            ),
          ],
        ),
      ),
    ));

    expect(
        find.byWidgetPredicate(
            (Widget widget) =>
                widget is RichText &&
                widget.text.toPlainText() == 'Hello world! underline italic',
            skipOffstage: false),
        findsOneWidget);
  });

  testWidgets("Bold & italic & underline finder - material",
      (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            StringTypography(
              text: "**Hello world!** _underline_ *italic*",
              key: Key("testWidget"),
            ),
          ],
        ),
      ),
    ));

    expect(
        find.byWidgetPredicate(
            (Widget widget) =>
                widget is RichText &&
                widget.text.toPlainText() == 'Hello world! underline italic',
            skipOffstage: false),
        findsOneWidget);
  });

  testWidgets("Tag finder - cupertino", (WidgetTester tester) async {
    await tester.pumpWidget(CupertinoApp(
      home: Scaffold(
        body: ListView(
          children: [
            StringTypography(
              text: "#hashtag @atTag",
              key: Key("testWidget"),
            ),
          ],
        ),
      ),
    ));

    expect(
        find.byWidgetPredicate(
            (Widget widget) =>
                widget is RichText &&
                widget.text.toPlainText() == '#hashtag @atTag',
            skipOffstage: false),
        findsOneWidget);
  });

  testWidgets("Tag finder - material", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            StringTypography(
              text: "#hashtag @atTag",
              key: Key("testWidget"),
            ),
          ],
        ),
      ),
    ));

    expect(
        find.byWidgetPredicate(
            (Widget widget) =>
                widget is RichText &&
                widget.text.toPlainText() == '#hashtag @atTag',
            skipOffstage: false),
        findsOneWidget);
  });

  testWidgets("Url finder - material", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            StringTypography(
              text:
                  "https://www.youtube.com/watch?v=KpP5SNQYozk&t=730s&ab_channel=DeddyCorbuzier",
              key: Key("testWidget"),
            ),
          ],
        ),
      ),
    ));

    expect(
        find.byWidgetPredicate(
            (Widget widget) =>
                widget is RichText &&
                widget.text.toPlainText() ==
                    'https://www.youtube.com/watch?v=KpP5SNQYozk&t=730s&ab_channel=DeddyCorbuzier',
            skipOffstage: false),
        findsOneWidget);
  });

  testWidgets("hyperlink finder - material", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            StringTypography(
              text:
                  "[youtube](https://www.youtube.com/watch?v=KpP5SNQYozk&t=730s&ab_channel=DeddyCorbuzier)",
              key: Key("testWidget"),
            ),
          ],
        ),
      ),
    ));

    expect(
        find.byWidgetPredicate(
            (Widget widget) =>
                widget is RichText && widget.text.toPlainText() == 'youtube',
            skipOffstage: false),
        findsOneWidget);
  });
}
