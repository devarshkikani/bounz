import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/link_smile_acc/link_smile_account.dart';
import 'package:bounz_revamp_app/models/reward_exchange/all_member_data.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/link_acc_reward_exchange/link_acc_reward_exchange_model.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/link_acc_reward_exchange/link_acc_reward_exchange_view.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:flutter/material.dart';
import 'package:moengage_flutter/properties.dart';

class LinkAccRewardExchangePresenter {
  Future linkSmileAccount(BuildContext context, String smileId) async {}
  Future unLinkSmileAccount(
      BuildContext context, bool isFromLinkAcc, String smileId) async {
    return false;
  }

  Future otpVerifyHash(
      BuildContext context,
      String smileId,
      String otp,
      Function() showBottomSheetInvalid,
      Function() timedOutBottomSheet,
      Function() redirectToSelection) async {}
  Future<bool> getAllMemberData(BuildContext context) async {
    return false;
  }

  set updateView(LinkAccRewardExchangeView infoRewardExchangeView) {}
}

class BasicLinkAccRewardExchangePresenter
    implements LinkAccRewardExchangePresenter {
  late LinkAccRewardExchangeView view;
  late LinkAccRewardExchangeViewModel model;

  BasicLinkAccRewardExchangePresenter() {
    view = LinkAccRewardExchangeView();
    model = LinkAccRewardExchangeViewModel();
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
  Future unLinkSmileAccount(
      BuildContext context, bool isFromLinkAcc, String smileId) async {
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.unLinkSmileAccount,
      data: {
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "targetProgramCode": AppConstString.smilesVal,
        "sourceProgramCode": AppConstString.bounzVal,
        "smiles_id": smileId,
      },
    );
    if (response != null) {
      if (isFromLinkAcc) {
        await linkSmileAccount(context, smileId);
      }
    }
    return false;
  }

  @override
  Future<bool> getAllMemberData(BuildContext context) async {
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
      if (model.allMemberModel?.linkedPartners!.length != null) {
        bool isLinked =
            model.allMemberModel!.linkedPartners!.isEmpty ? false : true;

        if (isLinked) {
          StorageManager.setStringValue(
              key: AppStorageKey.smileId,
              value:
                  model.allMemberModel!.linkedPartners![0].targetMembershipNo!);
          StorageManager.setStringValue(
              key: AppStorageKey.smileBal,
              value: (double.parse(model
                      .allMemberModel!.linkedPartners![0].points
                      .toString()))
                  .toString());
        }
        return true;
      }
    }
    view.refreshModel(model);
    return false;
  }

  @override
  Future otpVerifyHash(
      BuildContext context,
      String smileId,
      String otp,
      Function() showBottomSheetInvalid,
      Function() timedOutBottomSheet,
      Function() redirectToSelection) async {
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
        redirectToSelection();
      } else if (response["message"] == "timeout") {
        timedOutBottomSheet();
      } else {
        showBottomSheetInvalid();
      }
    }
  }

  @override
  set updateView(LinkAccRewardExchangeView linkAccRewardExchangeView) {
    view = linkAccRewardExchangeView;
    view.refreshModel(model);
  }
}
