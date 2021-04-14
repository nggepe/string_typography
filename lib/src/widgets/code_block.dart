import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:string_typography/src/configs/public/st_code_block.dart';
import 'package:string_typography/src/widgets/code_highlight.dart';

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
    String cbtext = this
        .text
        .replaceAll(
            RegExp(r"^(```\n)",
                dotAll: true, caseSensitive: false, multiLine: true),
            "")
        .replaceAll(
            RegExp(r"^(```)",
                dotAll: true, caseSensitive: false, multiLine: true),
            "");
    return LayoutBuilder(builder: (context, cs) {
      return Container(
        width: cs.maxWidth,
        decoration: BoxDecoration(color: Color(0XFF222222)),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (configuration.copyClipboard)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0XFF222222),
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(new ClipboardData(text: cbtext));
                      },
                      splashColor: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: 20,
                        width: 20,
                        child: Center(
                          child: Icon(
                            Icons.copy,
                            size: 18,
                            color: Color(0XFFF2F2F2),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            Scrollbar(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: StCodeHighLight(cbtext),
              ),
            ),
          ],
        ),
      );
    });
  }
}
