import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';

@RoutePage()
class NoDataFoundScreen extends StatefulWidget {
  const NoDataFoundScreen({Key? key}) : super(key: key);
  @override
  State<NoDataFoundScreen> createState() => _NoDataFoundScreenState();
}

class _NoDataFoundScreenState extends State<NoDataFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AppBackGroundWidget(
        padding: EdgeInsets.zero,
        child: Container(
          color: Colors.grey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: AppSizes.size58,
              ),
              Image.asset(
                AppAssets.noDataFound,
              ),
              const SizedBox(
                height: AppSizes.size40,
              ),
              Text(
                AppConstString.oopsItsNotYou,
                style: AppTextStyle.bold30
                    .copyWith(fontFamily: "Bebas", color: AppColors.blackColor),
              ),
              const SizedBox(
                height: AppSizes.size50,
              ),
              contactSupportBtnWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget contactSupportBtnWidget() {
    return PrimaryButton(
      text: AppConstString.cntSupport,
      onTap: () {},
    );
  }
}
