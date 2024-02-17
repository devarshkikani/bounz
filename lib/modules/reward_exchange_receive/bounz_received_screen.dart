import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';

@RoutePage()
class BounzReceivedScreen extends StatefulWidget {
  final String? earned;
  const BounzReceivedScreen({Key? key, this.earned}) : super(key: key);

  @override
  _BounzReceivedScreenState createState() => _BounzReceivedScreenState();
}

class _BounzReceivedScreenState extends State<BounzReceivedScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: AppBackGroundWidget(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                MoenageManager.logScreenEvent(name: 'Main Home');
                AutoRouter.of(context).pushAndPopUntil(
                  MainHomeScreenRoute(),
                  predicate: (_) => false,
                );
              },
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(
              height: AppSizes.size30,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: AppSizes.size2),
                child: Text(
                  AppConstString.congratulations,
                  style: AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
                ),
              ),
            ),
            const SizedBox(
              height: AppSizes.size20,
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset(
                        AppAssets.rewardsReceived,
                        repeat: false,
                      ),
                      Lottie.asset(AppAssets.roundedCircleYellow),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppConstString.youReceived,
                            style: AppTextStyle.bold18.copyWith(
                              color: AppColors.blackColor,
                            ),
                          ),
                          const SizedBox(
                            height: AppSizes.size20,
                          ),
                          Text(
                            widget.earned ?? "",
                            style: AppTextStyle.bold72.copyWith(
                              fontFamily: "Bebas",
                              color: AppColors.blackColor,
                            ),
                          ),
                          const SizedBox(
                            height: AppSizes.size20,
                          ),
                          Image.asset(AppAssets.bounzBlack),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.size10,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        Text(
                          AppConstString.pointsCredited1,
                          style: AppTextStyle.semiBold14.copyWith(
                            color: AppColors.blackColor,
                          ),
                        ),
                        Text(
                          AppConstString.pointsCredited2,
                          style: AppTextStyle.semiBold14
                              .copyWith(color: AppColors.blackColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: AppSizes.size30,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: AppSizes.size30),
                child: PrimaryButton(
                  onTap: () {
                    MoenageManager.logScreenEvent(name: 'Partner Screen');
                    AutoRouter.of(context).pushAndPopUntil(
                        MainHomeScreenRoute(
                          index: 1,
                        ),
                        predicate: (_) => true);
                  },
                  showShadow: true,
                  text: AppConstString.done,
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
