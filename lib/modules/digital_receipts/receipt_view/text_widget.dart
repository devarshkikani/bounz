import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final double? size;
  final double? textScaleFactor;
  final Color? color;
  final FontWeight? weight;
  final bool? softwrap;
  final TextAlign? alignment;
  final TextDecoration? decoration;
  final TextAlign? textAlign;
  final dynamic fontfamily;
  final dynamic letterSpacing;
  final dynamic overflow;
  final dynamic maxLines;
  final dynamic toUpperCase;
  final dynamic foreground;
  final dynamic style;
  final double? textScalFactor;

  const TextWidget(
      {Key? key,
      required this.text,
      this.size,
      this.color,
      this.weight,
      this.softwrap,
      this.alignment,
      this.decoration,
      this.letterSpacing,
      this.textAlign,
      this.overflow,
      this.maxLines,
      this.toUpperCase,
      this.fontfamily,
      this.foreground,
      this.style,
      this.textScalFactor,
      this.textScaleFactor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(
      toUpperCase == true ? text.toUpperCase() : text,
      softWrap: softwrap,
      textAlign: alignment,
      overflow: overflow,
      maxLines: maxLines,
      textScaleFactor: textScalFactor ?? 1.0,
      style: TextStyle(
          fontSize: size ?? AppSizes.size12,
          decoration: decoration,
          color: color,
          fontWeight: weight,
          fontFamily: 'Sans_Pro',
          foreground: foreground,
          letterSpacing: letterSpacing,
          fontStyle: style),
    );
  }
}
