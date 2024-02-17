import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/link_smile_acc/link_smile_account.dart';
import 'package:bounz_revamp_app/models/reward_exchange/all_member_data.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/smile_to_bounz/smile_to_bounz_model.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/smile_to_bounz/smile_to_bounz_view.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/utils/progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:moengage_flutter/properties.dart';

class SmileToBounzPresenter {
  Future getAllMemberData(BuildContext context) async {}
  Future getLatestPartnerPointsRefresh(
      BuildContext context, String smileId) async {}
  Future<bool> postTransactionToBlockChain(
      BuildContext context,
      int convertPoint,
      int calculatePoint,
      Function() otpTransactionOsSheet) async {
    return false;
  }

  Future<bool> verifyPostTranOTP(BuildContext context, String otp,
      String convertPoint, int calculatePoint) async {
    return false;
  }

  set updateView(SmileToBounzView bounzToSmileView) {}
}

class BasicSmileToBounzPresenter implements SmileToBounzPresenter {
  late SmileToBounzView view;
  late SmileToBounzViewModel model;
  int pointApiCalled = 0;
  int memberApiCalled = 0;
  Circle processIndicator = Circle();
  BasicSmileToBounzPresenter() {
    view = SmileToBounzView();
    model = SmileToBounzViewModel(isLoading: Circle(), conversionRate: 0.25);
  }

  @override
  Future getAllMemberData(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.getAllMembership,
      context: context,
      data: {
        "sourceProgramCode": AppConstString.bounzVal,
        "membership_no": GlobalSingleton.userInformation.membershipNo,
      },
    );
    if (response != null) {
      model.allMemberModel = DataAllMember.fromJson(response['data']);
      model.isGetData = true;
      updatePoints();
      view.refreshModel(model);

      var diffMin = model.allMemberModel!.timestamp!
          .difference(model.allMemberModel!.linkedPartners![0].nowValue!)
          .inMinutes;
      if (diffMin > 120 && memberApiCalled <= 10) {
        if (GlobalSingleton.isBack) {
          return;
        }
        Future.delayed(const Duration(seconds: 5), () {
          memberApiCalled++;
          getAllMemberData(context); // 10 times, // 5 sec delay
        });
      } else {
        processIndicator.hide(context);
      }
    }
  }

  @override
  set updateView(SmileToBounzView smileToBounzView) {
    view = smileToBounzView;
    view.refreshModel(model);
  }

  @override
  Future getLatestPartnerPointsRefresh(
      BuildContext context, String smileId) async {
    if (!processIndicator.isShow) {
      processIndicator.show(context);
    }
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.getLatestPartnerPoints,
      // context: context,
      data: {
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "smiles_id": model.smileId,
      },
    );
    if (response != null) {
      if (response['status'] == true || pointApiCalled == 3) {
        Future.delayed(const Duration(seconds: 5), () {
          getAllMemberData(context); // add 5 sec wait
        });
      } else {
        pointApiCalled++;
        Future.delayed(const Duration(seconds: 2), () {
          getLatestPartnerPointsRefresh(context, smileId); // add 1 sec wait
        });
      }
    }
    view.refreshModel(model);
  }

  @override
  Future<bool> postTransactionToBlockChain(
      BuildContext context,
      int convertPoint,
      int calculatePoint,
      Function() otpTransactionOsSheet) async {
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.postTransactionToBlockchain,
      context: context,
      data: {
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "smiles_id": model.smileId,
        "convert_point": convertPoint,
        "calculate_point": calculatePoint,
        "sourceProgramCode": AppConstString.bounzVal,
        "targetProgramCode": AppConstString.smilesVal,
        "transactionSubType": "OS",
      },
    );
    if (response != null) {
      model.linkSmileAccModel = LinkSmileAccModel.fromJson(response['data']);
      if (model.linkSmileAccModel != null) {
        if (model.linkSmileAccModel!.status == true) {
          if (model.linkSmileAccModel!.message == 'Success') {
            getAllMemberData(context);
            getProfileData(context);
            return true;
          } else if (model.linkSmileAccModel!.message ==
              'OTP Send successfully') {
            otpTransactionOsSheet();
          }
        }
      }
    }
    return false;
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
  Future<bool> verifyPostTranOTP(BuildContext context, String otp,
      String convertPoint, int calculatePoint) async {
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.verifyPostTranOtp,
      context: context,
      data: {
        "transactionSubType": "OS",
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "smiles_id": model.smilesMemberID,
        "convert_point": int.parse(convertPoint),
        "calculate_point": calculatePoint,
        "sourceProgramCode": AppConstString.bounzVal,
        "targetProgramCode": AppConstString.smilesVal,
        "point": (GlobalSingleton.userInformation.pointBalance!.toString())
            .replaceAll(",", ""),
        "otp": otp,
      },
    );
    if (response != null) {
      if (response['status'] == true) {
        final properties = MoEProperties();
        properties.addAttribute(
            TriggeringCondition.screenName, 'Reward Received');
        properties.addAttribute(
            TriggeringCondition.excahangeType, 'Smiles To Bounz');
        properties.addAttribute(
            TriggeringCondition.smiles, int.parse(convertPoint));
        properties.addAttribute(TriggeringCondition.bounz, calculatePoint);
        properties.addAttribute(TriggeringCondition.smilesNewBalance,
            GlobalSingleton.smilesTempBal ?? "");
        properties.addAttribute(TriggeringCondition.bounzNewBalance,
            GlobalSingleton.bounzNewTempBal ?? "");
        MoenageManager.logEvent(
          MoenageEvent.screenView,
          properties: properties,
        );
        //getAllMemberData(context);
        return true;
      }
    }
    return false;
  }

  void updatePoints() {
    model.range ??= double.parse(pointsFormatter(0));
    for (int j = 0; j < model.allMemberModel!.linkedPartners!.length; j++) {
      model.smilesPointsBal = double.parse(
          model.allMemberModel!.linkedPartners![j].points.toString());
      model.range = model.smilesPointsBal?.toDouble();
      model.smilesMemberID =
          model.allMemberModel!.linkedPartners![j].targetMembershipNo;
      model.conversionRate =
          (model.allMemberModel!.linkedPartners![j].os!.nominator! /
                  model.allMemberModel!.linkedPartners![j].os!.denominator!) *
              1.0;
      model.roundOffMethod =
          model.allMemberModel!.linkedPartners![j].os!.roundOffMethod;

      model.conversionRateB =
          model.allMemberModel!.linkedPartners![j].so!.nominator! / 1000;
      model.conversionRateS =
          model.allMemberModel!.linkedPartners![j].os!.denominator! / 1000;

      model.multiple = model.allMemberModel!.linkedPartners![j].os!.multipleOf;

      model.minConversion = double.parse(model
          .allMemberModel!.linkedPartners![j].os!.minConversion
          .toString());

      if (model.range! < model.minConversion!) {
        model.availablePoints = false;
      } else {
        model.availablePoints = true;
      }
    }
  }
}
