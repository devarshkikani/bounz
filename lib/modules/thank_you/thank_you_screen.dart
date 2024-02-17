import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
class ThankYouScreen extends StatefulWidget {
  final double ratingvalue;
  final bool? isOffer;
  const ThankYouScreen({super.key, this.isOffer, required this.ratingvalue});

  @override
  State<ThankYouScreen> createState() => _ThankYouScreenState();
}

class _ThankYouScreenState extends State<ThankYouScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: AppBackGroundWidget(
          padding: EdgeInsets.zero,
          child: Center(
            child: Column(
              children: [
                Center(
                  child: Lottie.asset(
                    AppAssets.yellowRightWithPop,
                    height: 220,
                  ),
                ),
                Text(
                  AppConstString.thankyouforBounz,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bold20.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(
                  height: AppSizes.size60,
                ),
                ratingWidget(),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                Text(
                  AppConstString.weVlaueYourFeedback,
                  textAlign: TextAlign.center,
                  style: AppTextStyle.bold16.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(
                  height: AppSizes.size40,
                ),
                widget.isOffer == true
                    ? offerRedeemWidget()
                    : partnerRedeemWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ratingWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RatingBar.builder(
          unratedColor: AppColors.whiteColor,
          glow: false,
          ignoreGestures: true,
          minRating: 1,
          maxRating: 5,
          initialRating: widget.ratingvalue,
          itemBuilder: (BuildContext context, int index) {
            return const Row(
              children: [
                Icon(
                  Icons.star,
                  color: AppColors.ratingIcon,
                ),
                SizedBox(
                  width: 4.0,
                ),
              ],
            );
          },
          onRatingUpdate: (double rating) {},
        ),
      ],
    );
  }

  Widget partnerRedeemWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        offerButton(),
        const SizedBox(
          height: AppSizes.size20,
        ),
        PrimaryButton(
          onTap: () {
            MoenageManager.logScreenEvent(name: 'Main Home');
            AutoRouter.of(context).pushAndPopUntil(MainHomeScreenRoute(),
                predicate: (_) => false);
          },
          height: AppSizes.size50,
          tColor: AppColors.whiteColor,
          text: AppConstString.gohome,
          showShadow: true,
        )
      ],
    );
  }

  Widget offerRedeemWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
          child: Row(
            children: [
              Expanded(child: offerButton()),
              const SizedBox(
                width: AppSizes.size20,
              ),
              Expanded(
                child: RoundedBorderButton(
                  onTap: () {
                    MoenageManager.logScreenEvent(name: 'Main Home');
                    AutoRouter.of(context).pushAndPopUntil(
                        MainHomeScreenRoute(),
                        predicate: (_) => false);
                  },
                  height: AppSizes.size50,
                  tColor: AppColors.whiteColor,
                  bColor: AppColors.whiteColor,
                  text: AppConstString.gohome,
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: AppSizes.size20,
        ),
        PrimaryButton(
          onTap: () {
            MoenageManager.logScreenEvent(name: 'Redeemed Offer');
            AutoRouter.of(context).push(
              RedeemedOfferScreenRoute(
                redirectToHome: true,
              ),
            );
          },
          height: AppSizes.size50,
          tColor: AppColors.whiteColor,
          text: AppConstString.goRedeemedOffer,
          showShadow: true,
        )
      ],
    );
  }

  Widget offerButton() {
    return RoundedBorderButton(
      onTap: () {
        MoenageManager.logScreenEvent(name: 'Main Home');
        AutoRouter.of(context).pushAndPopUntil(
            MainHomeScreenRoute(
              index: widget.isOffer == true ? 3 : 4,
            ),
            predicate: (_) => false);
      },
      height: AppSizes.size50,
      tColor: AppColors.whiteColor,
      bColor: AppColors.whiteColor,
      text: widget.isOffer == true
          ? AppConstString.goBackToOffer
          : AppConstString.goBackToMyAcc,
    );
  }
}
