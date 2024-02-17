import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/models/pay_bills/product_model.dart';
import 'package:bounz_revamp_app/modules/bills/bills_screen_model.dart';
import 'package:bounz_revamp_app/modules/bills/bills_screen_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';

class BillsScreenPresenter {
  Future<void> getStatmentData({
    required BuildContext context,
    required ProductModel productModel,
    required String actNumberController,
    required String accountQualifier,
    String? phoneController,
    String? countryCode,
  }) async {}
  set updateView(BillsScreenView value) {}
}

class BasicBillsScreenPresenter implements BillsScreenPresenter {
  late BillScreenModel model;
  late BillsScreenView view;

  BasicBillsScreenPresenter() {
    view = BillsScreenView();
    model = BillScreenModel();
  }

  @override
  Future<void> getStatmentData({
    required BuildContext context,
    required ProductModel productModel,
    required String actNumberController,
    required String accountQualifier,
    String? countryCode,
    String? phoneController,
  }) async {
    Map data = {
      "membership_no": GlobalSingleton.userInformation.membershipNo,
      "product_id": productModel.productId,
    };
    if (phoneController?.isNotEmpty == true) {
      data["mobile_number"] =  phoneController!;
      data["account_number"] = phoneController;
    }
    if (actNumberController.isNotEmpty) {
      data["account_number"] = actNumberController;
    }
    if (accountQualifier.isNotEmpty) {
      data["account_qualifier"] = accountQualifier;
    }
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.dtOneEndPoint + ApiPath.getstatement,
      data: data,
      notShowError: true,
      context: context,
    );
    model.result = [];
    if (response != null) {
      model = BillScreenModel.fromJson(response);
    }
    view.refreshModel(model);
  }

  @override
  set updateView(BillsScreenView billsScreenView) {
    view = billsScreenView;
    view.refreshModel(model);
  }
}
