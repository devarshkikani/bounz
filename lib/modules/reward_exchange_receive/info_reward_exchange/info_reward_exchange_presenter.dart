import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/models/reward_exchange/all_member_data.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/info_reward_exchange/info_reward_exchange_model.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/info_reward_exchange/info_reward_exchange_view.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:flutter/material.dart';

class InfoRewardExchangePresenter {
  Future getAllMemberData(BuildContext context) async {}
  set updateView(InfoRewardExchangeView infoRewardExchangeView) {}
}

class BasicInfoRewardExchangePresenter implements InfoRewardExchangePresenter {
  late InfoRewardExchangeView view;
  late InfoRewardExchangeViewModel model;

  BasicInfoRewardExchangePresenter() {
    view = InfoRewardExchangeView();
    model = InfoRewardExchangeViewModel();
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
    }
    view.refreshModel(model);
  }

  @override
  set updateView(InfoRewardExchangeView infoRewardExchangeView) {
    view = infoRewardExchangeView;
    view.refreshModel(model);
  }
}
