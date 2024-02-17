import 'dart:async';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/models/purchased_history_card/purchased_history_card.dart';
import 'package:bounz_revamp_app/modules/my_purchase/purchase_history/purchased_history_view.dart';
import 'package:bounz_revamp_app/modules/my_purchase/purchase_history/purchased_history_model.dart';

class PurchasedHistoryPresenter {
  Future<void> getMyTransactions() async {}
  set modelUpdate(PurchasedHistoryView purchasedHistoryView) {}
}

class BasicPurchasedHistoryPresenter implements PurchasedHistoryPresenter {
  late PurchasedHistoryModel model;
  late PurchasedHistoryView view;
  BasicPurchasedHistoryPresenter() {
    view = PurchasedHistoryView();
    model = PurchasedHistoryModel();
  }

  @override
  Future getMyTransactions() async {
    Map<String, dynamic>? response =
        await NetworkDio.getGiftVoucherDioHttpMethod(
      url: ApiPath.giftCardEndPoint + ApiPath.myTransactions,
      queryParameters: {
        'customer_id': GlobalSingleton.userInformation.membershipNo,
      },
    );
    model.purchasedHistoryList = [];
    if (response != null) {
      if (response['code'] == 'trnx_0006') {
        List<PurchasedHistoryCard> purchasedHistoryList = [];
        for (Map<String, dynamic> i in response['objects']) {
          purchasedHistoryList.add(PurchasedHistoryCard.fromJson(i));
        }
        model.offerPloughbackFactor = response['offer_ploughback_factor'];
        model.redemptionRate = response['redemption_rate'];
        model.rpm = response['rpm'];
        model.purchasedHistoryList = purchasedHistoryList;
      }
    }
    view.refreshModel(model);
  }

  @override
  set modelUpdate(PurchasedHistoryView purchasedHistoryView) {
    view = purchasedHistoryView;
    view.refreshModel(model);
  }
}
