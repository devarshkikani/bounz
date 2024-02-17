import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OffersContainerWidget extends StatelessWidget {
  final String btnText, headingTxt, subTitleTxt, iconName, title;
  final Color btnTxtColor, btnBgColor;
  final Function()? onTap;
  final double? btnHeight, btnWidth;
  const OffersContainerWidget({
    Key? key,
    required this.btnText,
    required this.headingTxt,
    required this.subTitleTxt,
    required this.btnTxtColor,
    required this.btnBgColor,
    required this.iconName,
    required this.title,
    this.onTap,
    this.btnHeight,
    this.btnWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 200,
      padding: const EdgeInsets.all(AppSizes.size10),
      decoration: BoxDecoration(
        color: AppColors.collectBgColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Align(
            alignment: Alignment.topRight,
            child: SvgPicture.network(
              iconName,
              height: AppSizes.size58,
            ),
          ),
          const Spacer(),
          Text(
            headingTxt.toUpperCase(),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.regular14.copyWith(
              fontSize: 13,
              color: AppColors.darkBlueTextColor,
            ),
          ),
          const SizedBox(
            height: 2,
          ),
          Text(
            subTitleTxt,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.bold10.copyWith(
              color: AppColors.darkBlueTextColor,
            ),
          ),
          const SizedBox(
            height: AppSizes.size10,
          ),
          PrimaryButton(
            height: MediaQuery.of(context).size.height / 26.5,
            text: btnText,
            onTap: onTap,
            bColor: btnBgColor,
            tColor: btnTxtColor,
            textStyle: AppTextStyle.bold10,
          ),
        ],
      ),
    );
  }
}
