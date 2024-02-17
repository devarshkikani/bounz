import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/pay_bills/operator_model.dart';
import 'package:bounz_revamp_app/models/pay_bills/product_model.dart';
import 'package:bounz_revamp_app/models/pay_bills/service_model.dart';
import 'package:bounz_revamp_app/modules/pay_bills/operators/operator_list_presenter.dart';
import 'package:bounz_revamp_app/modules/pay_bills/paybill_checkout/checkout_presenter.dart';
import 'package:bounz_revamp_app/modules/pay_bills/select_product/select_product_presenter.dart';
import 'package:bounz_revamp_app/utils/validator.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:moengage_flutter/properties.dart';

import '../countries/countries_list_presenter.dart';

@RoutePage()
class AddDetailsScreen extends StatefulWidget {
  final ProductModel productModel;
  final Map<String, dynamic> country;
  final String? phoneNumber;
  final String? accountNumbe;
  final String? accountQualifier;
  final Map<String, dynamic> calulationDetails;
  const AddDetailsScreen({
    Key? key,
    required this.productModel,
    required this.calulationDetails,
    required this.country,
    required this.phoneNumber,
    required this.accountNumbe,
    required this.accountQualifier,
  }) : super(key: key);

  @override
  State<AddDetailsScreen> createState() => _AddDetailsScreenState();
}

class _AddDetailsScreenState extends State<AddDetailsScreen> {
  TextEditingController countryController = TextEditingController();
  TextEditingController operatorController = TextEditingController();
  TextEditingController productController = TextEditingController();
  TextEditingController actNumberController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController accountQualifier = TextEditingController();
  GlobalKey<FormState> key = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    countryController.text = widget.productModel.country.toString();
    operatorController.text = widget.productModel.operatorName.toString();
    productController.text = widget.productModel.name.toString();
    if (widget.phoneNumber != null) {
      phoneController.text = widget.phoneNumber.toString();
    }
    if (widget.accountQualifier != null) {
      accountQualifier.text = widget.accountQualifier.toString();
    }
    if (widget.accountNumbe != null) {
      actNumberController.text = widget.accountNumbe.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AutoRouter.of(context).pushAndPopUntil(MainHomeScreenRoute(index: 2),
            predicate: (_) => false);
        return true;
      },
      child: Scaffold(
        body: AppBackGroundWidget(
          child: Form(
            key: key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    AutoRouter.of(context).pushAndPopUntil(
                        MainHomeScreenRoute(index: 2),
                        predicate: (_) => false);
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
                  height: AppSizes.size20,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: bodyView(),
                  ),
                ),
                proceedButton()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bodyView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFieldWithIcon(
          lableText: AppConstString.country,
          controller: countryController,
          suffixOnTap: () {
            MoenageManager.logScreenEvent(name: 'Countries List');

            AutoRouter.of(context).push(
              CountriesListScreenRoute(
                countryListPresenter: BasicCountriesListPresenter(
                  ServiceModel(
                    serviceName: widget.productModel.serviceName,
                    serviceId: widget.productModel.serviceId,
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(
          height: AppSizes.size20,
        ),
        textFieldWithIcon(
          lableText: 'Operator',
          controller: operatorController,
          suffixOnTap: () {
            MoenageManager.logScreenEvent(name: 'Operator List');

            AutoRouter.of(context).push(
              OperatorListScreenRoute(
                presenter: BasicOpreterListPresenter(
                  country: widget.country,
                  serviceModel: ServiceModel(
                    serviceName: widget.productModel.serviceName,
                    serviceId: widget.productModel.serviceId,
                  ),
                ),
              ),
            );
          },
        ),
        if (!productController.text.contains('Open_Range'))
          const SizedBox(
            height: AppSizes.size20,
          ),
        if (!productController.text.contains('Open_Range'))
          textFieldWithIcon(
            lableText: 'Selected Plan',
            controller: productController,
            suffixOnTap: () {
              MoenageManager.logScreenEvent(name: 'Select Product');

              AutoRouter.of(context).push(
                SelectProductScreenRoute(
                  presenter: BasicSelectProductPresenter(
                    operatorModel: OperatorModel(
                      country: widget.productModel.country.toString(),
                      isoCode: widget.productModel.isoCode.toString(),
                      operatorId: widget.productModel.operatorId,
                      operatorImgUrl: widget.productModel.operatorImgUrl,
                      operatorName: widget.productModel.operatorName,
                      serviceId: widget.productModel.serviceId,
                    ),
                    country: widget.country,
                    serviceModel: ServiceModel(
                      serviceName: widget.productModel.serviceName,
                      serviceId: widget.productModel.serviceId,
                    ),
                  ),
                ),
              );
            },
          ),
        const SizedBox(
          height: AppSizes.size20,
        ),
        if (widget.productModel.requiredCreditPartyIdentifierFields
                ?.contains('mobile_number') ==
            true)
          mobileNumberInputWidget(),
        if (widget.productModel.requiredCreditPartyIdentifierFields
                ?.contains('account_number') ==
            true)
          accountNumberWidget(),
        if (widget.productModel.requiredCreditPartyIdentifierFields
                ?.contains('account_qualifier') ==
            true)
          accountQualifierWidget(),
      ],
    );
  }

  Widget countryWidget() {
    return TextFormFieldWidget(
      controller: countryController,
      onTap: null,
      labelText: AppConstString.country,
      suffixIconConstraints: BoxConstraints.loose(
        const Size(53, 35),
      ),
      suffixIcon: GestureDetector(
        onTap: () {
          MoenageManager.logScreenEvent(name: 'Countried List');

          AutoRouter.of(context).push(
            CountriesListScreenRoute(
              countryListPresenter: BasicCountriesListPresenter(
                ServiceModel(
                  serviceName: widget.productModel.serviceName,
                  serviceId: widget.productModel.serviceId,
                ),
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: AppSizes.size8,
            right: AppSizes.size10,
          ),
          child: Text(
            AppConstString.change,
            style: AppTextStyle.bold12.copyWith(
              decoration: TextDecoration.underline,
              fontFamily: "Gilroy",
            ),
          ),
        ),
      ),
    );
  }

  Widget textFieldWithIcon({
    required TextEditingController controller,
    required String lableText,
    required Function() suffixOnTap,
  }) {
    return TextFormFieldWidget(
      controller: controller,
      onTap: null,
      labelText: lableText,
      suffixIconConstraints: BoxConstraints.loose(
        const Size(65, 35),
      ),
      suffixIcon: GestureDetector(
        onTap: suffixOnTap,
        child: Padding(
          padding: const EdgeInsets.only(
            right: AppSizes.size18,
          ),
          child: Text(
            AppConstString.change,
            style: AppTextStyle.bold12.copyWith(
              decoration: TextDecoration.underline,
              fontFamily: "Gilroy",
            ),
          ),
        ),
      ),
    );
  }

  Widget mobileNumberInputWidget() {
    return Column(
      children: [
        NumberWidget(
          controller: phoneController,
          maxLength: int.parse(widget.country['mobile_number_length']),
          validator: widget.productModel.serviceName == "Mobile"
              ? (value) => Validators.validateMobile(value,
                  mobileNumberLength:
                      int.parse(widget.country['mobile_number_length']))
              : null,
          hintText: AppConstString.mobileNo,
          hintStyle: AppTextStyle.regular16,
          prefixIconConstraints: BoxConstraints.loose(const Size(110, 50)),
          prefixIcon: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: AppSizes.size16,
                child: CircleAvatar(
                  radius: 15.0,
                  backgroundImage: NetworkImage(
                    widget.country['country_img_url'],
                  ),
                ),
              ),
              const SizedBox(
                width: AppSizes.size4,
              ),
              Text(
                '+${widget.country["countryCode"]}',
                style: AppTextStyle.semiBold16,
              ),
              const Icon(
                Icons.arrow_drop_down_sharp,
                color: AppColors.whiteColor,
              ),
              const SizedBox(
                width: AppSizes.size4,
              ),
              Container(
                height: AppSizes.size20,
                width: 1,
                color: AppColors.whiteColor,
              ),
            ],
          ),
        ),
        const SizedBox(
          height: AppSizes.size20,
        ),
      ],
    );
  }

  Widget accountNumberWidget() {
    return Column(
      children: [
        NumberWidget(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          labelText: "Account or Premise Number",
          maxLength: 20,
          controller: actNumberController,
          validator: (value) =>
              Validators.validateText(value, 'Account Number'),
        ),
        const SizedBox(
          height: AppSizes.size20,
        ),
      ],
    );
  }

  Widget accountQualifierWidget() {
    return Column(
      children: [
        NumberWidget(
          labelText: "Account Qualifier Number",
          controller: accountQualifier,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          validator: (value) =>
              Validators.validateText(value, 'Account Qualifier Number'),
        ),
        const SizedBox(
          height: AppSizes.size20,
        ),
      ],
    );
  }

  Widget proceedButton() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: AppSizes.size12,
          ),
          Center(
            child: PrimaryButton(
              onTap: () {
                if (key.currentState!.validate()) {
                  MoenageManager.logScreenEvent(name: 'Check Out');

                  final properties = MoEProperties();
                  properties
                      .addAttribute(TriggeringCondition.billType,
                          widget.productModel.serviceName)
                      .addAttribute(
                          TriggeringCondition.screenName, 'Add Detail')
                      .addAttribute(TriggeringCondition.serviceProvider,
                          widget.productModel.operatorName)
                      .addAttribute(TriggeringCondition.planSelected,
                          widget.productModel.name)
                      .addAttribute(
                          widget.productModel.serviceName == "Mobile"
                              ? TriggeringCondition.mobileNumber
                              : TriggeringCondition.accountNo,
                          widget.productModel.serviceName == "Mobile"
                              ? phoneController.text
                              : actNumberController.text)
                      .addAttribute(TriggeringCondition.invoiceAmount,
                          widget.productModel.totalAmount.toString())
                      .setNonInteractiveEvent();
                  MoenageManager.logEvent(
                    MoenageEvent.billInfo,
                    properties: properties,
                  );

                  if (widget.productModel.supportsStatementInquiry == "false" ||
                      widget.productModel.supportsStatementInquiry == null) {
                    AutoRouter.of(context).push(
                      CheckoutScreenRoute(
                        presenter: BasicCheckoutPresenter(
                          productModel: widget.productModel,
                          // offerPloughbackFactor: widget
                          //     .calulationDetails['offer_ploughback_factor'],
                          redemptionRate:
                              widget.calulationDetails['redemption_rate'],
                          // rpm: widget.calulationDetails['rpm'],
                          phoneNumber: phoneController.text != ''
                              ? phoneController.text
                              : null,
                          accountNumber: actNumberController.text != ''
                              ? actNumberController.text
                              : null,
                          accountQualifier: accountQualifier.text != ''
                              ? accountQualifier.text
                              : null,
                          countryCode: '+' + widget.country['countryCode'],
                        ),
                      ),
                    );
                  } else {
                    AutoRouter.of(context).push(
                      BillsScreenRoute(
                        redemptionRate:
                            widget.calulationDetails['redemption_rate'],
                        countryCode: '+' + widget.country['countryCode'],
                        productModel: widget.productModel,
                        accountQualifier: accountQualifier.text,
                        actNumberController: actNumberController.text,
                        phoneController: phoneController.text,
                      ),
                    );
                  }
                }
              },
              text: AppConstString.proceed,
              showShadow: true,
            ),
          ),
          const SizedBox(
            height: AppSizes.size30,
          ),
        ],
      ),
    );
  }
}
