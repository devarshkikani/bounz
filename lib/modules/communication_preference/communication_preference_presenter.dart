import 'dart:convert';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/modules/communication_preference/communication_preference_view.dart';
import 'package:bounz_revamp_app/modules/communication_preference/communication_preference_model.dart';
import 'package:moengage_flutter/properties.dart';

class CommunicationPreferencePresenter {
  Future<void> savedPrefrences({
    required String sms,
    required String email,
    required String whatsapp,
    required BuildContext context,
  }) async {}
  set updateModel(CommunicationPreferenceView value) {}
}

class BasicCommunicationPreferencePresenter
    implements CommunicationPreferencePresenter {
  late CommunicationPreferenceModel model;
  late CommunicationPreferenceView view;
  BasicCommunicationPreferencePresenter() {
    view = CommunicationPreferenceView();
    model = CommunicationPreferenceModel(
        emailCheck: false, whatsappCheck: false, smsCheck: false);
  }

  @override
  set updateModel(CommunicationPreferenceView value) {
    view = value;
    view.refreshModel(model);
  }

  @override
  Future<void> savedPrefrences(
      {required String sms,
      required String email,
      required String whatsapp,
      required BuildContext context}) async {
    if (GlobalSingleton.userInformation.emailConsent != email) {
      await NetworkDio.postDioHttpMethod(
          url: ApiPath.apiEndPoint + ApiPath.communicationEmailConsent,
          context: context,
          data: {
            'membership_no':
                GlobalSingleton.userInformation.membershipNo.toString(),
            'email_consent': email,
          });
    }
    if (GlobalSingleton.userInformation.smsConsent != sms) {
      await NetworkDio.postDioHttpMethod(
          url: ApiPath.apiEndPoint + ApiPath.communicationSmsConsent,
          context: context,
          data: {
            'membership_no':
                GlobalSingleton.userInformation.membershipNo.toString(),
            'sms_consent': sms,
          });
    }

    if (GlobalSingleton.userInformation.whatsappConsent != whatsapp) {
      await NetworkDio.postDioHttpMethod(
          url: ApiPath.apiEndPoint + ApiPath.communicationWhatsappConsent,
          context: context,
          data: {
            'membership_no':
                GlobalSingleton.userInformation.membershipNo.toString(),
            'whatsapp_consent': whatsapp,
          });
    }

    GlobalSingleton.userInformation.smsConsent = sms;
    GlobalSingleton.userInformation.emailConsent = email;
    GlobalSingleton.userInformation.whatsappConsent = whatsapp;
    bool communicationSelect = true;
    sms == "NO" || whatsapp == "NO" || email == "NO"
        ? communicationSelect = false
        : communicationSelect = true;
    final String encodeData =
        jsonEncode(GlobalSingleton.userInformation.toJson());
    StorageManager.setStringValue(
        key: AppStorageKey.userInformation, value: encodeData);

    MoenageManager.logScreenEvent(name: 'Saved Communication Preference');

    final properties = MoEProperties();
    properties
        .addAttribute(TriggeringCondition.email,
            GlobalSingleton.userInformation.emailConsent)
        .addAttribute(
            TriggeringCondition.sms, GlobalSingleton.userInformation.smsConsent)
        .addAttribute(TriggeringCondition.whatsapp,
            GlobalSingleton.userInformation.whatsappConsent)
        .addAttribute(
            TriggeringCondition.emailId, GlobalSingleton.userInformation.email)
        .addAttribute(TriggeringCondition.mobileNumber,
            "${GlobalSingleton.userInformation.countryCode.toString()}${GlobalSingleton.userInformation.mobileNumber.toString()}")
        .addAttribute(TriggeringCondition.firstName,
            GlobalSingleton.userInformation.firstName)
        .addAttribute(TriggeringCondition.lastName,
            GlobalSingleton.userInformation.lastName)
        .addAttribute(
            TriggeringCondition.dob, GlobalSingleton.userInformation.dob)
        .addAttribute(
            TriggeringCondition.gender, GlobalSingleton.userInformation.gender)
        .addAttribute(TriggeringCondition.memberId,
            GlobalSingleton.userInformation.membershipNo)
        .addAttribute(
            TriggeringCondition.communicationOptions, communicationSelect);

    MoenageManager.logEvent(
      MoenageEvent.communicationPreferences,
      properties: properties,
    );
    MoenageManager.logScreenEvent(name: 'Saved Communication Preference');
    AutoRouter.of(context).push(
      const SavedCommunicationPreferenceScreenRoute(),
    );
  }
}
