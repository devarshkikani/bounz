import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';

@RoutePage()
class UserFarFromStoreScreen extends StatefulWidget {
  final bool? isOffers;
  final String title;
  const UserFarFromStoreScreen({Key? key, this.isOffers, required this.title})
      : super(key: key);

  @override
  State<UserFarFromStoreScreen> createState() => _UserFarFromStoreScreenState();
}

class _UserFarFromStoreScreenState extends State<UserFarFromStoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AppBackGroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.whiteColor,
                ),
              ),
            ),
            const SizedBox(
              height: AppSizes.size30,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.isOffers == true
                    ? AppConstString.redeemOffer
                    : widget.title,
                style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
              ),
            ),
            const SizedBox(
              height: AppSizes.size30,
            ),
            const Spacer(),
            Image.asset(
              AppAssets.outOfRange,
              height: 200,
            ),
            const SizedBox(
              height: AppSizes.size20,
            ),
            Text(
              widget.isOffers == true
                  ? "You should be in 100 Meter radius of\nstore location to Redeem Offer"
                  : AppConstString.storeLocationError,
              textAlign: TextAlign.center,
              style: AppTextStyle.bold16,
            ),
            const SizedBox(
              height: AppSizes.size44,
            ),
            const Spacer(),
            RoundedBorderButton(
              tColor: AppColors.blackColor,
              bColor: AppColors.blackColor,
              onTap: () {
                Navigator.of(context).pop();
              },
              text: AppConstString.goBack,
            ),
            const SizedBox(
              height: AppSizes.size12,
            ),
            PrimaryButton(
              tColor: AppColors.whiteColor,
              bColor: AppColors.btnBlueColor,
              onTap: () {
                var moEProperties = MoEProperties();
                moEProperties
                    .addAttribute(TriggeringCondition.screenName,
                        'BounzAlreadyEarned Screen')
                    .setNonInteractiveEvent();
                MoenageManager.logEvent(MoenageEvent.screenView,
                    properties: moEProperties);

                AutoRouter.of(context).pushAndPopUntil(
                    MainHomeScreenRoute(index: widget.isOffers == true ? 3 : 1),
                    predicate: (_) => false);
              },
              text: widget.isOffers == true
                  ? AppConstString.goBackToAllOffer
                  : AppConstString.goBackToAllBrands,
            ),
            const SizedBox(
              height: AppSizes.size30,
            ),
          ],
        ),
      ),
    );
  }
}
