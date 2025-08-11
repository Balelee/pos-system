import 'package:flutter/material.dart';
import 'package:pos/app/data/components/color/appcolor.dart';

enum ParagraphType { bodyText1, bodyText2 }

class ParagraphText extends StatelessWidget {
  final String text;
  final ParagraphType type;
  final Color color;
  final TextAlign textAlign;

  const ParagraphText({
    Key? key,
    required this.text,
    this.type = ParagraphType.bodyText1,
    this.color = AppColor.bodyText1Color,
    this.textAlign = TextAlign.start,
  }) : super(key: key);

  TextStyle _getTextStyle() {
    switch (type) {
      case ParagraphType.bodyText1:
        return TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: color,
        );
      case ParagraphType.bodyText2:
        return TextStyle(
          fontSize: 14,
          color: color,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _getTextStyle(),
      textAlign: textAlign,
    );
  }
}
