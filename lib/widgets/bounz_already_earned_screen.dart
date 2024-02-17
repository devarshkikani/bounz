import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';

@RoutePage()
class BounzAlreadyEarned extends StatefulWidget {
  const BounzAlreadyEarned({Key? key}) : super(key: key);

  @override
  State<BounzAlreadyEarned> createState() => _BounzAlreadyEarnedState();
}

class _BounzAlreadyEarnedState extends State<BounzAlreadyEarned> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AppBackGroundWidget(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: AppSizes.size26,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size30,
                  ),
                  Text(
                    AppConstString.earnBounz.toUpperCase(),
                    style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
                  ),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  Text(
                    AppConstString.bounzAlreadyEarned,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bold16,
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.size60,
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      AppAssets.coinBox,
                      height: 120.0,
                      width: 150.0,
                    ),
                    const SizedBox(
                      height: AppSizes.size40,
                    ),
                    Text(
                      "Seems like you've already earned\nBOUNZ.",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bold16,
                    ),
                    const SizedBox(
                      height: AppSizes.size50,
                    ),
                    RoundedBorderButton(
                      bColor: AppColors.blackColor,
                      tColor: AppColors.blackColor,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      text: "Go Back",
                    ),
                    const SizedBox(
                      height: AppSizes.size12,
                    ),
                    PrimaryButton(
                      text: "Home",
                      onTap: () {
                        MoenageManager.logScreenEvent(name: 'Main Home');
                        AutoRouter.of(context).pushAndPopUntil(
                            MainHomeScreenRoute(index: 0),
                            predicate: (_) => false);
                      },
                    ),
                    const SizedBox(
                      height: AppSizes.size20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
