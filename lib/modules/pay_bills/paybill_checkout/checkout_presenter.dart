import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/models/pay_bills/product_model.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/modules/pay_bills/paybill_checkout/checkout_view.dart';
import 'package:bounz_revamp_app/modules/pay_bills/paybill_checkout/checkout_model.dart';
import 'package:moengage_flutter/properties.dart';

class CheckoutPresenter {
  Future purchaseProduct(BuildContext context) async {}
  void applyBounzClick(BuildContext context) {}
  set updateView(CheckoutView checkoutView) {}
}

class BasicCheckoutPresenter implements CheckoutPresenter {
  late CheckoutView view;
  late CheckoutModel model;
  BasicCheckoutPresenter({
    required ProductModel productModel,
    num? redemptionRate,
    // num? offerPloughbackFactor,
    // num? rpm,
    String? phoneNumber,
    String? countryCode,
    String? accountNumber,
    String? accountQualifier,
    bool? isFromRange,
  }) {
    view = CheckoutView();
    model = CheckoutModel(
      countryCode: countryCode,
      phoneNumber: phoneNumber,
      accountNumber: accountNumber,
      accountQualifier: accountQualifier,
      productModel: productModel,
      bounzApply: false,
      // offerPloughbackFactor: offerPloughbackFactor,
      redemptionRate: redemptionRate,
      // rpm: rpm,
      isFromRange: isFromRange,
    );
  }

  @override
  set updateView(CheckoutView checkoutView) {
    view = checkoutView;
    view.refreshModel(model);
  }

  @override
  void applyBounzClick(BuildContext context) {
    if (GlobalSingleton.userInformation.pointBalance! >
        model.productModel.requiredPoints!) {
      model.bounzApply = !model.bounzApply;
      view.refreshModel(model);
    }
  }

  @override
  Future purchaseProduct(BuildContext context) async {
    UserInformation appUser = GlobalSingleton.userInformation;
    Map<String, dynamic> data = {
      "membership_no": appUser.membershipNo,
      "product_id": model.productModel.productId,
      "amount": num.parse(model.productModel.pricesRetailAmount.toString()),
      "trans_type": model.bounzApply ? "redemption" : "accural"
    };

    if (model.phoneNumber != null) {
      data['mobile_number'] =
          model.countryCode.toString() + model.phoneNumber.toString();
    }
    if (model.isFromRange == true) {
      data['account_number'] = model.phoneNumber.toString();
    }
    if (model.accountQualifier != null) {
      data['account_qualifier'] = model.accountQualifier;
    }
    if (model.accountNumber != null) {
      data['account_number'] = model.accountNumber;
    }

    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.dtOneEndPoint + ApiPath.createTransaction,
      data: data,
      context: context,
    );
    if (response != null) {
      if (response['status'] == true) {
        if (model.bounzApply) {
          final properties = MoEProperties();
          properties
              .addAttribute(TriggeringCondition.transactionId,
                  response['values']['transaction_id'])
              .addAttribute(TriggeringCondition.paymentMethod, 'Bounz')
              .addAttribute(TriggeringCondition.amount,
                  model.productModel.totalAmount.toString())
              .addAttribute(TriggeringCondition.purchaseItem, 'Pay Bills')
              .setNonInteractiveEvent();
          MoenageManager.logEvent(
            MoenageEvent.purchase,
            properties: properties,
          );
          getProfileData(context, response['values']);
        } else {
          MoenageManager.logScreenEvent(name: 'Payment Web View');
          AutoRouter.of(context).push(
            PaymentWebviewScreenRoute(
              data: response['values'],
              index: 2,
              amount: model.productModel.totalAmount.toString(),
            ),
          );
        }
      } else {
        NetworkDio.showError(
          title: 'Error',
          errorMessage: 'Something went wrong',
          context: context,
        );
      }
    }
  }

  Future getProfileData(BuildContext context, fixedValueData) async {
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.getProfile,
      context: context,
      queryParameters: {
        'membership_no': GlobalSingleton.userInformation.membershipNo,
      },
    );
    if (response != null) {
      GlobalSingleton.userInformation = UserInformation.fromJson(
        response['data']['values'][0],
      );
      StorageManager.setStringValue(
        key: AppStorageKey.userInformation,
        value: userInformationToJson(GlobalSingleton.userInformation),
      );
      AutoRouter.of(context).push(
        PaymentSuccessfulRoute(
          pageIndex: 2,
          fixedValueData: fixedValueData,
        ),
      );
    }
  }
}
