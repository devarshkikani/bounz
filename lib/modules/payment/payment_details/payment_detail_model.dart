import 'package:bounz_revamp_app/constants/enum.dart';

class PaymentDetailsModel {
  bool bounzApply;
  int totalPoints;
  num payBounz;
  GiftFor giftFor;
  Map<String, dynamic>? friendData;
  final num redeemptionRate;
  final String image;
  final String name;
  final String earnUpTo;
  final String currency;
  final num price;
  final int giftcardId;
  final String supplierCode;
  final String giftCategory;
  PaymentDetailsModel({
    required this.redeemptionRate,
    required this.price,
    required this.payBounz,
    required this.totalPoints,
    required this.giftFor,
    required this.giftcardId,
    required this.bounzApply,
    required this.giftCategory,
    required this.supplierCode,
    required this.image,
    required this.name,
    required this.earnUpTo,
    required this.currency,
    this.friendData,
  });
}
