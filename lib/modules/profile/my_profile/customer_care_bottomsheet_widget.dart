import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

customerCareBottomsheet(
  BuildContext context,
  String contactNum,
) {
  return showModalBottomSheet(
      backgroundColor: AppColors.secondaryContainerColor,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return SizedBox(
            height: 210,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        AppConstString.selectNumber,
                        style: AppTextStyle.bold16.copyWith(
                          color: AppColors.darkBlueTextColor,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  GestureDetector(
                    onTap: () async {
                      final Uri url = Uri(
                        scheme: 'tel',
                        path: contactNum,
                      );
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      }
                    },
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.call,
                        ),
                        const SizedBox(
                          width: AppSizes.size10,
                        ),
                        Text(
                          "Call\t" + contactNum,
                          style: AppTextStyle.regular14.copyWith(
                            color: AppColors.darkBlueTextColor,
                            letterSpacing: -.28,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      PrimaryButton(
                        showShadow: true,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        text: AppConstString.cancel,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
      });
}
