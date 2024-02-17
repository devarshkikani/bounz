import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';

class OtpInput extends StatelessWidget {
  final TextEditingController controller;
  final int index;
  final int otpLength;
  final bool showLine;

  const OtpInput({
    Key? key,
    required this.controller,
    required this.index,
    required this.otpLength,
    this.showLine = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              autofocus: index == 0,
              maxLength: 1,
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              cursorColor: AppColors.whiteColor,
              style:
                  AppTextStyle.regular16.copyWith(color: AppColors.whiteColor),
              decoration: InputDecoration(
                  contentPadding: const EdgeInsets.all(12),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    borderSide: BorderSide.none,
                  ),
                  counterText: ''),
              onChanged: (value) {
                if (value.length == 1) {
                  if (index == 4) {
                    FocusScope.of(context).unfocus();
                  } else {
                    FocusScope.of(context).nextFocus();
                  }
                } else {
                  if (index != 0) {
                    FocusScope.of(context).previousFocus();
                  }
                }
              },
            ),
          ),
          if (showLine)
            Container(
              width: 1,
              height: AppSizes.size20,
              color: AppColors.whiteColor.withOpacity(0.2),
            ),
        ],
      ),
    );
  }
}
