import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:flutter/material.dart';
import 'package:moengage_flutter/properties.dart';

class UserRegistrationPresenter {
  Future createUser({
    required Map<String, dynamic> data,
    required BuildContext context,
    required String loginType,
    required String nantionlityContryName,
    required String residenatlCountryName,
    required String selectCityName,
  }) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.createUser,
      context: context,
      data: data,
    );
    if (response != null) {
      MoenageManager.logScreenEvent(name: 'Select Interest');

      final properties = MoEProperties();
      properties
          .addAttribute(TriggeringCondition.gender, data['gender'])
          .addAttribute(
              TriggeringCondition.firstName, data['first_name'].trim())
          .addAttribute(TriggeringCondition.lastName, data['last_name'].trim())
          .addAttribute(TriggeringCondition.emailId, data['email'].trim())
          .addAttribute(TriggeringCondition.dob, data['dob'])
          .addAttribute(TriggeringCondition.nationality, nantionlityContryName)
          .addAttribute(TriggeringCondition.city, selectCityName)
          .addAttribute(
              TriggeringCondition.residentCountry, residenatlCountryName)
          .addAttribute(TriggeringCondition.referralCode, data['referral_code'])
          .addAttribute(TriggeringCondition.mobileNumber,
              "${response['values']['country_code'].toString()}${response['values']['phone'].toString()}")
          .addAttribute(TriggeringCondition.install, "True")
          .setNonInteractiveEvent();
      MoenageManager.logEvent(
        MoenageEvent.userDetails,
        properties: properties,
      );

      AutoRouter.of(context).push(
        SelectInterestScreenRoute(userDetails: data, loginType: loginType),
      );
    }
  }
}
