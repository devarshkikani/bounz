import 'dart:async';
import 'dart:convert';
import 'package:bounz_revamp_app/utils/otp_encryption.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:moengage_flutter/model/gender.dart';
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
import 'package:bounz_revamp_app/modules/auth/otp/otp_varification_view.dart';
import 'package:bounz_revamp_app/modules/auth/otp/otp_varification_model.dart';
import 'package:moengage_flutter/properties.dart';

class OtpVarificationPresenter {
  void updateTimer(Timer timer) {}

  Future<void> verifyOtp({
    required String otpText,
    required BuildContext context,
  }) async {}
  Future<void> resendOtp({
    required BuildContext context,
  }) async {}
  set reSetView(OtpVarificationView value) {}
}

class BasicOtpVarificationPresenter implements OtpVarificationPresenter {
  late OtpVarificationModel model;
  late OtpVarificationView view;
  BasicOtpVarificationPresenter(this.model) {
    view = OtpVarificationView();
  }

  @override
  Future verifyOtp({
    required String otpText,
    required BuildContext context,
  }) async {
    if (model.validOtp == otpText.trim()) {
      String keyName = model.email != null ? 'otp' : 'author';
      Map data = {
        keyName: model.isFromLogin == false
            ? otpText.trim()
            : OtpEncryption().encryptOTP(otpText.trim()),
      };
      if (model.email != null) {
        data["membership_no"] = GlobalSingleton.userInformation.membershipNo;
        data["email"] = model.email;
      } else if (model.isFromLogin) {
        data['country_code'] = model.countryCode;
        data['mobile_number'] = model.mobileNumber;
      } else {
        data['membership_no'] = GlobalSingleton.userInformation.membershipNo;
        data['phone'] = model.mobileNumber;
        data['country_code'] = model.countryCode;
      }
      Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
        url: ApiPath.apiEndPoint +
            (model.email != null
                ? ApiPath.verifyEmail
                : model.isFromLogin
                    ? ApiPath.verifyOTP
                    : ApiPath.verifyPhone),
        context: context,
        data: data,
      );

      if (response != null) {
        final properties = MoEProperties();
        properties
            .addAttribute(TriggeringCondition.otpGeneratedFor, 'Registration')
            .addAttribute(TriggeringCondition.status, 'Verified')
            .setNonInteractiveEvent();
        MoenageManager.logEvent(
          MoenageEvent.mobileNumberOtpVerification,
          properties: properties,
        );

        if (UserType.login == model.userType) {
          if (model.isFromLogin) {
            storeLoginUserData(response, context);
          } else {
            AutoRouter.of(context).pop(true);
          }
        } else {
          MoenageManager.logScreenEvent(name: 'User Registration');

          AutoRouter.of(context).push(
            UserRegistrationScreenRoute(
              countryCode: model.countryCode,
              mobileNumber: model.mobileNumber,
            ),
          );
        }
      }
    } else {
      NetworkDio.showError(
        title: 'Error!',
        context: context,
        errorMessage: 'OTP does not match, please enter valid OTP',
      );
    }
  }

  void storeLoginUserData(Map<String, dynamic> response, BuildContext context) {
    GlobalSingleton.userInformation =
        UserInformation.fromJson(response['values']);

    final String encodeData = jsonEncode(response['values']);
    StorageManager.setStringValue(
        key: AppStorageKey.userInformation, value: encodeData);

    StorageManager.setBoolValue(key: AppStorageKey.isLogIn, value: true);

    MoenageManager.logScreenEvent(name: 'Main Home');
    final properties = MoEProperties();
    properties
        .addAttribute(TriggeringCondition.loginType, 'phone')
        .addAttribute(TriggeringCondition.memberId,
            GlobalSingleton.userInformation.membershipNo)
        .addAttribute(TriggeringCondition.customerId, "")
        .addAttribute(TriggeringCondition.mobileNumber,
            "${GlobalSingleton.userInformation.countryCode.toString()}${GlobalSingleton.userInformation.mobileNumber.toString()}")
        .setNonInteractiveEvent();
    MoenageManager.logEvent(
      MoenageEvent.login,
      properties: properties,
    );
    setupMoEngage();
    if (GlobalSingleton.userInformation.email == null ||
        GlobalSingleton.userInformation.email!.isEmpty ||
        GlobalSingleton.userInformation.dob == null ||
        GlobalSingleton.userInformation.dob!.isEmpty ||
        GlobalSingleton.userInformation.gender == null ||
        GlobalSingleton.userInformation.gender!.isEmpty ||
        GlobalSingleton.userInformation.nationality == null ||
        GlobalSingleton.userInformation.nationality!.isEmpty) {
      StorageManager.setBoolValue(
        key: AppStorageKey.isProfileInCompleted,
        value: true,
      );
      AutoRouter.of(context).pushAndPopUntil(
          MyProfileScreenRoute(
            fromSplash: true,
          ),
          predicate: (_) => false);
    } else {
      AutoRouter.of(context).pushAndPopUntil(
          MainHomeScreenRoute(isFirstLoad: true),
          predicate: (_) => false);
    }
  }

  @override
  Future resendOtp({
    required BuildContext context,
  }) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.resendOTP,
      context: context,
      data: model.email != null
          ? {
              "type": "email",
              "email": model.email,
              "membership_no": GlobalSingleton.userInformation.membershipNo,
            }
          : {
              'country_code': model.countryCode,
              'mobile_number': model.mobileNumber,
            },
    );
    if (response != null) {
      model.enableResend = false;
      model.validOtp = OtpEncryption().decryptOTP(response['values']['author']);
      view.refreshModel(model);
      view.resendOtp();
    }
  }

  void setupMoEngage() {
    UserInformation userInfo = GlobalSingleton.userInformation;

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

  @override
  set reSetView(OtpVarificationView value) {
    view = value;
    view.refreshModel(model);
  }

  @override
  void updateTimer(Timer timer) {
    if (timer.tick == 180) {
      model.enableResend = true;
    }
    model.currentSeconds = timer.tick;
    if (timer.tick >= 180) timer.cancel();
    view.refreshModel(model);
  }
}
