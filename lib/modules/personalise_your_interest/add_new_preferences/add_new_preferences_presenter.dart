import 'dart:convert';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/modules/personalise_your_interest/add_new_preferences/add_new_preferences_view.dart';

class SelectPreferencePresenter {
  Future getPreferenceData(
      {required BuildContext context,
      required AddNewPreferencesView personalizeAddNewPreferencesView}) async {
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.interest,
      context: context,
    );
    if (response != null) {
      List<Interest> interestList = [];
      for (Map<String, dynamic> i in response['data']['values']) {
        interestList.add(Interest.fromJson(i));
      }
      personalizeAddNewPreferencesView.showPreferenceData(interestList);
    }
  }

  Future updateUser({
    required BuildContext context,
    required int membershipNo,
    required List<int> interestId,
    required List<Interest> interestSelected,
    required AddNewPreferencesView personalizeAddNewPreferencesView,
  }) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.updateUserInfo,
      context: context,
      data: {
        "membership_no": membershipNo,
        "interests": interestId,
      },
    );
    if (response != null) {
      GlobalSingleton.userInformation.interests = interestSelected;

      StorageManager.setStringValue(
        key: AppStorageKey.userInformation,
        value: jsonEncode(GlobalSingleton.userInformation),
      );
      MoenageManager.logScreenEvent(name: 'My Interest Preferences');

      AutoRouter.of(context).popAndPush(
        const MyInterestPreferencesUpdatedScreenRoute(),
      );
    }
  }
}
