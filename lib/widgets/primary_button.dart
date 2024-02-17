import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';

class PrimaryButton extends StatelessWidget {
  final String? text;
  final bool showShadow;
  final Function()? onTap;
  final Color? tColor, bColor;
  final TextStyle? textStyle;
  final double? height, width, borderRadius;

  const PrimaryButton({
    Key? key,
    required this.text,
    this.tColor,
    this.bColor,
    this.height,
    this.width,
    this.textStyle,
    this.showShadow = false,
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
          color: onTap != null
              ? bColor ?? AppColors.btnBlueColor
              : AppColors.btnBlueColor.withOpacity(0.32),
          borderRadius: BorderRadius.circular(borderRadius ?? AppSizes.size30),
          boxShadow: showShadow
              ? <BoxShadow>[
                  const BoxShadow(
                    color: AppColors.brownishColor,
                    blurRadius: 60,
                    offset: Offset(20, 20),
                  ),
                ]
              : [],
        ),
        child: Text(
          text!,
          style: textStyle ??
              AppTextStyle.bold14.copyWith(
                color: onTap != null ? tColor : tColor?.withOpacity(0.32),
              ),
        ),
      ),
    );
  }
}
