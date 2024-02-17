import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/models/link_smile_acc/link_smile_account.dart';
import 'package:bounz_revamp_app/models/reward_exchange/all_member_data.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/bounz_to_smile/bounz_to_smile_model.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/bounz_to_smile/bounz_to_smile_view.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/utils/progress_indicator.dart';
import 'package:flutter/material.dart';

class BounzToSmilePresenter {
  Future getAllMemberData() async {}

  Future getLatestPartnerPointsRefresh(String smileId) async {}

  Future<bool> postTransactionToBlockChain(
      BuildContext context, String convertPoint, int calculatePoint) async {
    return false;
  }

  set updateView(BounzToSmileView bounzToSmileView) {}
}

class BasicBounzToSmilePresenter implements BounzToSmilePresenter {
  late BounzToSmileView view;
  late BounzToSmileViewModel model;
  int pointApiCalled = 0;
  int memberApiCalled = 0;

  BasicBounzToSmilePresenter() {
    view = BounzToSmileView();
    model = BounzToSmileViewModel(isLoading: Circle(), conversionRate: 0.5);
  }

  @override
  Future getAllMemberData() async {
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.getAllMembership,
      data: {
        "sourceProgramCode": AppConstString.bounzVal,
        "membership_no": GlobalSingleton.userInformation.membershipNo,
      },
    );
    if (response != null) {
      model.allMemberModel = DataAllMember.fromJson(response['data']);
      updatePoints();
      var diffMin = model.allMemberModel!.timestamp!
          .difference(model.allMemberModel!.linkedPartners![0].nowValue!)
          .inMinutes;
      if (diffMin > 120 && memberApiCalled <= 10) {
        if (GlobalSingleton.isBack) {
          return;
        }
        Future.delayed(const Duration(seconds: 5), () {
          memberApiCalled++;
          getAllMemberData(); // 10 times, // 5 sec delay
        });
      } else {
        NetworkDio.showError(
            title: "No Data", errorMessage: "Issue Fetching Data");
        return;
      }
    }
    view.refreshModel(model);
  }

  @override
  set updateView(BounzToSmileView bounzToSmileView) {
    view = bounzToSmileView;
    view.refreshModel(model);
  }

  @override
  Future getLatestPartnerPointsRefresh(String smileId) async {
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.getLatestPartnerPoints,
      data: {
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "smiles_id": model.smileId,
      },
    );
    if (response != null) {
      if (response['status'] == true || pointApiCalled == 3) {
        Future.delayed(const Duration(seconds: 5), () {
          getAllMemberData(); // add 5 sec wait
        });
      } else {
        pointApiCalled++;
        Future.delayed(const Duration(seconds: 2), () {
          getLatestPartnerPointsRefresh(smileId); // add 1 sec wait
        });
      }
    }
    view.refreshModel(model);
  }

  @override
  Future<bool> postTransactionToBlockChain(
      BuildContext context, String convertPoint, int calculatePoint) async {
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.postTransactionToBlockchain,
      context: context,
      data: {
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "smiles_id": model.smileId,
        "convert_point": int.parse(convertPoint),
        "calculate_point": calculatePoint,
        "sourceProgramCode": AppConstString.bounzVal,
        "targetProgramCode": AppConstString.smilesVal,
        "transactionSubType": "SO",
      },
    );
    if (response != null) {
      model.linkSmileAccModel = LinkSmileAccModel.fromJson(response['data']);
      if (model.linkSmileAccModel != null) {
        if (model.linkSmileAccModel!.status == true) {
          if (model.linkSmileAccModel!.message == 'Success') {
            getAllMemberData();
            getProfileData(context);
            return true;
          }
        }
      }
    }
    return false;
  }

  Future getProfileData(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.getProfile,
      //context: context,
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

  void updatePoints() {
    model.range ??= double.parse(pointsFormatter(0));
    for (int j = 0; j < model.allMemberModel!.linkedPartners!.length; j++) {
      model.smilesPointsBal = double.parse(
          model.allMemberModel!.linkedPartners![j].points.toString());
      model.range = model.smilesPointsBal?.toDouble();
      model.smilesMemberID =
          model.allMemberModel!.linkedPartners![j].targetMembershipNo;
      model.conversionRate =
          (model.allMemberModel!.linkedPartners![j].so!.nominator! /
                  model.allMemberModel!.linkedPartners![j].so!.denominator!) *
              1.0;

      model.conversionRateB =
          model.allMemberModel!.linkedPartners![j].so!.denominator! / 1000;
      model.conversionRateS =
          model.allMemberModel!.linkedPartners![j].so!.nominator! / 1000;

      model.roundOffMethod =
          model.allMemberModel!.linkedPartners![j].so!.roundOffMethod;
      model.multiple = model.allMemberModel!.linkedPartners![j].so!.multipleOf;

      model.minConversion = double.parse(model
          .allMemberModel!.linkedPartners![j].so!.minConversion
          .toString());

      if (model.range! < model.minConversion!) {
        model.availablePoints = false;
      } else {
        model.availablePoints = true;
      }
    }
  }
}
