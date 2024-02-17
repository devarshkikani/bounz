import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/constants/enum.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/modules/payment/payment_details/payment_detail_model.dart';
import 'package:bounz_revamp_app/modules/payment/payment_details/payment_details_view.dart';
import 'package:moengage_flutter/properties.dart';

class PaymentDetailsPresenter {
  void useBounz() {}

  void puchaseVoucher(BuildContext context) {}

  set updateModel(PaymentDetailsView paymentDetailsView) {}
}

class BasicPaymentDetailsPresenter implements PaymentDetailsPresenter {
  late PaymentDetailsView view;
  late PaymentDetailsModel model;

  BasicPaymentDetailsPresenter({
    required int giftcardId,
    required num price,
    required String supplierCode,
    required String giftCategoryName,
    required int pointBalance,
    required num redeemptionRate,
    required String image,
    required String name,
    required num payBounz,
    required String earnUpTo,
    required String currency,
  }) {
    view = PaymentDetailsView();
    model = PaymentDetailsModel(
      redeemptionRate: redeemptionRate,
      price: price,
      bounzApply: false,
      giftCategory: giftCategoryName,
      giftcardId: giftcardId,
      giftFor: GiftFor.mySelf,
      supplierCode: supplierCode,
      payBounz: payBounz,
      currency: currency,
      earnUpTo: earnUpTo,
      image: image,
      name: name,
      totalPoints: pointBalance,
    );
  }

  @override
  void useBounz() {
    model.bounzApply = !model.bounzApply;
    view.refreshModel(model);
  }

  @override
  Future<void> puchaseVoucher(BuildContext context) async {
    UserInformation appUser = GlobalSingleton.userInformation;
    Map<String, dynamic> data = {
      "giftcard_id": model.giftcardId,
      "denomination_amount": model.price,
      "amount": model.price,
      "purchase_type": model.bounzApply ? "redemption" : "accrual",
      "pay_by_points": model.bounzApply ? model.payBounz : 0,
      "pay_by_cash": model.price,
      "supplier_code": model.supplierCode,
      "mode_of_delivery": "both",
      "title": 'mr',
      "customer_first_name": appUser.firstName,
      "customer_last_name": appUser.lastName,
      "customer_email": appUser.email,
      "customer_mobile": appUser.mobileNumber,
      "logged_in": 1,
      "quantity": 1,
      "channel": "mobile",
      "membership_no": appUser.membershipNo,
    };

    if (model.giftFor == GiftFor.friend) {
      data.addAll(model.friendData ?? {});
    } else {
      late String receiverCountry;
      if (appUser.nationality == null || appUser.nationality!.isEmpty) {
        receiverCountry = "United Arab Emirates";
      } else {
        receiverCountry =
            appUser.nationality![0].name ?? 'United Arab Emirates';
      }
      data.addAll({
        "receiver_first_name": appUser.firstName,
        "receiver_last_name": appUser.lastName,
        "receiver_email": appUser.email,
        "receiver_mobile": appUser.mobileNumber,
        "receiver_country_code": appUser.countryCode,
        "receiver_country": receiverCountry,
        "receiver_pincode": appUser.pinCode ?? 0,
        "receiver_designation": appUser.employmentType.toString(),
      });
    }

    Map<String, dynamic>? response =
        await NetworkDio.postGiftVoucherDioHttpMethod(
      url: ApiPath.giftCardEndPoint + ApiPath.purchaseVoucher,
      data: data,
      context: context,
    );
    if (response != null) {
      if (response['code'] == 'trnx_0002') {
        Map<String, dynamic> data = {
          'transaction_id': response['objects']['transaction_id'],
          'url': response['objects']['pg_order']['url'],
        };
        MoenageManager.logScreenEvent(name: 'Payment Web View');

        AutoRouter.of(context).push(
          PaymentWebviewScreenRoute(
            data: data,
            index: 4,
            amount: model.price.toString(),
          ),
        );
      } else if (response['code'] == "trnx_0010") {
        final properties = MoEProperties();
        properties
            .addAttribute(TriggeringCondition.transactionId,
                response['objects']['transaction_id'])
            .addAttribute(TriggeringCondition.paymentMethod, 'Bounz')
            .addAttribute(TriggeringCondition.amount, model.price.toString())
            .addAttribute(TriggeringCondition.purchaseItem, 'Gift Voucher')
            .setNonInteractiveEvent();
        MoenageManager.logEvent(
          MoenageEvent.purchase,
          properties: properties,
        );
        getProfileData(context);
      } else {
        NetworkDio.showError(
          title: 'Error',
          errorMessage: response['message'],
          context: context,
        );
      }
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
      GlobalSingleton.userInformation = UserInformation.fromJson(
        response['data']['values'][0],
      );
      StorageManager.setStringValue(
        key: AppStorageKey.userInformation,
        value: userInformationToJson(GlobalSingleton.userInformation),
      );
      AutoRouter.of(context).push(
        PaymentSuccessfulRoute(
          pageIndex: 4,
        ),
      );
    }
  }

  @override
  set updateModel(PaymentDetailsView paymentDetailsView) {
    view = paymentDetailsView;
    view.refreshModel(model);
  }
}
