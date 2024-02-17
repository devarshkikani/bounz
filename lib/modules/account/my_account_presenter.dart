import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/modules/account/my_account_model.dart';
import 'package:bounz_revamp_app/modules/account/my_account_view.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:moengage_flutter/properties.dart';

class MyAccountPresenter {
  Future deleteAccount(BuildContext context) async {}
  Future logout(BuildContext context) async {}
  set updateView(MyAccountView myAccountView) {}
}

class BasicMyAccountPresenter implements MyAccountPresenter {
  late MyAccountModel model;
  late MyAccountView view;
  BasicMyAccountPresenter() {
    view = MyAccountView();
    model = MyAccountModel();
  }

  @override
  Future deleteAccount(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.deleteUser,
      context: context,
      data: {
        "membership_no": GlobalSingleton.userInformation.membershipNo,
      },
    );
    if (response != null) {
      await StorageManager.clearSharedPreferences();
      GlobalSingleton.transactionList = null;
      StorageManager.setBoolValue(
          key: AppStorageKey.isHowToUseSeen, value: true);
      final properties = MoEProperties();
      properties
          .addAttribute(TriggeringCondition.memberId,
              GlobalSingleton.userInformation.membershipNo)
          .addAttribute(TriggeringCondition.customerId, "")
          .addAttribute(TriggeringCondition.mobileNumber,
              "${GlobalSingleton.userInformation.countryCode.toString()}${GlobalSingleton.userInformation.mobileNumber.toString()}")
          .setNonInteractiveEvent();
      MoenageManager.logEvent(
        MoenageEvent.deleteAccount,
        properties: properties,
      );
      GlobalSingleton.resetValues();
      MoenageManager.logScreenEvent(name: 'Welcome');
      AutoRouter.of(context).pushAndPopUntil(
        WelcomeScreenRoute(),
        // LoginRegistrationScreenRoute(
        //   presenter: BasicLoginRegistrationPresenter(),
        // ),
        predicate: (_) => false,
      );
    }
  }

  @override
  Future logout(BuildContext context) async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    await StorageManager.clearSharedPreferences();
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
        url: ApiPath.apiEndPoint + ApiPath.logoutUser,
        context: context,
        data: {
          'membership_no': GlobalSingleton.userInformation.membershipNo,
          'os': GlobalSingleton.osType == ''
              ? Platform.operatingSystem
              : GlobalSingleton.osType,
          'fcm_token': fcmToken,
          'type': 'logout',
        });
    if (response != null) {
      await StorageManager.clearSharedPreferences();
      GlobalSingleton.transactionList = null;
      StorageManager.setBoolValue(
          key: AppStorageKey.isHowToUseSeen, value: true);

      MoenageManager.moengagePlugin.logout();
      MoenageManager.logScreenEvent(name: 'Welcome');
      AutoRouter.of(context).pushAndPopUntil(
        WelcomeScreenRoute(),
        predicate: (_) => false,
      );
    }
    GlobalSingleton.resetValues();
  }

  @override
  set updateView(MyAccountView myAccountView) {
    view = myAccountView;
    view.refreshModel(model);
  }
}
