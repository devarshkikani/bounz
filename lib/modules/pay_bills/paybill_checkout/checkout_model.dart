import 'package:bounz_revamp_app/models/pay_bills/product_model.dart';

class CheckoutModel {
  final ProductModel productModel;
  String? phoneNumber;
  String? countryCode;
  String? accountNumber;
  String? accountQualifier;
  num? redemptionRate;
  num? offerPloughbackFactor;
  num? rpm;
  bool? isFromRange;
  bool bounzApply;

  CheckoutModel({
    required this.productModel,
    required this.bounzApply,
    this.isFromRange,
    this.phoneNumber,
    this.countryCode,
    this.accountNumber,
    this.accountQualifier,
    this.redemptionRate,
    this.offerPloughbackFactor,
    this.rpm,
  });
}
