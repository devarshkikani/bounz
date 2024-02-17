import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/models/reward_exchange/all_member_data.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/select_reward_exchange/reward_ex_selecttion_model.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/select_reward_exchange/reward_ex_selecttion_view.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:flutter/material.dart';

class SelectRewardExchangePresenter {
  Future<bool> unLinkSmileAccount(
      BuildContext context,String smileId) async {
    return false;
  }
  Future getAllMemberData(BuildContext context) async {}

  set updateView(SelectRewardExchangeView infoRewardExchangeView) {}
}

class BasicSelectRewardExchangePresenter implements SelectRewardExchangePresenter {
  late SelectRewardExchangeView view;
  late SelectRewardExchangeViewModel model;
  int pointApiCalled = 0;
  int memberApiCalled = 0;

  BasicSelectRewardExchangePresenter() {
    view = SelectRewardExchangeView();
    model = SelectRewardExchangeViewModel();
  }

  @override
  Future<bool> unLinkSmileAccount(BuildContext context,String smileId) async {

    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.unLinkSmileAccount,
      context: context,
      data: {
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "targetProgramCode": AppConstString.smilesVal,
        "sourceProgramCode": AppConstString.bounzVal,
        "smiles_id": smileId,
      },
    );
    if (response != null) {
      return response['status'];
    }
    return false;
  }

  @override
  Future getAllMemberData(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.getAllMembership,
      //context: context,
      data: {
        "sourceProgramCode": AppConstString.bounzVal,
        "membership_no": GlobalSingleton.userInformation.membershipNo,
      },
    );
    if (response != null) {
      model.allMemberModel = DataAllMember.fromJson(response['data']);

    }
    view.refreshModel(model);
  }

  @override
  set updateView(SelectRewardExchangeView selectRewardExchangeView) {
    view = selectRewardExchangeView;
    view.refreshModel(model);
  }
}
