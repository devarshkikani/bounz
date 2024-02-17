import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/link_smile_acc/link_smile_account.dart';
import 'package:bounz_revamp_app/models/reward_exchange/all_member_data.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/reward_exchange/reward_exchange_model.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/reward_exchange/reward_exchange_view.dart';

import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:flutter/material.dart';
import 'package:moengage_flutter/properties.dart';

class RewardExchangePresenter {
  Future getAllMemberData(BuildContext context) async {}

  Future linkSmileAccount(BuildContext context, String smileId) async {}

  Future<bool> unLinkSmileAccount(
      BuildContext context, bool isFromLinkAcc, String smileId) async {
    return false;
  }

  Future otpVerifyHash(
      BuildContext context,
      String smileId,
      String otp,
      Function() showBottomSheetInvalid,
      Function() timedOutBottomSheet) async {}

  Future<bool> postTransactionToBlockChain(
      BuildContext context,
      String convertPoint,
      int calculatePoint,
      Function() sessionExpireAlert) async {
    return false;
  }

  Future verifyPostTranOTP(BuildContext context, String otp,
      String convertPoint, int calculatePoint) async {}

  set updateView(RewardExchangeView rewardExchangeViewModel) {}
}

class BasicRewardExchangePresenter implements RewardExchangePresenter {
  late RewardExchangeView view;
  late RewardExchangeViewModel model;

  BasicRewardExchangePresenter() {
    view = RewardExchangeView();
    model = RewardExchangeViewModel();
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
      updatePoints();
    }
    view.refreshModel(model);
  }

  @override
  Future<bool> linkSmileAccount(BuildContext context, String smileId) async {
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.linkSmileAccount,
      context: context,
      data: {
        "sourceProgramCode": AppConstString.bounzVal,
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "targetProgramCode": AppConstString.smilesVal,
        "smiles_id": smileId,
      },
    );
    if (response != null) {
      if (response['status'] == true) {
        model.linkSmileAccModel = LinkSmileAccModel.fromJson(response['data']);
        model.status = response['status'];
        if (model.status == true) {
          final properties = MoEProperties();
          properties
              .addAttribute(TriggeringCondition.programAccountId, smileId)
              .addAttribute(TriggeringCondition.linkedStatus, true)
              .setNonInteractiveEvent();
          MoenageManager.logEvent(
            MoenageEvent.linkAccountButtonClick,
            properties: properties,
          );
          return true;
        }
      } else {
        await unLinkSmileAccount(context, true, smileId);
      }
    }
    return false;
  }

  @override
  Future<bool> unLinkSmileAccount(
      BuildContext context, bool isFromLinkAcc, String smileId) async {
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.unLinkSmileAccount,
      data: {
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "targetProgramCode": AppConstString.smilesVal,
        "sourceProgramCode": AppConstString.bounzVal,
        "smiles_id": model.smilesMemberID,
      },
    );
    if (response != null) {
      if (isFromLinkAcc) {
        linkSmileAccount(context, model.smilesMemberID!);
      } else {
        return response['status'];
      }
    }
    return false;
  }

  @override
  Future otpVerifyHash(BuildContext context, String smileId, String otp,
      Function() showBottomSheetInvalid, Function() timedOutBottomSheet) async {
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.verifyHashOtp,
      context: context,
      data: {
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "targetProgramCode": AppConstString.smilesVal,
        "smiles_id": smileId,
        "otp": otp,
        "sourceProgramCode": AppConstString.bounzVal
      },
    );
    if (response != null) {
      if (response['status'] == true) {
        getAllMemberData(context);
      } else if (response["message"] == "timeout") {
        timedOutBottomSheet();
      } else {
        showBottomSheetInvalid();
      }
    }
  }

  @override
  Future<bool> postTransactionToBlockChain(
      BuildContext context,
      String convertPoint,
      int calculatePoint,
      Function() sessionExpireAlert) async {
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.postTransactionToBlockchain,
      data: {
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "smiles_id": model.smilesMemberID,
        "convert_point": convertPoint,
        "calculate_point": calculatePoint,
        "sourceProgramCode": AppConstString.bounzVal,
        "targetProgramCode": AppConstString.smilesVal,
        "point": (GlobalSingleton.userInformation.pointBalance!.toString())
            .replaceAll(",", ""),
        "transactionSubType":
            model.dropdownValue == AppAssets.bounzText ? "SO" : "OS",
      },
    );
    if (response != null) {
      model.linkSmileAccModel = LinkSmileAccModel.fromJson(response['data']);
      if (model.linkSmileAccModel != null) {
        if (model.linkSmileAccModel!.status == true) {
          if (model.linkSmileAccModel!.message == 'Success') {
            getAllMemberData(context);
            return true;
          } else if (model.linkSmileAccModel!.message ==
              'OTP Send successfully') {
            sessionExpireAlert();
          }
        }
      }
    }
    return false;
  }

  @override
  Future verifyPostTranOTP(BuildContext context, String otp,
      String convertPoint, int calculatePoint) async {
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.verifyPostTranOtp,
      context: context,
      data: {
        "transactionSubType": "OS",
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "smiles_id": model.smilesMemberID,
        "convert_point": convertPoint,
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
        getAllMemberData(context);
      }
    }
  }

  @override
  set updateView(RewardExchangeView rewardExchangeViewModel) {
    view = rewardExchangeViewModel;
    view.refreshModel(model);
  }

  void updatePoints() {
    bool isLinked = false;

    if (model.allMemberModel?.linkedPartners!.length != null) {
      isLinked = model.allMemberModel!.linkedPartners!.isEmpty ? false : true;
    }
    model.range ??= double.parse(pointsFormatter(0));
    if (model.allMemberModel != null && isLinked) {
      for (int j = 0; j < model.allMemberModel!.linkedPartners!.length; j++) {
        model.smilesPointsBal = double.parse(
            model.allMemberModel!.linkedPartners![j].points.toString());
        if (model.dropdownValue == AppAssets.bounzText) {
          model.range = model.smilesPointsBal?.toDouble();
        }
        model.smilesMemberID =
            model.allMemberModel!.linkedPartners![j].targetMembershipNo;
        model.conversionRate = (model.dropdownValue == AppAssets.bounzText)
            ? (model.allMemberModel!.linkedPartners![j].so!.nominator! /
                    model.allMemberModel!.linkedPartners![j].so!.denominator!) *
                1.0
            : (model.allMemberModel!.linkedPartners![j].os!.nominator! /
                    model.allMemberModel!.linkedPartners![j].os!.denominator!) *
                1.0;

        model.roundOffMethod = (model.dropdownValue == AppAssets.bounzText)
            ? model.allMemberModel!.linkedPartners![j].so!.roundOffMethod
            : model.allMemberModel!.linkedPartners![j].os!.roundOffMethod;

        model.minConversion = (model.dropdownValue == AppAssets.bounzText)
            ? double.parse(model
                .allMemberModel!.linkedPartners![j].so!.minConversion
                .toString())
            : double.parse(model
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
}
