import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/my_behavior.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:lottie/lottie.dart';
import 'package:moengage_flutter/properties.dart';

@RoutePage()
class FeedbackScreen extends StatefulWidget {
  final bool fromSplash;
  const FeedbackScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  int ratingvalue = 5;

  Future<void> submitFeedback(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
        url: ApiPath.apiEndPoint + ApiPath.feedback,
        context: context,
        data: {
          'customer_id':
              GlobalSingleton.userInformation.membershipNo.toString(),
          'star_rating': ratingvalue,
          'feedback': 'feedback'
        });
    if (response != null) {
      GlobalSingleton.userInformation.rating = ratingvalue;
      final properties = MoEProperties();
      properties.addAttribute(
          TriggeringCondition.screenName, 'FeedBack Screen');
      properties
          .addAttribute(
            TriggeringCondition.userRating,
            GlobalSingleton.userInformation.rating.toString(),
          )
          .setNonInteractiveEvent();
      MoenageManager.logEvent(
        MoenageEvent.rateUs,
        properties: properties,
      );
      final String encodeData =
          jsonEncode(GlobalSingleton.userInformation.toJson());
      StorageManager.setStringValue(
          key: AppStorageKey.userInformation, value: encodeData);
      Navigator.of(context).pop();
      if (ratingvalue > 3) {
        popDialog(context);
      } else {
        popupBottomSheetRate(context, "Thanks for rating us!!");
      }
    }
  }

  void popDialog(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.secondaryContainerColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: AppSizes.size20,
            right: AppSizes.size20,
            left: AppSizes.size20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SizedBox(
            height: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Share the love! Rate us on the Store',
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
                          Navigator.of(ctx).pop();
                          final InAppReview inAppReview = InAppReview.instance;
                          inAppReview.openStoreListing(
                            appStoreId: '1573809550',
                          );
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
                          Navigator.of(ctx).pop();
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

  @override
  void initState() {
    super.initState();
    ratingvalue = GlobalSingleton.userInformation.rating ?? 5;
  }

  Future<void> popupBottomSheetRate(
      BuildContext buildContext, String text) async {
    await showModalBottomSheet(
      backgroundColor: AppColors.secondaryContainerColor,
      context: buildContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: AppSizes.size20,
            right: AppSizes.size20,
            left: AppSizes.size20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  text,
                  style: AppTextStyle.semiBold14.copyWith(
                    color: AppColors.darkBlueTextColor,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(
                  height: AppSizes.size30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PrimaryButton(
                      height: AppSizes.size60,
                      text: "Okay",
                      onTap: () {
                        AutoRouter.of(context).pushAndPopUntil(
                            MainHomeScreenRoute(isFirstLoad: true, index: 4),
                            predicate: (_) => false);
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.size30,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AppBackGroundWidget(
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (widget.fromSplash) {
                    MoenageManager.logScreenEvent(name: 'Main Home');
                    AutoRouter.of(context).pushAndPopUntil(
                        MainHomeScreenRoute(
                          isFirstLoad: true,
                        ),
                        predicate: (_) => false);
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.whiteColor,
                ),
              ),
              const SizedBox(
                height: AppSizes.size30,
              ),
              Text(
                AppConstString.rateUS,
                style: AppTextStyle.regular36.copyWith(
                  fontFamily: 'Bebas',
                ),
              ),
              // ignore: prefer_const_constructors
              SizedBox(
                height: AppSizes.size20,
              ),
              Lottie.asset(AppAssets.rateUsGif),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      AppConstString.how,
                      style: AppTextStyle.semiBold18,
                    ),
                    const SizedBox(
                      height: AppSizes.size2,
                    ),
                    Text(
                      AppConstString.pleaseSelect,
                      style: AppTextStyle.light14,
                    ),
                    const SizedBox(
                      height: AppSizes.size20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        RatingBar.builder(
                          unratedColor: AppColors.whiteColor,
                          glow: false,
                          minRating: 1,
                          maxRating: 5,
                          initialRating:
                              (GlobalSingleton.userInformation.rating ?? 5)
                                  .toDouble(),
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
                          onRatingUpdate: (double rating) {
                            setState(() {
                              ratingvalue = rating.toInt();
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSizes.size30,
              ),
              rateButtonWidget(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget rateButtonWidget(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppSizes.size30),
        child: PrimaryButton(
          onTap: () {
            submitFeedback(context);
          },
          text: AppConstString.rate,
          showShadow: true,
          height: AppSizes.size60,
        ),
      ),
    );
  }
}
