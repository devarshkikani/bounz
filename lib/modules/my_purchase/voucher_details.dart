import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/models/purchased_history_card/purchased_history_card.dart';
import 'package:bounz_revamp_app/modules/payment/payment_details/payment_details_presenter.dart';
import 'package:moengage_flutter/properties.dart';

@RoutePage()
class VoucherDetails extends StatefulWidget {
  final PurchasedHistoryCard purchasedDeatils;
  final double? redemptionRate;
  final String earnUpTo;
  const VoucherDetails(
      {Key? key,
      required this.purchasedDeatils,
      required this.redemptionRate,
      required this.earnUpTo})
      : super(key: key);

  @override
  State<VoucherDetails> createState() => _VoucherDetailsState();
}

class _VoucherDetailsState extends State<VoucherDetails> {
  TextEditingController giftCardCtn = TextEditingController();

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
            Text(
              AppConstString.voucherDetail.toUpperCase(),
              style: AppTextStyle.regular36.copyWith(
                fontFamily: "Bebas",
              ),
            ),
            const SizedBox(
              height: AppSizes.size20,
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  giftContainer(),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  Text(
                    "Gift card for (${widget.purchasedDeatils.purchasedFor == 'self' ? 'Myself' : 'Friend'})",
                    style: AppTextStyle.bold16,
                  ),
                  const SizedBox(
                    height: AppSizes.size16,
                  ),
                  txtWidget(giftCardCtn),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Payment Details",
                    style: AppTextStyle.bold16,
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding: const EdgeInsets.all(AppSizes.size20),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(
                          width: 1,
                          color: AppColors.whiteColor,
                        )),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Price Breakup  ",
                              style: AppTextStyle.bold16,
                            ),
                            Text(
                              "AED ${widget.purchasedDeatils.totalAmount}",
                              style: AppTextStyle.bold16,
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 6.0,
                        ),
                        paymentsDetailsRow("BOUNZ Used",
                            "${widget.purchasedDeatils.transactionType.toString() == "RD" ? widget.purchasedDeatils.pointsRedeemed! : 0}"),
                        paymentsDetailsRow("Total Payable",
                            "AED ${widget.purchasedDeatils.transactionType.toString() == "RD" ? 0 : widget.purchasedDeatils.totalAmount}"),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  Text(
                    getMessgae(),
                    style: AppTextStyle.bold16,
                  ),
                  buttonWidget(context),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buttonWidget(context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSizes.size30,
        bottom: AppSizes.size30,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RoundedBorderButton(
            bColor: AppColors.secondaryBackgroundColor,
            tColor: AppColors.secondaryBackgroundColor,
            text: AppConstString.back,
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
          const SizedBox(
            height: AppSizes.size16,
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.size30),
            child: PrimaryButton(
                text: AppConstString.purchaseAgain,
                onTap: () {
                  MoenageManager.logScreenEvent(name: 'Payment Details');
                  final properties = MoEProperties();
                  properties
                      .addAttribute(TriggeringCondition.giftCardDetail,
                          widget.purchasedDeatils)
                      .addAttribute(
                          TriggeringCondition.screenName, "Voucher Details")
                      .addAttribute(TriggeringCondition.amount,
                          widget.purchasedDeatils.totalAmount)
                      .addAttribute(TriggeringCondition.paymentType,
                          widget.purchasedDeatils.paymentType)
                      .setNonInteractiveEvent();
                  MoenageManager.logEvent(
                    MoenageEvent.voucherDetail,
                    properties: properties,
                  );
                  AutoRouter.of(context).push(
                    PaymentDetailsScreenRoute(
                      presenter: BasicPaymentDetailsPresenter(
                        price: widget.purchasedDeatils.totalAmount!,
                        giftCategoryName:
                            widget.purchasedDeatils.categoryName.toString(),
                        pointBalance:
                            GlobalSingleton.userInformation.pointBalance ?? 0,
                        image: widget.purchasedDeatils.mobileImage.toString(),
                        name: widget.purchasedDeatils.productName.toString(),
                        currency: 'AED',
                        earnUpTo: widget.earnUpTo,
                        payBounz: widget.purchasedDeatils.payWithPoints ?? 0,
                        redeemptionRate: widget.redemptionRate!,
                        supplierCode:
                            widget.purchasedDeatils.supplierCode.toString(),
                        giftcardId:
                            int.parse(widget.purchasedDeatils.giftcardId!),
                      ),
                    ),
                  );
                },
                tColor: AppColors.whiteColor,
                bColor: AppColors.secondaryBackgroundColor),
          ),
        ],
      ),
    );
  }

  Widget txtWidget(giftCardCtn) {
    return TextFormFieldWidget(
      enabled: false,
      controller: giftCardCtn,
      hintText: widget.purchasedDeatils.receiverEmail,
      hintStyle: AppTextStyle.semiBold14,
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

  Widget giftContainer() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.size20),
      decoration: BoxDecoration(
        color: AppColors.primaryContainerColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Gift card details",
            style: AppTextStyle.bold16,
          ),
          const SizedBox(
            height: AppSizes.size10,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                width: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: widget.purchasedDeatils.mobileImage == null
                      ? const SizedBox()
                      : CachedNetworkImage(
                          height: 27.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) {
                            return const Icon(Icons.error_outline_outlined);
                          },
                          imageUrl:
                              widget.purchasedDeatils.mobileImage.toString(),
                        ),
                ),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
              ),
              const SizedBox(
                width: AppSizes.size16,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      widget.purchasedDeatils.productName ?? "",
                      style: AppTextStyle.semiBold14,
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "Category : ${widget.purchasedDeatils.categoryName}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: AppTextStyle.regular12,
                    ),
                    const Divider(),
                    Text(
                      "Expiry: ${DateTime.parse(
                        widget.purchasedDeatils.validity.toString(),
                      ).ymddateFormatWithoutDay}",
                      style: AppTextStyle.regular12,
                    )
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  String getMessgae() {
    if (widget.purchasedDeatils.transactionType.toString() == "RD") {
      return "Paid using ${widget.purchasedDeatils.pointsRedeemed} BOUNZ";
    } else if (widget.purchasedDeatils.transactionType.toString() == "ACC") {
      return "Paid using ${widget.purchasedDeatils.totalAmount} AED";
    } else {
      return "Paid using ${widget.purchasedDeatils.pointsRedeemed} BOUNZ and ${widget.purchasedDeatils.totalAmount} AED";
    }
  }
}
