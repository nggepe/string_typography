import 'package:flutter/material.dart';
import 'package:string_typography/src/configs/public/st_code_block.dart';

class StCodeBlock extends StatelessWidget {
  final StCodeBlockConfig configuration;
  final String text;
  const StCodeBlock({
    Key? key,
    required this.configuration,
    required this.text,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: configuration.decoration,
      child: RichText(
          text: TextSpan(
              children: [], text: this.text, style: configuration.textStyle)),
    );
  }
}
