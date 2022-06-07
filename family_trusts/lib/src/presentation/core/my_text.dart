import 'package:flutter/material.dart';

class MyText extends StatelessWidget {
  final String data;
  final TextAlign? alignment;
  final double? fontSize;
  final FontStyle? style;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxLines;

  const MyText(
    this.data, {
    this.alignment = TextAlign.center,
    this.fontSize,
    this.style,
    this.fontWeight,
    this.color,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    if (color != null) {
      themeData = themeData.copyWith(
        textTheme: themeData.textTheme.copyWith(
          bodyText1: themeData.textTheme.bodyText1!.copyWith(color: color),
        ),
      );
    }
    if (fontSize != null) {
      themeData = themeData.copyWith(
        textTheme: themeData.textTheme.copyWith(
          bodyText1: themeData.textTheme.bodyText1!.copyWith(fontSize: fontSize),
        ),
      );
    }

    if (style != null) {
      themeData = themeData.copyWith(
        textTheme: themeData.textTheme.copyWith(
          bodyText1: themeData.textTheme.bodyText1!.copyWith(fontStyle: style),
        ),
      );
    }

    if (fontWeight != null) {
      themeData = themeData.copyWith(
        textTheme: themeData.textTheme.copyWith(
          bodyText1: themeData.textTheme.bodyText1!.copyWith(fontWeight: fontWeight),
        ),
      );
    }

    return Theme(
      data: themeData,
      child: Text(
        data,
        textAlign: alignment,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: themeData.textTheme.bodyText1,
      ),
    );
  }
}
