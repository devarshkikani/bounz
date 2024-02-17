import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/offer/offer_model.dart';
import 'package:bounz_revamp_app/models/outlet/outlet_detail_model.dart';
import 'package:bounz_revamp_app/models/partner/bounz_earn_model.dart';
import 'package:bounz_revamp_app/models/partner/new_partner_detail_model.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/utils/otp_encryption.dart';
import 'package:bounz_revamp_app/utils/validator.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/widgets/my_behavior.dart';
import 'package:bounz_revamp_app/widgets/otp_text_form_field.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:moengage_flutter/properties.dart';

@RoutePage()
class EarnBounzScreen extends StatefulWidget {
  final int? selectedIndex;
  final NewPartnerDetailModel? dataList;
  final bool? isOffers;
  final OfferModel? offerModel;
  final OutletDetailModel? outletDetailModel;
  const EarnBounzScreen({
    Key? key,
    required this.isOffers,
    this.selectedIndex,
    this.dataList,
    this.offerModel,
    this.outletDetailModel,
  }) : super(key: key);

  @override
  State<EarnBounzScreen> createState() => _EarnBounzScreenState();
}

class _EarnBounzScreenState extends State<EarnBounzScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController amount = TextEditingController();
  final TextEditingController thresholdPIN = TextEditingController();
  final TextEditingController pin = TextEditingController();
  final TextEditingController invoice = TextEditingController();
  final TextEditingController cashierID = TextEditingController();
  final TextEditingController category = TextEditingController();
  List<PartnerCategory> categoryList = [];
  PartnerCategory? selectedCategory;
  int currentBalance = 0;
  String? validPIN;
  String? validThresholdPIN;
  int thresholdAmount = 0;
  double? redemptionRate;
  String titleOfCashier = 'Cashier ID';
  bool isShowCategories = true;
  bool isShowCashier = true;
  bool isShowInvoice = true;

  @override
  void initState() {
    super.initState();
    currentBalance =
        int.parse(GlobalSingleton.userInformation.pointBalance.toString());

    if (widget.isOffers == true) {
      validPIN = widget.outletDetailModel!.offers![0].offerPin;
      isShowCategories = false;
    } else {
      validPIN = OtpEncryption().decryptOTP(
          widget.dataList!.allBranches![widget.selectedIndex!].accrualPin
              .toString(),
          isRegistration: false);
      thresholdAmount = widget
              .dataList?.allBranches?[widget.selectedIndex!].thresholdAmount ??
          0;
      validThresholdPIN =
          widget.dataList?.allBranches?[widget.selectedIndex!].thresholdPin;

      redemptionRate = double.parse(widget.dataList?.redemptionRate ?? '0');
      categoryList = widget.dataList?.partnerCategories ?? [];
      isShowCashier =
          widget.dataList?.allBranches?[widget.selectedIndex!].isCashierId ??
              true;
      isShowInvoice =
          widget.dataList?.allBranches?[widget.selectedIndex!].isInvoiceNo ??
              true;
      isShowCategories =
          widget.dataList?.allBranches?[widget.selectedIndex!].showCategories ??
              true;
      titleOfCashier = widget.dataList?.brandStaffKey ?? 'Cashier ID';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundColor,
        child: AppBackGroundWidget(
          child: Form(
            key: _formkey,
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
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
                      AppConstString.collectBounz.toUpperCase(),
                      style:
                          AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
                    ),
                    const SizedBox(
                      height: AppSizes.size20,
                    ),
                    amountWidget(),
                    pinWidget(),
                    if (isShowInvoice) invoiceWidget(),
                    if (isShowCashier) cashierIdWidget(),
                    if (isShowCategories && categoryList.isNotEmpty)
                      categoriesWidget(),
                    const SizedBox(
                      height: AppSizes.size40,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: PrimaryButton(
                        showShadow: true,
                        text: AppConstString.submit,
                        onTap: () {
                          if (pin.text.length == 4 &&
                              validPIN == pin.text.trim()) {
                            if (_formkey.currentState!.validate()) {
                              if (widget.isOffers == true) {
                                offerSubmit();
                              } else {
                                if (thresholdAmount >
                                    double.parse(amount.text.trim())) {
                                  partnerSubmit();
                                } else {
                                  thresholdAlert(context);
                                }
                              }
                            }
                          } else {
                            NetworkDio.showWarning(
                              context: context,
                              message: widget.isOffers == true
                                  ? 'Incorrect Offer PIN'
                                  : 'Incorrect Outlet PIN.',
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.size22,
                    ),
                    Center(
                      child: Text(
                        AppConstString.needHelp,
                        style: AppTextStyle.bold16,
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.size20,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: AppSizes.size30),
                        child: RoundedBorderButton(
                          text: AppConstString.cntSupport,
                          tColor: AppColors.btnBlueColor,
                          bColor: AppColors.btnBlueColor,
                          onTap: () {
                            MoenageManager.logScreenEvent(name: 'Help Support');
                            final properties = MoEProperties();
                            MoenageManager.logEvent(
                              MoenageEvent.contactSupport,
                              properties: properties,
                            );
                            AutoRouter.of(context)
                                .push(HelpSupportScreenRoute());
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget amountWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstString.enterAmtToCollectBounz,
          style: AppTextStyle.bold16,
        ),
        const SizedBox(
          height: 10.0,
        ),
        NumberWidget(
          maxLength: 15,
          controller: amount,
          prefixIconConstraints: BoxConstraints.loose(const Size(60, 50)),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Center(
              child: Text(
                'AED',
                style: AppTextStyle.bold18,
              ),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) => Validators.validateText(value, 'Amount'),
        ),
      ],
    );
  }

  Widget pinWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppSizes.size20,
        ),
        Text(
          widget.isOffers == true ? 'Enter Offer PIN' : AppConstString.enterPIN,
          style: AppTextStyle.bold16,
        ),
        const SizedBox(
          height: 10.0,
        ),
        OtpTextField(
          numberOfFields: 4,
          onSubmit: (value) {
            pin.text = value;
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget invoiceWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppSizes.size20,
        ),
        Text(
          AppConstString.invoiceNumber,
          style: AppTextStyle.bold16,
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextFormFieldWidget(
          labelText: AppConstString.invoiceNoPlaceHolder,
          maxLength: 20,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]'))
          ],
          controller: invoice,
          validator: (value) =>
              Validators.validateText(value, 'Invoice Number'),
        ),
      ],
    );
  }

  Widget cashierIdWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppSizes.size20,
        ),
        Text(
          'Enter $titleOfCashier',
          style: AppTextStyle.bold16,
        ),
        const SizedBox(
          height: 10.0,
        ),
        TextFormFieldWidget(
          maxLength: 20,
          labelText: titleOfCashier,
          controller: cashierID,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9]'))
          ],
          validator: (value) => Validators.validateText(value, titleOfCashier),
        ),
      ],
    );
  }

  Widget categoriesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: AppSizes.size20,
        ),
        Text(
          'Select Category',
          style: AppTextStyle.bold16,
        ),
        const SizedBox(
          height: 10.0,
        ),
        InkWell(
          onTap: () {
            selectCategory();
          },
          child: Container(
            height: AppSizes.size56,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.only(left: AppSizes.size20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.size30),
              color: AppColors.textFieldColor.withOpacity(.23),
            ),
            child: selectedCategory != null
                ? Html(
                    data: selectedCategory?.categoryName.toString(),
                  )
                : Text(
                    'Select Category',
                    style: AppTextStyle.regular18.copyWith(),
                  ),
          ),
        ),
      ],
    );
  }

  void selectCategory() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.secondaryContainerColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: AppSizes.size20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: SizedBox(
            height: 350,
            width: MediaQuery.of(ctx).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppSizes.size16),
                  child: Text(
                    'Select Category',
                    style: AppTextStyle.bold16.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: categoryList.length,
                    physics: const BouncingScrollPhysics(),
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemBuilder: (BuildContext ctx, int i) {
                      return InkWell(
                        onTap: () {
                          AutoRouter.of(context).pop(ctx);
                          selectedCategory = categoryList[i];
                          category.text = selectedCategory?.categoryName ?? '';
                          setState(() {});
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.size16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Html(
                                data: categoryList[i].categoryName.toString(),
                              ),
                              const SizedBox(
                                height: AppSizes.size4,
                              ),
                              Html(
                                data: categoryList[i].categoryTrm.toString(),
                              ),
                              const SizedBox(
                                height: AppSizes.size10,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> partnerSubmit() async {
    Map<String, dynamic> reqbody = {
      'customer_id': GlobalSingleton.userInformation.membershipNo,
      'outlet_code':
          widget.dataList?.allBranches![widget.selectedIndex!].outletCode ?? '',
      'outlet_pin': OtpEncryption().encryptOTP(pin.text.trim()),
      'merchant_code': widget.dataList?.merchantCode ?? '',
      'total_amount': amount.text.trim(),
      'trxn_type': 'accrual',
      'cashier_id': cashierID.text.trim(),
      'invoice_no': invoice.text.trim(),
      'lat': GlobalSingleton.currentPosition?.latitude,
      'long': GlobalSingleton.currentPosition?.longitude,
      'threshold_pin': validThresholdPIN,
      'earn_rate': selectedCategory != null ? selectedCategory!.earnRate : '',
      'partner_category':
          selectedCategory != null ? selectedCategory!.categoryCode : '',
    };

    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.pinBasedAR,
      context: context,
      data: reqbody,
    );

    if (response != null) {
      if (response['status'] == true) {
        BounzEarnModel model = BounzEarnModel.fromJson(
          response['data']['values'],
        );
        MoenageManager.logScreenEvent(name: 'Store Earned Success');
        final properties = MoEProperties();
        properties
            .addAttribute(
                TriggeringCondition.bounzCollected, amount.text.trim())
            .addAttribute(TriggeringCondition.screenName, "Earn Bounz")
            .addAttribute(
                TriggeringCondition.invoiceNumber, invoice.text.trim())
            .addAttribute(TriggeringCondition.cashierId, cashierID.text.trim())
            .setNonInteractiveEvent();
        MoenageManager.logEvent(
          MoenageEvent.pinCollectBounz,
          properties: properties,
        );
        AutoRouter.of(context).push(
          StoreRedeemSuccessScreenRoute(
            bounzEarnModel: model,
            points: model.pointsEarned.toString(),
            title: 'Earned',
          ),
        );
      } else {
        if (response['message'] == 'User not within the required proximity') {
          MoenageManager.logScreenEvent(name: 'User Far From Stores');
          AutoRouter.of(context)
              .push(UserFarFromStoreScreenRoute(title: 'EARN BOUNZ'));
        } else {
          NetworkDio.showError(
            errorMessage: response['message'],
            title: 'ERROR',
            context: context,
          );
        }
      }
    }
  }

  Future<void> thresholdAlert(BuildContext context) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext ctx) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSizes.size10)),
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: AppSizes.size12,
              horizontal: AppSizes.size16,
            ),
            height: 270,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage(
                  AppAssets.backgroundLayer,
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              children: <Widget>[
                Text(
                  widget.isOffers == true
                      ? 'Enter Offer PIN'
                      : "Please ask Store Manager to enter their PIN",
                  style: AppTextStyle.bold16.copyWith(
                    color: AppColors.blackColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: AppSizes.size30,
                ),
                OtpTextField(
                  numberOfFields: 4,
                  onSubmit: (value) {
                    thresholdPIN.text = value;
                    setState(() {});
                  },
                ),
                const SizedBox(
                  height: AppSizes.size40,
                ),
                Align(
                  alignment: Alignment.center,
                  child: PrimaryButton(
                    showShadow: true,
                    text: AppConstString.submit,
                    onTap: () {
                      AutoRouter.of(ctx).pop();
                      if (thresholdPIN.text.length == 4 &&
                          validThresholdPIN ==
                              OtpEncryption()
                                  .encryptOTP(thresholdPIN.text.trim())) {
                        partnerSubmit();
                      } else {
                        NetworkDio.showWarning(
                          context: context,
                          message: widget.isOffers == true
                              ? 'Incorrect Offer PIN'
                              : 'Incorrect Manager PIN.',
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: AppSizes.size20,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> offerSubmit() async {
    Map<String, dynamic> reqbody = {
      "customer_id": GlobalSingleton.userInformation.membershipNo,
      "offer_code": widget.offerModel?.ofrdCode,
      "offer_pin": pin.text.trim(),
      "merchant_code": widget.outletDetailModel!.merchantCode,
      "outlet_code": widget.outletDetailModel!.outletCode,
      "total_amount": amount.text.trim(),
      "offer_limit": widget.outletDetailModel!.offers![0].offerLimit,
      "trxn_type": "accrual",
      "cashier_id": cashierID.text.trim(),
      "invoice_no": invoice.text.trim(),
      'lat': GlobalSingleton.currentPosition?.latitude,
      'long': GlobalSingleton.currentPosition?.longitude,
    };

    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.offerRedeem,
      context: context,
      data: reqbody,
    );

    if (response != null) {
      if (response['status'] == true) {
        BounzEarnModel model = BounzEarnModel.fromJson(
          response['data']['values'],
        );
        AutoRouter.of(context).push(
          StoreRedeemSuccessScreenRoute(
            bounzEarnModel: model,
            points: model.pointsEarned.toString(),
            title: 'Earned',
          ),
        );
      } else {
        if (response['message'] == 'User not within the required proximity') {
          AutoRouter.of(context).push(UserFarFromStoreScreenRoute(
            title: 'EARN BOUNZ',
          ));
        } else {
          NetworkDio.showError(
            errorMessage: response['message'],
            title: 'ERROR',
            context: context,
          );
        }
      }
    }
  }
}
