import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/validator.dart';
import 'package:bounz_revamp_app/widgets/my_behavior.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/models/partner/bounz_earn_model.dart';
import 'package:moengage_flutter/properties.dart';

@RoutePage()
class StoreRedeemSuccessScreen extends StatefulWidget {
  final BounzEarnModel bounzEarnModel;
  final String title;
  final String points;
  final bool? isOffers;
  const StoreRedeemSuccessScreen({
    Key? key,
    this.isOffers,
    required this.bounzEarnModel,
    required this.title,
    required this.points,
  }) : super(key: key);

  @override
  State<StoreRedeemSuccessScreen> createState() =>
      _StoreRedeemSuccessScreenState();
}

class _StoreRedeemSuccessScreenState extends State<StoreRedeemSuccessScreen> {
  double ratingvalue = 5;
  TextEditingController feedback = TextEditingController();
  late DateFormat dateFormat;

  @override
  void initState() {
    super.initState();
    getProfileData(context);
    widget.bounzEarnModel.transactionDate;
    dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
  }

  Future<void> submitFeedback(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
        url: ApiPath.apiEndPoint + ApiPath.feedback,
        context: context,
        data: {
          'customer_id': GlobalSingleton.userInformation.membershipNo,
          'star_rating': ratingvalue,
          'feedback': feedback.text.isNotEmpty ? feedback.text : "FEEDBACK",
          'merchant_code': widget.bounzEarnModel.merchantCode,
          'outlet_code': widget.bounzEarnModel.outletCode,
          'transaction_id': widget.bounzEarnModel.transactionId,
        });
    if (response != null) {
      MoenageManager.logScreenEvent(name: 'Thank You');
      final properties = MoEProperties();
      properties
          .addAttribute(TriggeringCondition.merchantName,
              widget.bounzEarnModel.merchantName)
          .addAttribute(TriggeringCondition.screenName, "Store Redeem Success")
          .addAttribute(TriggeringCondition.merchantId,
              widget.bounzEarnModel.transactionId)
          .addAttribute(TriggeringCondition.invoiceAmount,
              widget.bounzEarnModel.totalAmount)
          .addAttribute(TriggeringCondition.merchantStoreid,
              widget.bounzEarnModel.merchantCode)
          .setNonInteractiveEvent();
      MoenageManager.logEvent(
        MoenageEvent.earnedBounz,
        properties: properties,
      );
      AutoRouter.of(context).push(
        ThankYouScreenRoute(ratingvalue: ratingvalue, isOffer: widget.isOffers),
      );
    }
  }

  Future getProfileData(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.getProfile,
      context: context,
      queryParameters: {
        'membership_no': GlobalSingleton.userInformation.membershipNo,
      },
    );
    if (response != null) {
      storeLoginUserData(
        response['data']['values'][0],
        context,
      );
    }
  }

  void storeLoginUserData(Map<String, dynamic> response, BuildContext context) {
    GlobalSingleton.userInformation = UserInformation.fromJson(response);

    StorageManager.setStringValue(
      key: AppStorageKey.userInformation,
      value: userInformationToJson(GlobalSingleton.userInformation),
    );

    StorageManager.setBoolValue(key: AppStorageKey.isLogIn, value: true);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: AppBackGroundWidget(
          padding: EdgeInsets.zero,
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 222,
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppSizes.size30),
                      ),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: CachedNetworkImageProvider(
                          widget.bounzEarnModel.outletImage ?? '',
                        ),
                      ),
                    ),
                  ),
                  Lottie.asset(
                    AppAssets.yellowRightWithPop,
                    height: 180,
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'You have ${widget.title} ${widget.points} BOUNZ',
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bold20.copyWith(
                        color: AppColors.primaryContainerColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size12,
                  ),
                  Text(
                    AppConstString.yourTransactionId,
                    style: AppTextStyle.regular16,
                  ),
                  const SizedBox(
                    height: AppSizes.size4,
                  ),
                  Text(
                    widget.bounzEarnModel.transactionId ?? '',
                    style: AppTextStyle.bold20,
                  ),
                  const SizedBox(
                    height: AppSizes.size10,
                  ),
                  BarcodeWidget(
                    barcode: Barcode.code39(),
                    height: AppSizes.size38,
                    width: MediaQuery.of(context).size.width / 1.5,
                    drawText: false,
                    data: widget.bounzEarnModel.transactionId ?? '',
                  ),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.size20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstString.storeName,
                            style: AppTextStyle.regular12,
                          ),
                          Text(
                            widget.bounzEarnModel.outletName ?? '',
                            style: AppTextStyle.bold18,
                          ),
                          const SizedBox(
                            height: AppSizes.size14,
                          ),
                          Text(
                            AppConstString.address,
                            style: AppTextStyle.regular12,
                          ),
                          Text(
                            widget.bounzEarnModel.outletAddress ?? '',
                            style: AppTextStyle.bold18,
                          ),
                          const SizedBox(
                            height: AppSizes.size14,
                          ),
                          Text(
                            AppConstString.timeOfVisit,
                            style: AppTextStyle.regular12,
                          ),
                          Text(
                            widget.bounzEarnModel.transactionDate.toString(),
                            style: AppTextStyle.bold18,
                          ),
                          const SizedBox(
                            height: AppSizes.size14,
                          ),
                          Text(
                            AppConstString.transactionAmount,
                            style: AppTextStyle.regular12,
                          ),
                          Text(
                            widget.bounzEarnModel.totalAmount.toString(),
                            style: AppTextStyle.bold18,
                          ),
                          const SizedBox(
                            height: AppSizes.size14,
                          ),
                          Text(
                            AppConstString.pleaseAddComments,
                            style: AppTextStyle.regular16
                                .copyWith(color: AppColors.whiteColor),
                          ),
                          const SizedBox(
                            height: AppSizes.size14,
                          ),
                          TextFormFieldWidget(
                            labelText: 'Feedback',
                            controller: feedback,
                            validator: (_) =>
                                Validators.validateText(_, 'Feedback'),
                          ),
                          const SizedBox(
                            height: AppSizes.size20,
                          ),
                          Text(
                            "Rate ${widget.bounzEarnModel.brandName}",
                            style: AppTextStyle.regular16
                                .copyWith(color: AppColors.whiteColor),
                          ),
                          const SizedBox(
                            height: AppSizes.size14,
                          ),
                          SizedBox(
                            width: 240,
                            child: Stack(
                              children: [
                                const TextFormFieldWidget(
                                  contentPadding:
                                      EdgeInsets.all(AppSizes.size16),
                                  enabled: false,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: AppSizes.size20, top: 8),
                                  child: RatingBar.builder(
                                    unratedColor: AppColors.whiteColor,
                                    glow: false,
                                    minRating: 1,
                                    maxRating: 5,
                                    initialRating: ratingvalue,
                                    itemBuilder:
                                        (BuildContext context, int index) {
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
                                        ratingvalue = rating;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: AppSizes.size42,
                          ),
                          Center(
                            child: PrimaryButton(
                              text: AppConstString.submit,
                              onTap: () async {
                                if (ratingvalue == 0.0) {
                                  MoenageManager.logScreenEvent(
                                      name: 'Main Home');
                                  AutoRouter.of(context).pushAndPopUntil(
                                    MainHomeScreenRoute(),
                                    predicate: (_) => false,
                                  );
                                } else {
                                  await submitFeedback(context);
                                }
                              },
                            ),
                          ),
                          const SizedBox(
                            height: AppSizes.size20,
                          ),
                          Center(
                            child: RoundedBorderButton(
                              onTap: () {
                                AutoRouter.of(context).pushAndPopUntil(
                                  MainHomeScreenRoute(),
                                  predicate: (_) => false,
                                );
                              },
                              text: AppConstString.goHome,
                              tColor: AppColors.btnBlueColor,
                              bColor: AppColors.btnBlueColor,
                            ),
                          ),
                          const SizedBox(
                            height: AppSizes.size30,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
