import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';

class RoundedBorderButton extends StatelessWidget {
  final String? text;
  final Color? tColor, bColor, bgColor;
  final Function()? onTap;
  final double? height, width, borderRadius;

  const RoundedBorderButton({
    Key? key,
    required this.text,
    this.tColor,
    this.bColor,
    this.bgColor,
    this.height,
    this.width,
    this.borderRadius,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: height ?? AppSizes.size60,
        width: width ?? MediaQuery.of(context).size.width * .5,
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(width: 1, color: bColor ?? Colors.white),
          borderRadius: BorderRadius.circular(borderRadius ?? AppSizes.size30),
        ),
        child: Text(
          text!,
          style: AppTextStyle.bold14.copyWith(
            color: tColor,
          ),
        ),
      ),
    );
  }
}
