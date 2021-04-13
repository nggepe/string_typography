import 'package:flutter/material.dart';
import 'package:string_typography/src/configs/public/st_inline_code.dart';

class StInlineCode extends StatelessWidget {
  final String text;
  final StInlineCodeConfig codeConfiguration;
  const StInlineCode({
    Key? key,
    required this.text,
    required this.codeConfiguration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: this.codeConfiguration.padding,
      decoration: BoxDecoration(
          color: this.codeConfiguration.backgroundColor,
          borderRadius:
              BorderRadius.circular(this.codeConfiguration.boxRadius)),
      child: Text(
        this.text,
        style: this.codeConfiguration.style,
      ),
    );
  }
}
