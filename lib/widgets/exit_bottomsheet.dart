import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future exitBottomSheet(BuildContext buildContext) {
  return showModalBottomSheet(
    backgroundColor: AppColors.secondaryContainerColor,
    context: buildContext,
    isDismissible: false,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          top: AppSizes.size20,
          right: AppSizes.size20,
          left: AppSizes.size20,
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SizedBox(
          height: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Exit App',
                style: AppTextStyle.bold16
                    .copyWith(color: AppColors.darkBlueTextColor),
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              Text(
                'Are you sure you want to exit?',
                style: AppTextStyle.semiBold14
                    .copyWith(color: AppColors.darkBlueTextColor),
              ),
              const SizedBox(
                height: AppSizes.size30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RoundedBorderButton(
                      height: AppSizes.size60,
                      onTap: () {
                        SystemNavigator.pop();
                      },
                      bColor: AppColors.btnBlueColor,
                      tColor: AppColors.btnBlueColor,
                      text: AppConstString.yes,
                    ),
                  ),
                  const SizedBox(
                    width: AppSizes.size10,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      height: AppSizes.size60,
                      text: AppConstString.no,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      );
    },
  );
}
