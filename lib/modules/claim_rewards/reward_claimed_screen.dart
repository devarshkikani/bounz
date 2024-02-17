import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/modules/claim_rewards/view_details_screen.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

@RoutePage()
class RewardClaimedScreen extends StatefulWidget {
  final String? title;
  final num earnPoints;
  final int pageIndex;
  final Map? fixedValueData;
  const RewardClaimedScreen(
      {Key? key,
      this.title,
      required this.earnPoints,
      required this.pageIndex,
      this.fixedValueData})
      : super(key: key);

  @override
  _RewardClaimedScreenState createState() => _RewardClaimedScreenState();
}

class _RewardClaimedScreenState extends State<RewardClaimedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // GestureDetector(
                //   onTap: () {
                //     Navigator.of(context).pop();
                //   },
                //   child: const Icon(
                //     Icons.arrow_back,
                //     color: AppColors.whiteColor,
                //   ),
                // ),
                const SizedBox(
                  height: AppSizes.size30,
                ),
                Text(
                  widget.title ?? AppConstString.claimRewards,
                  style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
                ),
              ],
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      //Need new Json file for rewardsReceived,
                      //There is lag if we use current json file
                      Lottie.asset(
                        AppAssets.rewardsReceived,
                        repeat: false,
                      ),
                      Lottie.asset(AppAssets.roundedCircleYellow),
                      ScaleTransition(
                        scale: _animation,
                        child: Column(
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
                              widget.earnPoints.toString(),
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
            doneButtonWidget()
          ],
        ),
      ),
    );
  }

  doneButtonWidget() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.size30),
        child: PrimaryButton(
          bColor: AppColors.backgroundColor,
          tColor: AppColors.whiteColor,
          text: widget.fixedValueData?['product_type'] ==
                  "FIXED_VALUE_PIN_PURCHASE"
              ? AppConstString.viewDetails
              : AppConstString.done,
          onTap: () {
            // int points = GlobalSingleton.userInformation.pointBalance!;
            // points += widget.earnPoints;
            // GlobalSingleton.userInformation.pointBalance = points;
            // final String encodeData =
            //     jsonEncode(GlobalSingleton.userInformation.toJson());
            // StorageManager.setStringValue(
            // key: AppStorageKey.userInformation, value: encodeData);
            if (widget.pageIndex == 4) {
              if (widget.title == null) {
                MoenageManager.logScreenEvent(name: 'My Account');
                AutoRouter.of(context).pushAndPopUntil(
                    MainHomeScreenRoute(index: widget.pageIndex),
                    predicate: (_) => false);
              } else {
                MoenageManager.logScreenEvent(name: 'Purchased History');
                AutoRouter.of(context)
                    .replaceNamed('/purchased_history_screen/true');
              }
            } else {
              if (widget.fixedValueData?['product_type'] ==
                  "FIXED_VALUE_PIN_PURCHASE") {
                MoenageManager.logScreenEvent(name: 'Pay Bills');
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ViewDetailsScreen(
                              fixedValueData: widget.fixedValueData ?? {},
                              fromRecentTrasaction: false,
                            )));
              } else {
                MoenageManager.logScreenEvent(name: 'Pay Bills');
                AutoRouter.of(context).pushAndPopUntil(
                    MainHomeScreenRoute(index: widget.pageIndex),
                    predicate: (_) => false);
              }
            }
          },
        ),
      ),
    );
  }
}
