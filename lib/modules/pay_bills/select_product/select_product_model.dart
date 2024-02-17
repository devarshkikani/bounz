import 'package:bounz_revamp_app/models/pay_bills/product_model.dart';
import 'package:bounz_revamp_app/models/pay_bills/service_model.dart';
import 'package:bounz_revamp_app/models/pay_bills/operator_model.dart';

class SelectProductModel {
  final ServiceModel serviceModel;
  final OperatorModel operatorModel;
  Map<String, dynamic> country;
  Map<String, dynamic>? calulationDetails;
  List<ProductModel> productList;
  List<ProductModel>? dublicateProductList;

  SelectProductModel({
    required this.serviceModel,
    required this.operatorModel,
    required this.productList,
    required this.country,
    this.dublicateProductList,
    this.calulationDetails,
  });
}
