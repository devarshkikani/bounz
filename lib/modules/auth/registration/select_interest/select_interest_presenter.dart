import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:moengage_flutter/model/gender.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/models/interest/interest_model.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart' as user;
import 'package:bounz_revamp_app/modules/auth/registration/select_interest/select_interest_view.dart';
import 'package:moengage_flutter/properties.dart';

class SelectInterestPresenter {
  Future getInterestData(
      {required BuildContext context,
      required SelectInterestView personalizeInterestView}) async {
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.interest,
      context: context,
    );
    if (response != null) {
      List<Interest> interestList = [];
      for (Map<String, dynamic> i in response['data']['values']) {
        interestList.add(Interest.fromJson(i));
      }
      personalizeInterestView.showInterestData(interestList);
    }
  }

  Future registerUser({
    required BuildContext context,
    required String loginType,
    required Map<String, dynamic> data,
    required SelectInterestView personalizeInterestView,
  }) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.createUser,
      context: context,
      data: data,
    );
    if (response != null) {
      getProfileData(
        context,
        loginType,
        response['values']['membership_no'],
        data['referral_code'].toString().isNotEmpty,
      );
    }
  }

  Future getProfileData(BuildContext context, String loginType,
      int membershipNo, bool isReffral) async {
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.getProfile,
      context: context,
      queryParameters: {
        'membership_no': membershipNo,
      },
    );
    if (response != null) {
      storeLoginUserData(
        loginType,
        response['data']['values'][0],
        context,
        isReffral,
      );
    }
  }

  void storeLoginUserData(String loginType, Map<String, dynamic> response,
      BuildContext context, bool isReffer) {
    GlobalSingleton.userInformation = user.UserInformation.fromJson(response);

    final String encodeData = jsonEncode(response);
    StorageManager.setStringValue(
        key: AppStorageKey.userInformation, value: encodeData);

    StorageManager.setBoolValue(key: AppStorageKey.isLogIn, value: true);

    final properties = MoEProperties();

    properties
        .addAttribute(TriggeringCondition.login,
            loginType == 'Phone' ? 'phone' : 'social')
        .addAttribute(TriggeringCondition.loginType, loginType)
        .addAttribute(TriggeringCondition.registerType, '')
        .addAttribute(TriggeringCondition.merchantId,
            GlobalSingleton.userInformation.membershipNo)
        .addAttribute(TriggeringCondition.customerId, "")
        .setNonInteractiveEvent();
    MoenageManager.logEvent(
      MoenageEvent.register,
      properties: properties,
    );

    setupMoEngage();

    MoenageManager.logScreenEvent(name: 'Profile Created');

    AutoRouter.of(context).push(
      ProfileCreatedScreenRoute(
        isReffer: isReffer,
      ),
    );
  }

  void setupMoEngage() {
    user.UserInformation userInfo = GlobalSingleton.userInformation;

    MoenageManager.moengagePlugin
        .setUniqueId(GlobalSingleton.userInformation.membershipNo!);
    MoenageManager.moengagePlugin.setFirstName(userInfo.firstName.toString());
    MoenageManager.moengagePlugin.setLastName(userInfo.lastName.toString());
    MoenageManager.moengagePlugin.setEmail(userInfo.email.toString());
    MoenageManager.moengagePlugin.setBirthDate(userInfo.dob.toString());
    MoenageManager.moengagePlugin.setPhoneNumber(
        "${userInfo.countryCode.toString()}${userInfo.mobileNumber.toString()}");
    MoenageManager.moengagePlugin.setGender(
        userInfo.gender == 'male' ? MoEGender.male : MoEGender.female);
    MoenageManager.moengagePlugin.setUserName(
        userInfo.firstName.toString() + ' ' + userInfo.lastName.toString());
    MoenageManager.moengagePlugin
        .setUserAttribute("App Version", GlobalSingleton.appVersion);
  }
}
