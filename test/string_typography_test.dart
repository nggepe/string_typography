import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
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

  testWidgets("Image test", (WidgetTester tester) async {
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

  testWidgets("Code block finder - material", (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: ListView(
          children: [
            StringTypography(
              text: "```\nhai\n```",
              key: Key("testWidget"),
            ),
          ],
        ),
      ),
    ));

    expect(
        find.byWidgetPredicate(
            (Widget widget) =>
                widget is RichText && widget.text.toPlainText() == "hai\n",
            skipOffstage: false),
        findsOneWidget);
  });
}
