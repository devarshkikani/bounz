import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/models/pay_bills/product_model.dart';
import 'package:bounz_revamp_app/modules/bills/bill_screen_presenter.dart';
import 'package:bounz_revamp_app/modules/bills/bills_screen_model.dart';
import 'package:bounz_revamp_app/modules/bills/bills_screen_view.dart';
import 'package:bounz_revamp_app/modules/pay_bills/paybill_checkout/checkout_presenter.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';

@RoutePage()
class BillsScreen extends StatefulWidget {
  final ProductModel productModel;
  final num? redemptionRate;
  final String actNumberController;
  final String phoneController;
  final String countryCode;
  final String accountQualifier;
  const BillsScreen({
    Key? key,
    this.redemptionRate,
    required this.countryCode,
    required this.productModel,
    required this.accountQualifier,
    required this.actNumberController,
    required this.phoneController,
  }) : super(key: key);

  @override
  State<BillsScreen> createState() => _BillsScreenState();
}

class _BillsScreenState extends State<BillsScreen> implements BillsScreenView {
  bool outstandingBill = false;
  bool partialPaidBill = false;
  late BillsScreenPresenter presenter;
  late BillScreenModel model;
  int price = 50;
  @override
  void initState() {
    super.initState();
    presenter = BasicBillsScreenPresenter();
    presenter.updateView = this;
    presenter.getStatmentData(
      context: context,
      productModel: widget.productModel,
      accountQualifier: widget.accountQualifier,
      actNumberController: widget.actNumberController,
      phoneController: widget.phoneController,
      countryCode: widget.countryCode,
    );
  }

  @override
  void refreshModel(BillScreenModel billScreenModel) {
    if (mounted) {
      setState(() {
        model = billScreenModel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
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
              'PAY ' + widget.productModel.serviceName.toString() + ' BILL',
              style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
            ),
            const SizedBox(
              height: AppSizes.size14,
            ),
            model.result == null
                ? const SizedBox()
                : model.result!.isEmpty
                    ? Expanded(
                        child: Center(
                          child: Text(
                            'Bill Not Found',
                            style: AppTextStyle.bold22.copyWith(
                              color: AppColors.brownishColor,
                            ),
                          ),
                        ),
                      )
                    : Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.productModel.productId == 46740
                                      ? 'Current Balance'
                                      : AppConstString.outstandingBill,
                                  style: AppTextStyle.semiBold18,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.size20,
                            ),
                            ListView.builder(
                              itemCount: model.result!.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return outstandingBillsWidget(index);
                              },
                            ),
                            const SizedBox(
                              height: AppSizes.size40,
                            ),
                            if (widget.productModel.productId == 46740)
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        price = model.result![0].balance!.amount
                                                ?.toInt() ??
                                            50;
                                        outstandingBill = !outstandingBill;
                                        partialPaidBill = false;
                                      });
                                    },
                                    child: Icon(
                                      outstandingBill
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color: AppColors.whiteColor,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: AppSizes.size10,
                                  ),
                                  Text(
                                    'Top Up',
                                    style: AppTextStyle.semiBold18,
                                  ),
                                ],
                              ),
                            if (widget.productModel.productId == 46740 &&
                                outstandingBill)
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: 10.0,
                                    minThumbSeparation: 2,
                                    thumbColor: Colors.white,
                                    thumbShape: const RoundSliderThumbShape(
                                      enabledThumbRadius: 12.0,
                                    ),
                                    overlayColor: Colors.deepPurple,
                                    inactiveTickMarkColor: Colors.amber,
                                    inactiveTrackColor: Colors.green,
                                    valueIndicatorColor: AppColors.btnBlueColor,
                                    valueIndicatorTextStyle:
                                        AppTextStyle.semiBold16,
                                  ),
                                  child: Slider(
                                    min: 50.0,
                                    max: 1000.0,
                                    divisions: 19,
                                    value: price.toDouble(),
                                    activeColor:
                                        AppColors.primaryContainerColor,
                                    inactiveColor: AppColors.whiteColor,
                                    label: '${price.round()}',
                                    onChanged: (value) {
                                      price = value.toInt();
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            if (widget.productModel.productId == 46740 &&
                                outstandingBill)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'AED 50',
                                    style: AppTextStyle.semiBold14.copyWith(
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                  Text(
                                    'AED 1000',
                                    style: AppTextStyle.semiBold14.copyWith(
                                      color: AppColors.blackColor,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
            model.result == null
                ? const SizedBox()
                : model.result!.isEmpty
                    ? const SizedBox()
                    : Container(
                        height: 120,
                        color: Colors.transparent,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (widget.productModel.productId == 46740 &&
                                price >= 50)
                              Text(
                                'AED ${price.toDouble()}',
                                style: AppTextStyle.bold14,
                              ),
                            const SizedBox(
                              height: AppSizes.size10,
                            ),
                            proceedBtnWidget(),
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

  Widget outstandingBillsWidget(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          price = model.result![0].balance!.amount?.toInt() ?? 50;
          outstandingBill = !outstandingBill;
          partialPaidBill = false;
        });
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(
            vertical: AppSizes.size20, horizontal: AppSizes.size20),
        decoration: BoxDecoration(
            color: AppColors.primaryContainerColor,
            borderRadius: BorderRadius.circular(15.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.productModel.productId != 46740)
                    Icon(
                      outstandingBill
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: AppColors.whiteColor,
                    ),
                  if (widget.productModel.productId != 46740)
                    const SizedBox(
                      width: AppSizes.size10,
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GlobalSingleton.userInformation.firstName.toString(),
                          style: AppTextStyle.semiBold14.copyWith(
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(
                          height: AppSizes.size10,
                        ),
                        Text(
                          "Due  ${DateTime.parse(
                            model.result![index].dates!.statement.toString(),
                          ).ymddateFormatWithoutDay}",
                          style: AppTextStyle.semiBold12,
                        ),
                        const SizedBox(
                          height: AppSizes.size6,
                        ),
                        widget.phoneController.isNotEmpty
                            ? Text(
                                "${widget.phoneController.toString()} ",
                                style: AppTextStyle.semiBold12,
                              )
                            : Text(
                                "${widget.actNumberController.toString()} ",
                                style: AppTextStyle.semiBold12,
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              "${model.result![index].balance!.unit.toString()}  ${model.result![index].balance!.amount.toString()}",
              style: AppTextStyle.bold18,
            ),
          ],
        ),
      ),
    );
  }

  Widget proceedBtnWidget() {
    return Center(
      child: PrimaryButton(
        text: AppConstString.proceed,
        tColor: onTapValid()
            ? AppColors.whiteColor
            : AppColors.whiteColor.withOpacity(0.5),
        bColor: onTapValid()
            ? AppColors.btnBlueColor
            : AppColors.btnBlueColor.withOpacity(0.6),
        onTap: onTapValid()
            ? () {
                if (num.parse(model.result![0].balance!.pricesRetailAmountMin
                            .toString()) <=
                        price &&
                    num.parse(model.result![0].balance!.pricesRetailAmountMax
                            .toString()) >=
                        price) {
                  if (widget.productModel.productId == 46740) {
                    getBounzCalculation();
                  } else {
                    widget.productModel.totalAmount = double.parse(
                        model.result![0].balance!.totalAmount.toString());
                    widget.productModel.pricesRetailAmount =
                        model.result![0].balance!.amount.toString();
                    widget.productModel.convesFees =
                        model.result![0].balance!.convesFees;
                    widget.productModel.requiredPoints = int.parse(
                        model.result![0].balance!.requiredPoints.toString());
                    widget.productModel.earnPoint = int.parse(
                        model.result![0].balance!.earnPoint.toString());
                    redirectToNext();
                  }
                } else {
                  NetworkDio.showError(
                    title: 'Error',
                    context: context,
                    errorMessage: "Requested product amount is out of range",
                  );
                }
              }
            : () {},
      ),
    );
  }

  Future getBounzCalculation() async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.dtOneEndPoint + ApiPath.calPoint,
      data: {
        "amount": price,
      },
      context: context,
    );
    if (response != null) {
      widget.productModel.totalAmount =
          double.parse(response['values'][0]['total_amount'].toString());
      widget.productModel.pricesRetailAmount = price.toString();
      widget.productModel.requiredPoints =
          response['values'][0]['required_points'];
      widget.productModel.earnPoint = response['values'][0]['earn_point'];
      widget.productModel.convesFees = response['values'][0]['conves_fees'];

      redirectToNext();
    }
  }

  void redirectToNext() {
    AutoRouter.of(context).push(
      CheckoutScreenRoute(
        presenter: BasicCheckoutPresenter(
          redemptionRate: widget.redemptionRate,
          countryCode: widget.countryCode,
          productModel: widget.productModel,
          phoneNumber:
              widget.phoneController != '' ? widget.phoneController : null,
          accountNumber: widget.actNumberController != ''
              ? widget.actNumberController
              : null,
          accountQualifier:
              widget.accountQualifier != '' ? widget.accountQualifier : null,
          isFromRange: true,
        ),
      ),
    );
  }

  bool onTapValid() {
    return outstandingBill || partialPaidBill
        ? widget.productModel.productId != 46740
            ? true
            : price >= 50
                ? true
                : false
        : false;
  }
}
