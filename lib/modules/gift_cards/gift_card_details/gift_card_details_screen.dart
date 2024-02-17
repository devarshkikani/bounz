import 'package:bounz_revamp_app/modules/gift_cards/gift_card_details/shrimmer_gift_card_detail.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/utils/progress_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/models/gif_card_voucher/gift_voucher_details.dart';
import 'package:bounz_revamp_app/modules/payment/payment_details/payment_details_presenter.dart';
import 'package:bounz_revamp_app/modules/gift_cards/gift_card_details/gift_card_details_view.dart';
import 'package:bounz_revamp_app/modules/gift_cards/gift_card_details/gift_card_details_model.dart';
import 'package:bounz_revamp_app/modules/gift_cards/gift_card_details/gift_card_details_presenter.dart';
import 'package:moengage_flutter/properties.dart';

@RoutePage()
class GiftCardDetailsScreen extends StatefulWidget {
  final GiftCardDetailsPresenter presenter;
  const GiftCardDetailsScreen(this.presenter, {Key? key}) : super(key: key);

  @override
  State<GiftCardDetailsScreen> createState() => _GiftCardDetailsScreenState();
}

class _GiftCardDetailsScreenState extends State<GiftCardDetailsScreen>
    implements GiftCardDetailsView {
  late GiftCardDetailsModel model;
  @override
  void initState() {
    super.initState();
    widget.presenter.updateModel = this;
    widget.presenter.getVoucherDetails();
  }

  @override
  void refreshModel(GiftCardDetailsModel giftCardVoucher) {
    if(mounted) {
      setState(() {
      model = giftCardVoucher;
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: model.giftVouchersDetail == null
            ? model.error
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      Expanded(
                        child: Center(
                          child: Text(
                            "Gift Voucher Details Not Found",
                            style: AppTextStyle.semiBold18,
                          ),
                        ),
                      ),
                    ],
                  )
                : const ShrimmerGiftCardDetails()
            : Column(
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
                    model.giftVouchersDetail!.objects!.name!.toUpperCase(),
                    style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
                  ),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        earnUptoContainerWidget(),
                        const SizedBox(
                          height: AppSizes.size20,
                        ),
                        Text(
                          "About",
                          style: AppTextStyle.bold16,
                        ),
                        const SizedBox(
                          height: AppSizes.size16,
                        ),
                        Text(
                          model.giftVouchersDetail!.objects!.description
                              .toString()
                              .trim(),
                          style: AppTextStyle.semiBold14,
                        ),
                        const SizedBox(
                          height: AppSizes.size20,
                        ),
                        Text(
                          "How to use",
                          style: AppTextStyle.bold16,
                        ),
                        const SizedBox(
                          height: AppSizes.size16,
                        ),
                        Text(
                          model.giftVouchersDetail!.objects!.howToRedeem
                              .toString()
                              .trim(),
                          style: AppTextStyle.semiBold14,
                        ),
                        const SizedBox(
                          height: AppSizes.size20,
                        ),
                        Text(
                          "Gift Card",
                          style: AppTextStyle.bold16,
                        ),
                        const SizedBox(
                          height: AppSizes.size20,
                        ),
                        Text(
                          "Card Amount",
                          style: AppTextStyle.semiBold14,
                        ),
                        const SizedBox(
                          height: AppSizes.size16,
                        ),
                        getCardAmount(context),
                        if (model.giftVouchersDetail?.objects
                                ?.denominationType ==
                            'Range')
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'AED ' + model.showPrice.toString(),
                                  style: AppTextStyle.semiBold16.copyWith(
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        nextButtonWidget(context),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget getCardAmount(BuildContext context) {
    Objects? objects = model.giftVouchersDetail?.objects;
    if (objects?.denominationType == 'Range') {
      if (model.price == 0) {
        model.price = objects!.denominationFrom!;
        model.showPrice = objects.denominationFrom!;
      }
      return Column(
        children: [
          SliderTheme(
            data: SliderThemeData(
              inactiveTrackColor: AppColors.btnBlueColor,
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10,
              ),
              showValueIndicator: ShowValueIndicator.always,
              valueIndicatorColor: AppColors.btnBlueColor,
              valueIndicatorTextStyle: AppTextStyle.semiBold16,
            ),
            child: Slider(
              min: 0,
              max: model.valuesList.length - 1,
              value: model.selectedIndex!.toDouble(),
              divisions: model.valuesList.length - 1,
              activeColor: AppColors.primaryContainerColor,
              inactiveColor: AppColors.whiteColor,
              label: '${model.price.round()}',
              onChangeEnd: (value) {
                model.selectedIndex = value.toInt();
                model.showPrice = model.valuesList[value.toInt()].round();
                setState(() {});
              },
              onChanged: (value) {
                model.selectedIndex = value.toInt();
                model.price = model.valuesList[value.toInt()].round();
                setState(() {});
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${objects!.currency} ${objects.denominationFrom!}',
                style: AppTextStyle.semiBold14.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
              Text(
                '${objects.currency} ${objects.denominationTo!}',
                style: AppTextStyle.semiBold14.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
            ],
          ),
        ],
      );
    } else {
      return SizedBox(
        height: AppSizes.size50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          children: List.generate(
            objects!.fixedDenominationAmount != null
                ? objects.fixedDenominationAmount!.split(',').toList().length
                : objects.payWithPoints!.split(',').toList().length,
            (index) {
              String pointOrPrice = objects.fixedDenominationAmount != null
                  ? objects.fixedDenominationAmount!.split(',').toList()[index]
                  : objects.payWithPoints!.split(',').toList()[index];
              // if (pointOrPrice.contains(".")) {
              num? newVarDouble = num.tryParse(pointOrPrice);
              pointOrPrice = newVarDouble.toString();
              // }
              return GestureDetector(
                onTap: () {
                  setState(() {
                    model.selectedIndex = index;
                    model.price = num.parse(pointOrPrice);
                  });
                },
                child: whiteBorderWidget(
                  "${objects.currency} $pointOrPrice",
                  num.parse(pointOrPrice),
                ),
              );
            },
          ),
        ),
      );
    }
  }

  Widget earnUptoContainerWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.secondaryContainerColor,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 6,
            offset: const Offset(0, 3),
            color: const Color(0xff000029).withOpacity(.3),
          ),
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(AppSizes.size10),
              topRight: Radius.circular(AppSizes.size10),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: const Color(0xff000029).withOpacity(0.1),
              ),
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const Center(child: ProcessIndicator()),
                imageUrl:
                    model.giftVouchersDetail!.objects!.mobileImage.toString(),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSizes.size8,
              ),
              child: Text(
                "Earn upto to ${model.giftVouchersDetail!.objects!.earnPoints.toString().split(',').toList().last} BOUNZ",
                style: AppTextStyle.semiBold14.copyWith(
                  color: AppColors.blackColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget nextButtonWidget(context) {
    return Container(
      padding:
          const EdgeInsets.only(top: AppSizes.size20, bottom: AppSizes.size30),
      alignment: Alignment.center,
      child: PrimaryButton(
        text: AppConstString.next,
        onTap: () {
          if (model.price != 0) {
            MoenageManager.logScreenEvent(name: 'Payment Details');
            final properties = MoEProperties();
            properties
                .addAttribute(TriggeringCondition.giftCardName,
                    model.giftVouchersDetail!.objects!.name.toString())
                .addAttribute(TriggeringCondition.giftcardCurrency,
                    model.giftVouchersDetail!.objects!.currency.toString())
                .addAttribute(
                    TriggeringCondition.giftcardDenomination,
                    model.giftVouchersDetail?.objects?.denominationType ==
                            'Range'
                        ? ((num.parse(model.giftVouchersDetail!
                                        .offerPloughbackFactor!) /
                                    100) *
                                (model.price /
                                    num.parse(model.giftVouchersDetail!.rpm!)))
                            .toStringAsFixed(0)
                        : model.giftVouchersDetail!.objects!.earnPoints
                            .toString()
                            .split(',')
                            .toList()[model.selectedIndex ?? 0])
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.giftcardSelect,
              properties: properties,
            );

            AutoRouter.of(context).push(
              PaymentDetailsScreenRoute(
                presenter: BasicPaymentDetailsPresenter(
                  giftcardId: model.giftcardId,
                  price: model.price,
                  giftCategoryName: model.giftCategory,
                  supplierCode: model.supplierCode,
                  pointBalance:
                      GlobalSingleton.userInformation.pointBalance ?? 0,
                  image:
                      model.giftVouchersDetail!.objects!.mobileImage.toString(),
                  name: model.giftVouchersDetail!.objects!.name.toString(),
                  earnUpTo: model
                              .giftVouchersDetail?.objects?.denominationType ==
                          'Range'
                      ? ((num.parse(model.giftVouchersDetail!
                                      .offerPloughbackFactor!) /
                                  100) *
                              (model.price /
                                  num.parse(model.giftVouchersDetail!.rpm!)))
                          .round()
                          .toString()
                      : model.giftVouchersDetail!.objects!.earnPoints
                          .toString()
                          .split(',')
                          .toList()[model.selectedIndex ?? 0],
                  currency: 'AED',
                  payBounz:
                      (model.price / model.giftVouchersDetail!.redemptionRate!)
                          .round(),
                  redeemptionRate: model.giftVouchersDetail!.redemptionRate!,
                ),
              ),
            );
          } else {
            NetworkDio.showWarning(
              message: 'Select Price First',
              context: context,
            );
          }
        },
      ),
    );
  }

  Widget whiteBorderWidget(String txt, num index) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.size8),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
      decoration: BoxDecoration(
        color: index == model.price
            ? AppColors.backgroundColor
            : Colors.transparent,
        border: Border.all(
          width: 1,
          color: index == model.price
              ? AppColors.backgroundColor
              : AppColors.whiteColor,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Text(
        txt,
        style: AppTextStyle.semiBold14,
      ),
    );
  }
}
