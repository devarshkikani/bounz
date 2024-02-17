import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/enum.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/country/country_model.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/modules/auth/otp/otp_varification_model.dart';
import 'package:bounz_revamp_app/modules/auth/otp/otp_varification_presenter.dart';
import 'package:bounz_revamp_app/modules/profile/my_profile/my_profile_model.dart';
import 'package:bounz_revamp_app/modules/profile/my_profile/my_profile_view.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/utils/otp_encryption.dart';
import 'package:flutter/material.dart';
import 'package:moengage_flutter/properties.dart';

class MyProfilePresenter {
  void selectCountry(Country country) {}
  Future generateOtp({
    required Map<String, dynamic> data,
    required BuildContext context,
  }) async {}
  Future<void> updateProfile({
    required Map<String, dynamic> data,
    required BuildContext context,
    required bool isFromSplash,
  }) async {}
  set updateView(MyProfileView model) {}
}

class BasicMyProfilePresenter implements MyProfilePresenter {
  late MyProfileModel model;
  late MyProfileView view;

  BasicMyProfilePresenter() {
    model = MyProfileModel(
      disablePhone: true,
      disableEmail: true,
      updatedEmail: false,
      updatedPhone: false,
    );
    view = MyProfileView();
  }

  @override
  set updateView(MyProfileView myProfileView) {
    view = myProfileView;
    view.refreshModel(model);
  }

  @override
  void selectCountry(Country country) {
    model.selectedCountry = country;
    view.refreshModel(model);
  }

  @override
  Future<void> updateProfile({
    required Map<String, dynamic> data,
    required BuildContext context,
    required bool isFromSplash,
  }) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.updateUserProfile,
      context: context,
      data: data,
    );
    if (response != null) {
      GlobalSingleton.userInformation =
          UserInformation.fromJson(response['values']);
      final String encodeData = jsonEncode(response['values']);
      StorageManager.setBoolValue(
        key: AppStorageKey.isProfileInCompleted,
        value: false,
      );
      StorageManager.setStringValue(
          key: AppStorageKey.userInformation, value: encodeData);
      AutoRouter.of(context).pushAndPopUntil(
          MainHomeScreenRoute(
            index: isFromSplash ? 0 : 4,
            isFirstLoad: isFromSplash,
          ),
          predicate: (_) => false);
    }
  }

  @override
  Future generateOtp({
    required Map<String, dynamic> data,
    required BuildContext context,
  }) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.generateOTP,
      context: context,
      data: data,
    );
    if (response != null) {
      MoenageManager.logScreenEvent(name: 'Otp Verification Onboarding');

      AutoRouter.of(context)
          .push(
        OtpVerificationOnboardingRoute(
          presenter: BasicOtpVarificationPresenter(
            OtpVarificationModel(
              countryCode: data['country_code'] ?? '',
              mobileNumber: data['phone'] ?? '',
              email: data['email'],
              validOtp: OtpEncryption().decryptOTP(response['author']),
              userType: UserType.login,
              currentSeconds: 0,
              enableResend: false,
              isFromLogin: false,
            ),
          ),
        ),
      )
          .then((value) {
        if (value == true) {
          if (data.containsKey('phone')) {
            model.disablePhone = true;
            GlobalSingleton.userInformation.phoneVerified = 'YES';
            model.updatedPhone = true;
            GlobalSingleton.userInformation.mobileNumber = data['phone'];
            GlobalSingleton.userInformation.countryCode = data['country_code'];

            final properties = MoEProperties();
            properties
                .addAttribute(
                    TriggeringCondition.otpGeneratedFor, 'Registration')
                .addAttribute(TriggeringCondition.status, 'Verified')
                .addAttribute(
                    TriggeringCondition.otpGeneratedFor, 'Points Redemption')
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.mobileNumberOtpVerification,
              properties: properties,
            );
          } else {
            model.disableEmail = true;
            model.updatedEmail = true;
            GlobalSingleton.userInformation.emailVerified = 'YES';
            GlobalSingleton.userInformation.email = data['email'];

            final properties = MoEProperties();
            properties
                .addAttribute(TriggeringCondition.status, 'Verified')
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.emailVerification,
              properties: properties,
            );
          }
          final String encodeData =
              jsonEncode(GlobalSingleton.userInformation.toJson());
          StorageManager.setStringValue(
              key: AppStorageKey.userInformation, value: encodeData);

          view.refreshModel(model);
        }
      });
    }
  }
}
