import 'dart:convert';

import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/models/pay_bills/service_model.dart';
import 'package:bounz_revamp_app/modules/pay_bills/pay_bill_home/pay_bills_home_view.dart';
import 'package:bounz_revamp_app/modules/pay_bills/pay_bill_home/pay_bills_home_model.dart';

class PayBillsPresenter {
  Future<void> serviceList({required BuildContext? context}) async {}
  set updateModel(PayBillsView value) {}
}

class BasicPayBillsPresenter implements PayBillsPresenter {
  late PayBillsView view;
  late PayBillsModel model;
  bool isCalling = true;
  BasicPayBillsPresenter() {
    view = PayBillsView();
    model = PayBillsModel();
  }

  @override
  Future<void> serviceList({required BuildContext? context}) async {
    if (isCalling) {
      isCalling = false;
      Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
        context: context,
        url: ApiPath.dtOneEndPoint + ApiPath.servicelist,
        data: {},
      );
      model.serviceTelecomRechargesLists = [];
      model.serviceHouseMoreList = [];
      model.serviceList = [];
      if (response != null) {
        if (response['status'] == true) {
          storeServiceListData(response);
        }
      }
    }
    view.refreshModel(model);
  }

  Future<void> storeServiceListData(Map<String, dynamic> response) async {
    List<ServiceModel> services = [];
    for (var i = 0; i < response['values'].length; i++) {
      if (response['values'][i]['service_id'] == 1 ||
          response['values'][i]['service_id'] == 2 ||
          response['values'][i]['service_id'] == 5) {
        response['values'][i]['category'] = 'Telecom & Recharges';
        response['values'][i]['category_id'] = 1;
      } else {
        response['values'][i]['category'] = 'Household & More';
        response['values'][i]['category_id'] = 2;
      }
      if (response['values'][i]['service_id'] != 4) {
        services.add(ServiceModel.fromJson(response['values'][i]));
      }
    }
    final List<List<ServiceModel>> groupedData = services.groupBy('category');
    for (List<ServiceModel> e in groupedData) {
      model.serviceList!.add(e);
    }
    convertNetworkToFile();
  }

  Future<void> convertNetworkToFile() async {
    for (var i = 0; i < model.serviceList!.length; i++) {
      for (int j = 0; j < model.serviceList![i].length; j++) {
        if (!(model.serviceList![i][j].serviceImgUrl
            .toString()
            .contains('['))) {
          final http.Response responseData =
              await http.get(Uri.parse(model.serviceList![i][j].serviceImgUrl));
          Uint8List uint8list = responseData.bodyBytes;
          model.serviceList![i][j].serviceImgUrl = uint8list.toString();
        }
      }
    }
    StorageManager.setStringValue(
        key: AppStorageKey.storePayBillImage,
        value: jsonEncode(model.serviceList));
  }

  @override
  set updateModel(PayBillsView value) {
    view = value;
    view.refreshModel(model);
  }
}

extension UtilListExtension on List<ServiceModel> {
  groupBy(String key) {
    try {
      List<List<ServiceModel>> result = [];
      List<String> keys = [];

      for (var f in this) {
        keys.add(f.category);
      }

      for (var k in [...keys.toSet()]) {
        List<ServiceModel> data = [...where((e) => e.category == k)];
        result.add(data);
      }

      return result;
    } catch (e) {
      return this;
    }
  }
}
