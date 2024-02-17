import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/models/pay_bills/recent_transaction.dart';
import 'package:bounz_revamp_app/models/pay_bills/service_model.dart';
import 'package:bounz_revamp_app/modules/pay_bills/pay_bills_detail/pay_bill_detail_model.dart';
import 'package:bounz_revamp_app/modules/pay_bills/pay_bills_detail/pay_bill_detail_view.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:flutter/material.dart';

class PayBillDetailPresenter {
  Future<void> getRecentTransaction(BuildContext? context) async {}
  set updateView(PayBillDetailView view) {}
}

class BasicPayBillDetailPresenter implements PayBillDetailPresenter {
  late PayBillDetailModel model;
  late PayBillDetailView view;
  BasicPayBillDetailPresenter(ServiceModel serviceModel) {
    view = PayBillDetailView();
    model = PayBillDetailModel(
      serviceModel: serviceModel,
      transactionList: [],
    );
  }

  @override
  set updateView(PayBillDetailView payBillDetailView) {
    view = payBillDetailView;
    view.refreshModel(model);
  }

  @override
  Future<void> getRecentTransaction(BuildContext? context) async {
    List<RecentTransaction> transactionList = [];
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.dtOneEndPoint + ApiPath.payBillTransaction,
      context: context,
      notShowError: true,
      data: {
        "customer_id": GlobalSingleton.userInformation.membershipNo,
      },
    );
    if (response != null) {
      if (response.containsKey('values')) {
        for (Map<String, dynamic> i in response['values']) {
          transactionList.add(RecentTransaction.fromJson(i));
        }
        transactionList
            .sort((a, b) => b.transactionDate!.compareTo(a.transactionDate!));
        GlobalSingleton.transactionList = transactionList;
        model.transactionList = transactionList;
      }
      view.refreshModel(model);
    }
  }
}
