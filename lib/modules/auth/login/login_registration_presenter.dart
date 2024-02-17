import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/enum.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/country/country_model.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart' as user;
import 'package:bounz_revamp_app/modules/auth/login/login_registration_model.dart';
import 'package:bounz_revamp_app/modules/auth/login/login_registration_view.dart';
import 'package:bounz_revamp_app/modules/auth/otp/otp_varification_model.dart';
import 'package:bounz_revamp_app/modules/auth/otp/otp_varification_presenter.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/utils/otp_encryption.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moengage_flutter/model/gender.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginRegistrationPresenter {
  Future<void> generateOtp(
      {required Map<String, dynamic> data,
      required BuildContext context}) async {}
  void selectCountry(Country country) {}
  Future<void> signinwithGoogle(BuildContext context) async {}
  Future<void> signinwithApple(BuildContext context) async {}
  set loginRegistrationView(LoginRegistrationView value) {}
}

class BasicLoginRegistrationPresenter implements LoginRegistrationPresenter {
  late LoginRegistrationModel model;
  late LoginRegistrationView view;
  BasicLoginRegistrationPresenter() {
    model = LoginRegistrationModel(
      isGoogleSignIn: false,
      isAppleSignIn: false,
    );
    view = LoginRegistrationView();
  }

  @override
  void selectCountry(Country country) {
    model.countryCode = country;
    view.refreshModel(model);
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
      late UserType userType;
      StorageManager.setStringValue(
        key: AppStorageKey.mobileNumberCountryImage,
        value: model.countryCode?.image ?? AppAssets.uaeFlag,
      );
      if (!response.containsKey('customer_status')) {
        userType = UserType.pending;
      } else if (response['customer_status'] == 'Inactive') {
        userType = UserType.register;
      } else {
        userType = UserType.login;
      }

      if (userType == UserType.register) {
        GlobalSingleton.registerUserInfo = response['values'];
      }

      MoenageManager.logScreenEvent(name: 'Otp Verification Onboarding');

      if (response['status_code'] == "CC00011" ||
          response['status_code'] == "CC00010") {
        StorageManager.setStringValue(
          key: AppStorageKey.deletedAccountText,
          value: response['message'],
        );
        AutoRouter.of(context)
            .push(DeletedAccountScreenRoute(isFromSplash: false));
      } else {
        AutoRouter.of(context).push(
          OtpVerificationOnboardingRoute(
            presenter: BasicOtpVarificationPresenter(
              OtpVarificationModel(
                countryCode: data['country_code'],
                mobileNumber: data['phone'],
                validOtp: OtpEncryption().decryptOTP(response['author']),
                userType: userType,
                currentSeconds: 0,
                enableResend: false,
                isFromLogin: true,
              ),
            ),
          ),
        );
      }
    }
  }

  @override
  Future<void> signinwithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
      ],
    );

    _googleSignIn.disconnect();

    final GoogleSignInAccount? currentUser = await _googleSignIn.signIn();
    if (currentUser != null) {
      final GoogleSignInAuthentication? authentication =
          await currentUser.authentication;
      if (authentication != null) {
        final firstName = currentUser.displayName!.split(' ')[0];
        final lastName = currentUser.displayName!.split(' ')[1];
        Map<String, dynamic> data = {
          "id": currentUser.id,
          "first_name": firstName,
          "last_name": lastName,
          "email": currentUser.email,
          "display_name": currentUser.displayName,
          "provider": "google"
        };
        handleUserCredential(isApple: true, data: data, context: context);
      } else {
        NetworkDio.showError(
            title: 'Error',
            context: context,
            errorMessage: 'Something went wrong, try again later.');
      }
    }
    /*else {
      NetworkDio.showError(
          title: 'Error',
          context: context,
          errorMessage: 'Something went wrong, try again later.');
    }*/
  }

  @override
  Future<void> signinwithApple(BuildContext context) async {
    final AuthorizationCredentialAppleID userCredentials =
        await SignInWithApple.getAppleIDCredential(
      scopes: <AppleIDAuthorizationScopes>[
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'de.lunaone.flutter.signinwithappleexample.service',
        redirectUri: Uri.parse(
          'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
        ),
      ),
    );
    Map<String, dynamic> data = {
      "id": userCredentials.userIdentifier,
      "first_name": userCredentials.givenName,
      "last_name": userCredentials.familyName,
      "email": userCredentials.email,
      "display_name":
          "${userCredentials.givenName} + '' + ${userCredentials.familyName}",
      "provider": "apple"
    };
    handleUserCredential(isApple: true, data: data, context: context);
  }

  Future<void> handleUserCredential({
    required bool isApple,
    required Map data,
    required BuildContext context,
  }) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
        url: ApiPath.apiEndPoint + ApiPath.socialLogin,
        data: data,
        context: context);
    if (response != null) {
      if (response['account_status'] != null &&
          response['account_status'] == 'Inactive') {
        StorageManager.setStringValue(
          key: AppStorageKey.deletedAccountText,
          value: response['message'],
        );
        AutoRouter.of(context)
            .push(DeletedAccountScreenRoute(isFromSplash: false));
        return;
      }
      if (response['type'] == 'register') {
        if (isApple) {
          model.isAppleSignIn = true;
          model.isGoogleSignIn = false;
        } else {
          model.isAppleSignIn = false;
          model.isGoogleSignIn = true;
        }
        GlobalSingleton.registerUserInfo = response['values'];
        view.refreshModel(model);
      } else if (response['type'] == 'login') {
        storeLoginUserData(response['values'], context, isApple);
      }
    }
  }

  void storeLoginUserData(
    Map<String, dynamic> response,
    BuildContext context,
    bool isApple,
  ) {
    GlobalSingleton.userInformation = user.UserInformation.fromJson(response);

    final String encodeData = jsonEncode(response);
    StorageManager.setStringValue(
        key: AppStorageKey.userInformation, value: encodeData);

    StorageManager.setBoolValue(key: AppStorageKey.isLogIn, value: true);

    final properties = MoEProperties();
    properties
        .addAttribute(
            TriggeringCondition.loginType, isApple ? 'apple' : 'google')
        .addAttribute(TriggeringCondition.memberId,
            GlobalSingleton.userInformation.membershipNo)
        .addAttribute(TriggeringCondition.customerId, "")
        .addAttribute(TriggeringCondition.mobileNumber,
            "${GlobalSingleton.userInformation.countryCode.toString()}${GlobalSingleton.userInformation.mobileNumber.toString()}")
        .addAttribute(TriggeringCondition.install, "True")
        .setNonInteractiveEvent();

    MoenageManager.logEvent(
      MoenageEvent.login,
      properties: properties,
    );
    setupMoEngage();
    AutoRouter.of(context).pushAndPopUntil(
        predicate: (_) => false, MainHomeScreenRoute(isFirstLoad: true));
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

  @override
  set loginRegistrationView(LoginRegistrationView value) {
    view = value;
    view.refreshModel(model);
  }
}
