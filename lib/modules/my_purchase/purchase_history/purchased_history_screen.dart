import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/models/purchased_history_card/purchased_history_card.dart';
import 'package:bounz_revamp_app/modules/my_purchase/purchase_history/purchased_history_model.dart';
import 'package:bounz_revamp_app/modules/my_purchase/purchase_history/purchased_history_presenter.dart';
import 'package:bounz_revamp_app/modules/my_purchase/purchase_history/purchased_history_view.dart';
import 'package:bounz_revamp_app/modules/payment/payment_details/payment_details_presenter.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:bounz_revamp_app/widgets/shrimmer_widet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class PurchasedHistoryScreen extends StatefulWidget {
  final bool fromSplash;
  const PurchasedHistoryScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  _PurchasedHistoryScreenState createState() => _PurchasedHistoryScreenState();
}

class _PurchasedHistoryScreenState extends State<PurchasedHistoryScreen>
    implements PurchasedHistoryView {
  late PurchasedHistoryModel model;
  final PurchasedHistoryPresenter presenter = BasicPurchasedHistoryPresenter();

  @override
  void initState() {
    super.initState();
    presenter.modelUpdate = this;
    presenter.getMyTransactions();
  }

  @override
  void refreshModel(PurchasedHistoryModel model) {
    setState(() {
      this.model = model;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromSplash) {
          MoenageManager.logScreenEvent(name: 'Main Home');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(isFirstLoad: true, index: 4),
              predicate: (_) => false);
        } else {
          AutoRouter.of(context).canPop();
        }
        return true;
      },
      child: Scaffold(
        body: AppBackGroundWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
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
                AppConstString.purchasedHistory.toUpperCase(),
                style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
              ),
              Expanded(
                child: model.purchasedHistoryList == null
                    ? ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.only(top: AppSizes.size20),
                            padding: const EdgeInsets.all(AppSizes.size12),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainerColor,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Row(
                                  children: [
                                    CustomShrimmerWidget.circular(
                                      height: 10,
                                      width: 10,
                                    ),
                                    SizedBox(
                                      width: 6.0,
                                    ),
                                    CustomShrimmerWidget.rectangular(
                                      height: 10,
                                      width: 70,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 5.0,
                                ),
                                const CustomShrimmerWidget.rectangular(
                                  height: 10,
                                  width: 100,
                                ),
                                const SizedBox(
                                  height: AppSizes.size12,
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 70,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: const CustomShrimmerWidget
                                            .rectangular(
                                          height: 70,
                                          width: 100,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: AppSizes.size16,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CustomShrimmerWidget.rectangular(
                                            height: 10,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          ),
                                          const SizedBox(
                                            height: 3.0,
                                          ),
                                          CustomShrimmerWidget.rectangular(
                                            height: 10,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .4,
                                          ),
                                          const SizedBox(
                                            height: 6.0,
                                          ),
                                          const CustomShrimmerWidget
                                              .rectangular(
                                            height: 8,
                                            width: 80,
                                          ),
                                          const SizedBox(
                                            height: 10.0,
                                          ),
                                          const CustomShrimmerWidget
                                              .rectangular(
                                            height: 14,
                                            width: 50,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: AppSizes.size16,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: const CustomShrimmerWidget
                                            .rectangular(
                                          height: AppSizes.size30,
                                          width: 50,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: AppSizes.size10,
                                    ),
                                    Expanded(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                        child: const CustomShrimmerWidget
                                            .rectangular(
                                          height: AppSizes.size30,
                                          width: 50,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    : model.purchasedHistoryList?.isEmpty == true
                        ? Center(
                            child: Text(
                              "You didn't purchase anything",
                              style: AppTextStyle.bold20.copyWith(
                                color: AppColors.blueButtonColor,
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: model.purchasedHistoryList!.length,
                            itemBuilder: (context, index) {
                              return historyContainer(
                                false,
                                context,
                                model.purchasedHistoryList![index],
                              );
                            },
                          ),
              ),
              const SizedBox(
                height: AppSizes.size10,
              ),
              buyGiftButtonContainer(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget buyGiftButtonContainer(context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: AppSizes.size30),
      child: PrimaryButton(
        bColor: AppColors.btnBlueColor,
        text: AppConstString.buyGiftCards,
        onTap: () {
          MoenageManager.logScreenEvent(name: 'Buy Gift Cards');

          AutoRouter.of(context).push(
            BuyGiftCardsScreenRoute(),
          );
        },
      ),
    );
  }

  Widget historyContainer(
    bool purchasedStatus,
    BuildContext context,
    PurchasedHistoryCard purchasedHistory,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: AppSizes.size20),
      padding: const EdgeInsets.all(AppSizes.size12),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainerColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  purchasedHistory.transactionStatus == 'SUCCESS'
                      ? SvgPicture.asset(AppAssets.rightGreen)
                      : const Icon(Icons.access_time),
                  const SizedBox(
                    width: 6.0,
                  ),
                  Text(
                    purchasedHistory.transactionStatus == 'SUCCESS'
                        ? "Completed"
                        : "Processing",
                    style: AppTextStyle.regular14.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                ],
              ),
              purchasedHistory.isExpired! > 0
                  ? Text(
                      "Expired",
                      style: AppTextStyle.regular12.copyWith(
                        color: AppColors.blackColor,
                      ),
                    )
                  : const SizedBox()
            ],
          ),
          const SizedBox(
            height: 5.0,
          ),
          Text(
            DateTime.parse(
              purchasedHistory.purchasedDate.toString(),
            ).ymddateFormat,
            style: AppTextStyle.regular14.copyWith(
              color: AppColors.blackColor,
            ),
          ),
          const SizedBox(
            height: AppSizes.size12,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: purchasedHistory.mobileImage == null
                      ? const SizedBox()
                      : networkImage(
                          purchasedHistory.mobileImage.toString(),
                        ),
                ),
              ),
              const SizedBox(
                width: AppSizes.size16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      purchasedHistory.productName ?? "",
                      style: AppTextStyle.semiBold16
                          .copyWith(color: AppColors.blackColor),
                    ),
                    Text(
                      "Category - ${purchasedHistory.categoryName}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: AppTextStyle.regular14
                          .copyWith(color: AppColors.blackColor),
                    ),
                    const SizedBox(
                      height: 6.0,
                    ),
                    Text(
                      "AED ${purchasedHistory.totalAmount}",
                      style: AppTextStyle.bold16
                          .copyWith(color: AppColors.blackColor),
                    )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: AppSizes.size16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: purchasedHistory.transactionStatus == 'SUCCESS'
                    ? RoundedBorderButton(
                        text: "View Details",
                        tColor: AppColors.whiteColor,
                        bColor: AppColors.whiteColor,
                        height: AppSizes.size40,
                        onTap: () {
                          MoenageManager.logScreenEvent(
                              name: 'Voucher Details');

                          AutoRouter.of(context).push(
                            VoucherDetailsRoute(
                              purchasedDeatils: purchasedHistory,
                              redemptionRate: model.redemptionRate,
                              earnUpTo: ((model.offerPloughbackFactor! / 100) *
                                      (purchasedHistory.totalAmount! /
                                          model.rpm!))
                                  .toStringAsFixed(0),
                            ),
                          );
                        },
                      )
                    : const SizedBox(),
              ),
              const SizedBox(
                width: AppSizes.size10,
              ),
              Expanded(
                child: PrimaryButton(
                  text: purchasedHistory.transactionStatus == 'SUCCESS'
                      ? "Purchase Again"
                      : "View Details",
                  height: AppSizes.size40,
                  onTap: purchasedHistory.transactionStatus == 'SUCCESS'
                      ? () {
                          MoenageManager.logScreenEvent(
                              name: 'Payment Details');

                          AutoRouter.of(context).push(
                            PaymentDetailsScreenRoute(
                              presenter: BasicPaymentDetailsPresenter(
                                price: purchasedHistory.totalAmount!,
                                giftCategoryName:
                                    purchasedHistory.categoryName.toString(),
                                pointBalance: GlobalSingleton
                                        .userInformation.pointBalance ??
                                    0,
                                image: purchasedHistory.mobileImage.toString(),
                                name: purchasedHistory.productName.toString(),
                                currency: 'AED',
                                earnUpTo:
                                    ((model.offerPloughbackFactor! / 100) *
                                            (purchasedHistory.totalAmount! /
                                                model.rpm!))
                                        .toStringAsFixed(0),
                                payBounz: purchasedHistory.payWithPoints ?? 0,
                                supplierCode:
                                    purchasedHistory.supplierCode.toString(),
                                giftcardId:
                                    int.parse(purchasedHistory.giftcardId!),
                                redeemptionRate: model.redemptionRate!,
                              ),
                            ),
                          );
                        }
                      : () {
                          MoenageManager.logScreenEvent(
                              name: 'Voucher Details');

                          AutoRouter.of(context).push(
                            VoucherDetailsRoute(
                              purchasedDeatils: purchasedHistory,
                              redemptionRate: model.redemptionRate,
                              earnUpTo: ((model.offerPloughbackFactor! / 100) *
                                      (purchasedHistory.totalAmount! /
                                          model.rpm!))
                                  .toStringAsFixed(0),
                            ),
                          );
                        },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
