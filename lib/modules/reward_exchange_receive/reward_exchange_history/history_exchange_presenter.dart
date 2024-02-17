import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/models/reward_exchange/history_exchange.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/reward_exchange_history/history_exchange_model.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/reward_exchange_history/history_exchange_view.dart';

import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryExchangePresenter {
  Future getHistoryList(BuildContext context) async {}

  set updateView(HistoryExchangeView historyExchangeView) {}
}

class BasicHistoryExchangePresenter implements HistoryExchangePresenter {
  late HistoryExchangeView view;
  late HistoryExchangeViewModel model;

  BasicHistoryExchangePresenter() {
    view = HistoryExchangeView();
    model = HistoryExchangeViewModel();
  }

  @override
  Future getHistoryList(BuildContext context) async {

    String todayDate = DateFormat('yyyy-MM-ddTHH:mm:ssZ').format(DateTime.now().toUtc());
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.apiEndPoint + ApiPath.transactionList,
      context: context,
      data: {
        "sourceProgramCode": AppConstString.bounzVal,
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "start_date": "2023-03-02T09:39:43.902Z",
        "end_date": todayDate,
        "page_no": "1",
        "page_size":"100"
      },
    );
    if (response != null) {
      List<HistoryDataList> historyDataList = [];
      for (Map<String, dynamic> i in response['data']) {
        historyDataList.add(HistoryDataList.fromJson(i));
      }
      model.historyList = historyDataList;
    }
    view.refreshModel(model);
  }

  @override
  set updateView(HistoryExchangeView historyExchangeView) {
    view = historyExchangeView;
    view.refreshModel(model);
  }
}
