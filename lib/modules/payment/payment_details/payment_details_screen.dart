import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/enum.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/modules/payment/payment_details/gift_self_tab.dart';
import 'package:bounz_revamp_app/modules/payment/payment_details/gift_friend_tab.dart';
import 'package:bounz_revamp_app/modules/payment/payment_details/payment_detail_model.dart';
import 'package:bounz_revamp_app/modules/payment/payment_details/payment_details_view.dart';
import 'package:bounz_revamp_app/modules/payment/payment_details/payment_details_presenter.dart';
import 'package:moengage_flutter/properties.dart';

@RoutePage()
class PaymentDetailsScreen extends StatefulWidget {
  final PaymentDetailsPresenter presenter;
  const PaymentDetailsScreen(this.presenter, {Key? key}) : super(key: key);

  @override
  State<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends State<PaymentDetailsScreen>
    implements PaymentDetailsView {
  late PaymentDetailsModel model;
  bool showConfetti = false;
  @override
  void initState() {
    super.initState();
    widget.presenter.updateModel = this;
  }

  @override
  void refreshModel(PaymentDetailsModel paymentDetailsModel) {
    setState(() {
      model = paymentDetailsModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(
              height: AppSizes.size30,
            ),
            Flexible(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  giftCardDetailsView(),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  giftCardForView(context),
                  const SizedBox(
                    height: AppSizes.size16,
                  ),
                  applyBounz(),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  priceDetailBox(),
                  // const SizedBox(
                  //   height: AppSizes.size20,
                  // ),
                  // selectPaymentMethod(),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  bottomView(),
                  const SizedBox(
                    height: AppSizes.size30,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget giftCardDetailsView() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(AppSizes.size20),
      decoration: BoxDecoration(
          color: AppColors.primaryContainerColor,
          borderRadius: BorderRadius.circular(20.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Gift card details",
            style: AppTextStyle.bold16,
          ),
          const SizedBox(
            height: AppSizes.size10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: CachedNetworkImage(
                  height: 27.0,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) {
                    return const Icon(Icons.error_outline_outlined);
                  },
                  imageUrl: model.image.toString(),
                ),
              ),
              const SizedBox(
                width: AppSizes.size20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name.toString(),
                      style: AppTextStyle.semiBold14,
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      "Category : ${model.giftCategory}",
                      style: AppTextStyle.semiBold12,
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget giftCardForView(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Gift card for (${giftForString(model.giftFor)})',
              style: AppTextStyle.bold16,
            ),
            InkWell(
              onTap: () {
                tabBarBottomSheet(context);
              },
              child: Text(
                'Change',
                style: AppTextStyle.bold12.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: AppSizes.size16,
        ),
        Container(
          padding: const EdgeInsets.all(AppSizes.size20),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: AppColors.textFieldLightColor,
            borderRadius: BorderRadius.circular(AppSizes.size30),
          ),
          child: Text(
            model.giftFor == GiftFor.mySelf
                ? GlobalSingleton.userInformation.email.toString()
                : model.friendData!['receiver_email'],
            style: AppTextStyle.semiBold14,
          ),
        ),
      ],
    );
  }

  String giftForString(value) {
    switch (value) {
      case GiftFor.mySelf:
        return 'MySelf';
      case GiftFor.friend:
        return 'Friend';
      default:
        return '';
    }
  }

  void tabBarBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.secondaryContainerColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppSizes.size20),
          topRight: Radius.circular(AppSizes.size20),
        ),
      ),
      builder: (ctx) {
        return SizedBox(
          height: 450,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(ctx).viewInsets.bottom,
            ),
            child: DefaultTabController(
              length: 2,
              initialIndex: 0,
              child: Column(
                children: [
                  TabBar(
                    labelColor: AppColors.blackColor,
                    unselectedLabelColor: AppColors.whiteColor,
                    indicatorColor: AppColors.blackColor,
                    labelPadding: const EdgeInsets.all(AppSizes.size4),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                    ),
                    tabs: [
                      Tab(
                        child: Text(
                          AppConstString.giftForMyself,
                          style: AppTextStyle.bold16.copyWith(
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          AppConstString.giftAFriend,
                          style: AppTextStyle.bold16.copyWith(
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        GiftSelfTabScreen(
                          onConfirmed: (giftFor) {
                            model.giftFor = giftFor;
                            model.friendData = null;
                            setState(() {});
                          },
                        ),
                        GiftFriendTabScreen(
                          onConfirmed: (giftFor, data) {
                            model.giftFor = giftFor;
                            model.friendData = data;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget applyBounz() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        Text(
          "Apply BOUNZ",
          style: AppTextStyle.bold16,
        ),
        //     Text(
        //       "Bal: ${model.totalPoints.price}",
        //       style: AppTextStyle.bold14,
        //     ),
        //   ],
        // ),
        const SizedBox(
          height: AppSizes.size16,
        ),
        model.bounzApply ? appliedBounzContainer() : payWithBounzContainer(),
      ],
    );
  }

  Widget payWithBounzContainer() {
    return InkWell(
      onTap: () {
        if (GlobalSingleton.userInformation.pointBalance! > model.payBounz) {
          widget.presenter.useBounz();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: GlobalSingleton.userInformation.pointBalance! > model.payBounz
              ? AppColors.primaryContainerColor
              : AppColors.buttonBorderColor.withOpacity(.5),
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.all(AppSizes.size16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20.0,
              width: 20.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.whiteColor),
              ),
              child: Container(
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    color: model.bounzApply
                        ? AppColors.whiteColor
                        : Colors.transparent,
                    shape: BoxShape.circle),
              ),
            ),
            const SizedBox(
              width: AppSizes.size12,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Pay with BOUNZ',
                    style: AppTextStyle.bold16,
                  ),
                  const SizedBox(
                    height: AppSizes.size8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppConstString.balance,
                        style: AppTextStyle.regular14,
                      ),
                      Text(
                        GlobalSingleton.userInformation.pointBalance!.price
                            .toString(),
                        style: AppTextStyle.bold14,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.size8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppConstString.inAed,
                        style: AppTextStyle.regular14,
                      ),
                      Text(
                        'AED ' +
                            (GlobalSingleton.userInformation.pointBalance! *
                                    model.redeemptionRate)
                                .toStringAsFixed(2),
                        style: AppTextStyle.bold14,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget appliedBounzContainer() {
    return InkWell(
      onTap: () {
        if (GlobalSingleton.userInformation.pointBalance! > model.payBounz) {
          widget.presenter.useBounz();
        }
      },
      child: Container(
        height: 60.0,
        decoration: BoxDecoration(
            color: AppColors.primaryContainerColor,
            borderRadius: BorderRadius.circular(18)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    height: 20.0,
                    width: 20.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.whiteColor),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(4.0),
                      decoration: const BoxDecoration(
                          color: AppColors.whiteColor, shape: BoxShape.circle),
                    ),
                  ),
                  const SizedBox(
                    width: AppSizes.size8,
                  ),
                  Text(
                    AppConstString.bounzApplied,
                    style: AppTextStyle.bold16,
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        model.payBounz.toString(),
                        style: AppTextStyle.bold16,
                      ),
                      Text(
                        'AED ' + model.price.toString(),
                        style: AppTextStyle.semiBold12.copyWith(
                            color: AppColors.whiteColor.withOpacity(0.5)),
                      ),
                    ],
                  ),
                ],
              ),
              if (model.bounzApply)
                Positioned(
                  right: 0,
                  bottom: -30,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Lottie.asset(
                      AppAssets.confettiBanner,
                      repeat: false,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget priceDetailBox() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.size20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          width: 1,
          color: AppColors.whiteColor,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Price Breakup  ",
                style: AppTextStyle.bold14,
              ),
              Text(
                "${model.currency} ${model.price}",
                style: AppTextStyle.bold16,
              )
            ],
          ),
          const SizedBox(
            height: AppSizes.size2,
          ),
          paymentsDetailsRow(
              "BOUNZ Used", model.bounzApply ? "${model.payBounz}" : "0"),
          paymentsDetailsRow("Total Payable",
              '${model.currency} ${model.bounzApply ? 0 : model.price}'),
        ],
      ),
    );
  }

  Widget paymentsDetailsRow(String lTxt, String rTxt) {
    return Container(
      padding: const EdgeInsets.only(top: AppSizes.size10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            lTxt,
            style: AppTextStyle.light12,
          ),
          Text(
            rTxt,
            style: AppTextStyle.semiBold14,
          )
        ],
      ),
    );
  }

  // Widget selectPaymentMethod() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         "Select a Payment Method",
  //         style: AppTextStyle.bold16,
  //       ),
  //       const SizedBox(
  //         height: AppSizes.size16,
  //       ),
  //       GestureDetector(
  //         onTap: () {},
  //         child: Container(
  //           width: MediaQuery.of(context).size.width,
  //           padding: const EdgeInsets.symmetric(
  //             vertical: AppSizes.size20,
  //             horizontal: AppSizes.size20,
  //           ),
  //           decoration: BoxDecoration(
  //               color: AppColors.primaryContainerColor,
  //               borderRadius: BorderRadius.circular(15.0)),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Row(
  //                 children: [
  //                   const Icon(
  //                     Icons.credit_card_rounded,
  //                     color: AppColors.whiteColor,
  //                   ),
  //                   const SizedBox(
  //                     width: AppSizes.size10,
  //                   ),
  //                   Text(
  //                     "Credit/Debit Card ",
  //                     style: AppTextStyle.semiBold14,
  //                   ),
  //                 ],
  //               ),
  //               const Icon(
  //                 Icons.arrow_forward_rounded,
  //                 color: AppColors.whiteColor,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget bottomView() {
    String buttonText;
    if (model.bounzApply) {
      buttonText = '${model.payBounz} BOUNZ';
    } else {
      buttonText =
          '${model.bounzApply ? model.payBounz : model.currency} ${model.price}';
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            bottom: AppSizes.size10,
          ),
          alignment: Alignment.center,
          child: PrimaryButton(
            text: "Pay Now  ($buttonText)",
            showShadow: true,
            onTap: () {
              final properties = MoEProperties();
              properties
                  .addAttribute(TriggeringCondition.screenName, "Checkout")
                  .addAttribute(TriggeringCondition.productType, "Gift card")
                  .addAttribute(TriggeringCondition.productDetails, model.name)
                  .addAttribute(TriggeringCondition.paymentType,
                      model.bounzApply ? "Pay with bounz" : "Credit/Debit")
                  .addAttribute(TriggeringCondition.paymentMethod,
                      model.bounzApply ? "Pay with bounz" : "Credit/Debit")
                  .addAttribute(TriggeringCondition.totalAmount, model.price)
                  .addAttribute(TriggeringCondition.amountPayedbyBounz,
                      model.bounzApply ? true : false)
                  .addAttribute(TriggeringCondition.amountPayedbycash, true)
                  .setNonInteractiveEvent();
              MoenageManager.logEvent(
                MoenageEvent.checkout,
                properties: properties,
              );

              final properties1 = MoEProperties();
              properties1
                  .addAttribute(TriggeringCondition.productType, "Gift card")
                  .addAttribute(TriggeringCondition.productDetails, model.name)
                  .addAttribute(TriggeringCondition.paymentType,
                      model.bounzApply ? "Pay with bounz" : "Credit/Debit")
                  .addAttribute(TriggeringCondition.paymentMethod,
                      model.bounzApply ? "Pay with bounz" : "Credit/Debit")
                  .addAttribute(TriggeringCondition.totalAmount, model.price)
                  .addAttribute(TriggeringCondition.amountPayedbyBounz,
                      model.bounzApply ? true : false)
                  .addAttribute(TriggeringCondition.amountPayedbycash, true)
                  .setNonInteractiveEvent();
              MoenageManager.logEvent(
                MoenageEvent.receiptsSelected,
                properties: properties1,
              );
              widget.presenter.puchaseVoucher(context);
            },
          ),
        ),
        if (!model.bounzApply)
          Center(
            child: Text(
              "Earn ${model.earnUpTo} BOUNZ",
              style: AppTextStyle.semiBold14,
            ),
          ),
      ],
    );
  }

  Widget rowWidgetForText(String txtOne, String txtSecond) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          txtOne,
          style: AppTextStyle.bold16,
        ),
        Text(
          txtSecond,
          style: AppTextStyle.bold12.copyWith(
            decoration: TextDecoration.underline,
          ),
        ),
      ],
    );
  }
}
