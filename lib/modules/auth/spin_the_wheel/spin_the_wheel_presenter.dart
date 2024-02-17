import 'package:flutter/cupertino.dart';
import 'package:auto_route/auto_route.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/models/spin_wheel/wheel_details.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/models/spin_wheel/wheel_response.dart';
import 'package:bounz_revamp_app/modules/auth/spin_the_wheel/spin_the_wheel_view.dart';
import 'package:bounz_revamp_app/modules/auth/spin_the_wheel/spin_the_wheel_model.dart';

class SpinTheWheelPresenter {
  Future<void> spinTheWheelListDesign({required BuildContext context}) async {}
  Future<SpinData?> spinTheWheel(
      {required BuildContext context, required String spinCode}) async {
    return null;
  }

  void manageClick({required BuildContext context, required SpinData data}) {}
  set updateView(SpinTheWheelView value) {}
}

class BasicSpinTheWheelPresenter implements SpinTheWheelPresenter {
  late SpinWheelsModel model;
  late SpinTheWheelView view;

  BasicSpinTheWheelPresenter(bool isFromSplash, String apiKey, String apiValue,
      DataWheelDesign? data, bool showSheet) {
    view = SpinTheWheelView();
    model = SpinWheelsModel(
      isFromSplash: isFromSplash,
      apiKey: apiKey,
      apiValue: apiValue,
      spinData: data,
      showBottomSheet: showSheet,
    );
  }

  @override
  Future spinTheWheelListDesign({required BuildContext context}) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpSpinWheel(
      url: ApiPath.apiEndPoint + ApiPath.spinTheWheelDesign,
      context: context,
      data: {
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        model.apiKey: model.apiValue,
      },
    );
    if (response != null) {
      if (response['status'] == true) {
        model.spinData = DataWheelDesign.fromJson(response);
        GlobalSingleton.isWheelSpined = false;
      } else if (response['status'] == false) {
        model.showBottomSheet = true;
        GlobalSingleton.isWheelSpined = true;
      }
      view.refreshModel(model);
    }
  }

  Future getProfileData(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.getProfile,
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
    }
  }

  @override
  void manageClick({
    required BuildContext context,
    required SpinData data,
  }) {
    MoenageManager.logScreenEvent(
      name: model.apiKey != "type"
          ? 'SpinTheWheelVoucher'
          : model.isFromSplash
              ? 'RegistrationCompleteScreen'
              : 'SpinTheWheelDashboard',
    );

    voucherSpinFunction(
      context: context,
      data: data,
    );
  }

  void voucherSpinFunction({
    required BuildContext context,
    required SpinData data,
  }) {
    final properties = MoEProperties();
    bool isShowVoucher = false;
    if (data.values?.prizeType == "coupon") {
      isShowVoucher = true;
      properties
          .addAttribute(TriggeringCondition.winningSpoke, data.values?.spokeId)
          .addAttribute(
              TriggeringCondition.voucherName, data.values?.couponCode)
          .setNonInteractiveEvent();
    } else if (data.values!.prizeType == "better_luck") {
      properties
          .addAttribute(TriggeringCondition.winningSpoke, data.values?.spokeId)
          .addAttribute(TriggeringCondition.bounzEarned, data.values?.points)
          .addAttribute(TriggeringCondition.voucherName, data.values?.prizeType)
          .setNonInteractiveEvent();
    } else {
      properties
          .addAttribute(
              TriggeringCondition.bounzEarned, data.values?.points ?? '0')
          .addAttribute(TriggeringCondition.winningSpoke, data.values?.spokeId)
          .addAttribute(
              TriggeringCondition.spokeReward, data.values?.points ?? '0')
          .addAttribute(
              TriggeringCondition.voucherName, data.values?.successTitle)
          .addAttribute(
              TriggeringCondition.offerName, data.values?.successTitle)
          .setNonInteractiveEvent();
    }
    MoenageManager.logEvent(
      MoenageEvent.spinTheWheel,
      properties: properties,
    );
    AutoRouter.of(context).push(
      VoucherGotScreenRoute(
        spinValue: data.values!.successTitle ?? "",
        fromSplash: model.isFromSplash,
        showVoucherButton: isShowVoucher,
      ),
    );
  }

  @override
  set updateView(SpinTheWheelView spinTheWheelView) {
    view = spinTheWheelView;
    view.refreshModel(model);
  }

  @override
  Future<SpinData?> spinTheWheel({
    required BuildContext context,
    required String spinCode,
  }) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.spinTheWheel,
      data: {
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "spin_code": spinCode,
      },
    );

    if (response != null) {
      if (response['status'] == true) {
        model.spinDataResponse = SpinData.fromJson(response);
        if (model.apiKey == "type") {
          GlobalSingleton.isSpinTheWheelCalled = true;
        }
        getProfileData(context);
      }
    }
    return model.spinDataResponse;
  }
}
