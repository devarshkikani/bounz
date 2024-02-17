import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
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
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/modules/pay_bills/paybill_checkout/checkout_view.dart';
import 'package:bounz_revamp_app/modules/pay_bills/paybill_checkout/checkout_model.dart';
import 'package:bounz_revamp_app/modules/pay_bills/paybill_checkout/checkout_presenter.dart';
import 'package:moengage_flutter/properties.dart';

@RoutePage()
class CheckoutScreen extends StatefulWidget {
  final CheckoutPresenter presenter;
  final bool fromRecentTransaction;
  final Map<String, dynamic>? countryDetails;
  const CheckoutScreen(
    this.presenter, {
    Key? key,
    this.countryDetails,
    this.fromRecentTransaction = false,
  }) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    implements CheckoutView {
  late CheckoutModel model;
  @override
  void initState() {
    super.initState();
    widget.presenter.updateView = this;
  }

  @override
  void refreshModel(CheckoutModel checkoutModel) {
    setState(() {
      model = checkoutModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: SingleChildScrollView(
          child: Column(
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
              Text(
                AppConstString.checkOut.toUpperCase(),
                style: AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              totalPayableContainer(),
              const SizedBox(
                height: AppSizes.size12,
              ),
              model.bounzApply
                  ? appliedBounzContainer()
                  : payWithBounzContainer(),
              const SizedBox(
                height: AppSizes.size16,
              ),
              priceBreakUpContainer(),
              const SizedBox(
                height: AppSizes.size16,
              ),
              payNowButtonWidget(),
              if (!model.bounzApply)
                Center(
                  child: Text(
                    'Earn ${model.productModel.earnPoint} BOUNZ',
                    style: AppTextStyle.semiBold14,
                  ),
                ),
              const SizedBox(
                height: AppSizes.size30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget totalPayableContainer() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryContainerColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstString.totalPayable,
                  style: AppTextStyle.bold16,
                ),
                const SizedBox(
                  height: AppSizes.size2,
                ),
                if (model.phoneNumber != null) phoneNumberWidget(),
                if (model.accountNumber != null) accountNumberWidget(),
              ],
            ),
            Text(
              'AED ' +
                  (model.bounzApply
                          ? model.productModel.pricesRetailAmount
                          : (model.productModel.totalAmount ?? 0)
                              .toStringAsFixed(2))
                      .toString(),
              style: AppTextStyle.bold18,
            )
          ],
        ),
      ),
    );
  }

  Widget phoneNumberWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.countryCode.toString() + '' + model.phoneNumber.toString(),
          style: AppTextStyle.semiBold14
              .copyWith(color: AppColors.whiteColor.withOpacity(0.5)),
        ),
        const SizedBox(
          height: AppSizes.size8,
        ),
        InkWell(
          onTap: () {
            if (widget.fromRecentTransaction) {
              AutoRouter.of(context).push(
                AddDetailsScreenRoute(
                  productModel: model.productModel,
                  accountNumbe: model.accountNumber,
                  accountQualifier: model.accountQualifier,
                  phoneNumber: model.phoneNumber,
                  calulationDetails: {'redemption_rate': model.redemptionRate},
                  country: widget.countryDetails!,
                ),
              );
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Text(
            AppConstString.changeNumber,
            style: AppTextStyle.bold12.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        if (model.phoneNumber != null && model.accountNumber != null)
          const SizedBox(
            height: AppSizes.size12,
          ),
      ],
    );
  }

  Widget accountNumberWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          model.accountNumber.toString(),
          overflow: TextOverflow.ellipsis,
          style: AppTextStyle.semiBold14
              .copyWith(color: AppColors.whiteColor.withOpacity(0.5)),
        ),
        const SizedBox(
          height: AppSizes.size8,
        ),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Text(
            AppConstString.changeNumber,
            style: AppTextStyle.bold12.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget payWithBounzContainer() {
    return InkWell(
      onTap: () {
        widget.presenter.applyBounzClick(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: GlobalSingleton.userInformation.pointBalance! >
                  model.productModel.requiredPoints!
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
                    'Pay with BOUNZ ', //(${model.productModel.requiredPoints})
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
                                    model.redemptionRate!)
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
        widget.presenter.applyBounzClick(context);
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
                        model.productModel.requiredPoints.toString(),
                        style: AppTextStyle.bold16,
                      ),
                      Text(
                        'AED ' +
                            model.productModel.pricesRetailAmount.toString(),
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

  Widget priceBreakUpContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.whiteColor),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: 20.0, vertical: AppSizes.size20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppConstString.priceBreakUp,
                    style: AppTextStyle.bold16,
                  ),
                  Text(
                    'AED ' + model.productModel.pricesRetailAmount.toString(),
                    style: AppTextStyle.bold18,
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.size10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppConstString.convenienceFee,
                    style: AppTextStyle.regular12,
                  ),
                  Text(
                    'AED ' +
                        (model.bounzApply
                            ? '0'
                            : '${model.productModel.convesFees}'),
                    style: AppTextStyle.semiBold14,
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.size10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppConstString.usedBounz,
                    style: AppTextStyle.regular12,
                  ),
                  Text(
                    model.bounzApply
                        ? 'BOUNZ ' +
                            model.productModel.requiredPoints.toString()
                        : '0',
                    style: AppTextStyle.semiBold14,
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.size10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppConstString.totalPayable,
                    style: AppTextStyle.regular12,
                  ),
                  Text(
                    'AED ' +
                        (model.bounzApply
                            ? '0'
                            : (model.productModel.totalAmount ?? 0)
                                .toStringAsFixed(2)),
                    style: AppTextStyle.semiBold14,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget payNowButtonWidget() {
    return Column(
      children: [
        Center(
          child: PrimaryButton(
            text: AppConstString.payNow,
            onTap: () {
              final properties = MoEProperties();
              properties
                  .addAttribute(TriggeringCondition.screenName, "Checkout")
                  .addAttribute(TriggeringCondition.productType, "Pay Bills")
                  .addAttribute(TriggeringCondition.productDetails,
                      model.productModel.productType)
                  .addAttribute(TriggeringCondition.paymentType,
                      model.bounzApply ? "Pay with bounz" : "Credit/Debit")
                  .addAttribute(TriggeringCondition.paymentMethod,
                      model.bounzApply ? "Pay with bounz" : "Credit/Debit")
                  .addAttribute(TriggeringCondition.totalAmount,
                      model.productModel.totalAmount)
                  .addAttribute(TriggeringCondition.amountPayedbyBounz,
                      model.bounzApply ? true : false)
                  .addAttribute(TriggeringCondition.amountPayedbycash, true)
                  .setNonInteractiveEvent();
              MoenageManager.logEvent(
                MoenageEvent.checkout,
                properties: properties,
              );
              widget.presenter.purchaseProduct(context);
            },
          ),
        ),
        const SizedBox(
          height: AppSizes.size10,
        ),
      ],
    );
  }
}
