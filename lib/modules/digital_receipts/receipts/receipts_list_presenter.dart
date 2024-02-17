import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/models/degital_receipts/receipts_model.dart';
import 'package:bounz_revamp_app/modules/digital_receipts/receipts/receipts_list_view.dart';
import 'package:bounz_revamp_app/modules/digital_receipts/receipts/receipts_list_model.dart';

class ReceiptsListModelPresenter {
  Future<void> transactionList({required BuildContext context}) async {}
  set updateModel(ReceiptsListView value) {}
}

class BasicReceiptsListModelPresenter implements ReceiptsListModelPresenter {
  late ReceiptsListView view;
  late ReceiptsListModel model;
  BasicReceiptsListModelPresenter() {
    view = ReceiptsListView();
    model = ReceiptsListModel();
  }

  @override
  Future<void> transactionList({required BuildContext context}) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      context: context,
      notShowError: true,
      url: ApiPath.apiEndPoint + ApiPath.getInvoiceDetails,
      data: {
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        "limit": 20,
        "offset": model.offset,
      },
    );
    if(model.offset == 0){
      model.receiptsList = [];
    }
    if (response != null) {
      model.transactionCount = response['values']['transaction_count'];
      for (Map<String, dynamic> e in response['values']['transaction_data']) {
          model.receiptsList!.add(Receipts.fromJson(e));
      }
      model.offset = model.offset + 20;
    }
    view.refreshModel(model);
  }

  @override
  set updateModel(ReceiptsListView value) {
    view = value;
    view.refreshModel(model);
  }
}
