import 'package:flutter/cupertino.dart';

class StParagraphConfig {
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final bool selectable;
  const StParagraphConfig(
      {this.textAlign: TextAlign.start,
      this.textDirection,
      this.selectable: false});
}
