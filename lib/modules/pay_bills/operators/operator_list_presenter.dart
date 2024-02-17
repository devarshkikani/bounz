import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/models/pay_bills/service_model.dart';
import 'package:bounz_revamp_app/models/pay_bills/operator_model.dart';
import 'package:bounz_revamp_app/modules/pay_bills/operators/operator_list_view.dart';
import 'package:bounz_revamp_app/modules/pay_bills/operators/operator_list_model.dart';

class OperatorListPresenter {
  Future<void> operatorList(BuildContext context) async {}
  set updateModel(OperatorListView value) {}
}

class BasicOpreterListPresenter implements OperatorListPresenter {
  late OperatorListModel model;
  late OperatorListView view;
  BasicOpreterListPresenter({
    required ServiceModel serviceModel,
    required Map<String, dynamic> country,
  }) {
    view = OperatorListView();
    model = OperatorListModel(
      country: country,
      opreterList: [],
      serviceModel: serviceModel,
    );
  }

  @override
  Future<void> operatorList(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      context: context,
      notShowError: true,
      url: ApiPath.dtOneEndPoint + ApiPath.operatorlist,
      data: {
        'service_id': model.serviceModel.serviceId,
        'iso_code': model.country['iso_code'],
      },
    );
    model.opreterList = [];
    model.dublicateOpreterList = [];
    if (response != null) {
      if (response['status'] == true && response.containsKey('values')) {
        for (Map<String, dynamic> e in response['values']) {
          model.opreterList.add(OperatorModel.fromJson(e));
          model.dublicateOpreterList!.add(OperatorModel.fromJson(e));
        }
      }
    }
    view.refreshModel(model);
  }

  @override
  set updateModel(OperatorListView value) {
    view = value;
    view.refreshModel(model);
  }
}
