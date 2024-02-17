import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/models/pay_bills/product_model.dart';
import 'package:bounz_revamp_app/models/pay_bills/service_model.dart';
import 'package:bounz_revamp_app/models/pay_bills/operator_model.dart';
import 'package:bounz_revamp_app/modules/pay_bills/select_product/select_product_view.dart';
import 'package:bounz_revamp_app/modules/pay_bills/select_product/select_product_model.dart';

class SelectProductPresenter {
  Future<void> getProductList(BuildContext context) async {}
  set updateModel(SelectProductView value) {}
}

class BasicSelectProductPresenter implements SelectProductPresenter {
  late SelectProductModel model;
  late SelectProductView view;
  BasicSelectProductPresenter({
    required ServiceModel serviceModel,
    required OperatorModel operatorModel,
    required Map<String, dynamic> country,
  }) {
    view = SelectProductView();
    model = SelectProductModel(
      operatorModel: operatorModel,
      productList: [],
      country: country,
      serviceModel: serviceModel,
    );
  }

  @override
  Future<void> getProductList(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      context: context,
      url: ApiPath.dtOneEndPoint + ApiPath.productList,
      data: {
        'service_id': model.serviceModel.serviceId,
        'iso_code': model.operatorModel.isoCode,
        'operator_id': model.operatorModel.operatorId,
      },
    );
    model.productList = [];
    model.dublicateProductList = [];
    if (response != null) {
      if (response['status'] == true && response.containsKey('values')) {
        model.calulationDetails = {
          "redemption_rate": response['redemption_rate'],
          "offer_ploughback_factor": response['offer_ploughback_factor'],
          "rpm": response['rpm']
        };
        for (Map<String, dynamic> e in response['values']) {
          ProductModel productModel = ProductModel.fromJson(e);
          productModel.operatorImgUrl = model.operatorModel.operatorImgUrl;
          model.productList.add(productModel);
          model.dublicateProductList!.add(productModel);
        }
        model.productList[0].name == "Open_Range payment"
            ? AutoRouter.of(context).replace(
                AddDetailsScreenRoute(
                  productModel: model.dublicateProductList![0],
                  calulationDetails: model.calulationDetails ?? {},
                  country: model.country,
                  accountNumbe: null,
                  accountQualifier: null,
                  phoneNumber: null,
                ),
              )
            : null;
      }
    }

    view.refreshModel(model);
  }

  @override
  set updateModel(SelectProductView value) {
    view = value;
    view.refreshModel(model);
  }
}
