import 'dart:convert';
// To parse this JSON data, do
//
//     final bounzEarnModel = bounzEarnModelFromJson(jsonString);

BounzEarnModel bounzEarnModelFromJson(String str) =>
    BounzEarnModel.fromJson(json.decode(str));

String bounzEarnModelToJson(BounzEarnModel data) => json.encode(data.toJson());

class BounzEarnModel {
  String? transactionId;
  String? customerId;
  dynamic totalAmount;
  String? outletCode;
  String? storeCode;
  String? outletName;
  String? storeEmail;
  String? outletImage;
  String? outletAddress;
  String? brandCode;
  String? brandName;
  String? merchantName;
  String? merchantCode;
  String? trxnType;
  String? cashierId;
  String? invoiceNo;
  String? transactionDate;
  String? pointsEarned;
  String? pointsRedeemed;

  BounzEarnModel({
    this.transactionId,
    this.customerId,
    this.totalAmount,
    this.outletCode,
    this.storeCode,
    this.outletName,
    this.storeEmail,
    this.outletImage,
    this.outletAddress,
    this.brandCode,
    this.brandName,
    this.merchantName,
    this.merchantCode,
    this.trxnType,
    this.cashierId,
    this.invoiceNo,
    this.transactionDate,
    this.pointsEarned,
    this.pointsRedeemed,
  });

  factory BounzEarnModel.fromJson(Map<String, dynamic> json) => BounzEarnModel(
        transactionId: json["transaction_id"],
        customerId: json["customer_id"],
        totalAmount: json["total_amount"],
        outletCode: json["outlet_code"],
        storeCode: json["store_code"],
        outletName: json["outlet_name"],
        storeEmail: json["store_email"],
        outletImage: json["outlet_image"],
        outletAddress: json["outlet_address"],
        brandCode: json["brand_code"],
        brandName: json["brand_name"],
        merchantName: json["merchant_name"],
        merchantCode: json["merchant_code"],
        trxnType: json["trxn_type"],
        cashierId: json["cashier_id"],
        invoiceNo: json["invoice_no"],
        transactionDate: json["transaction_date"],
        pointsEarned: json["points_earned"],
        pointsRedeemed: json["points_redeemed"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "customer_id": customerId,
        "total_amount": totalAmount,
        "outlet_code": outletCode,
        "store_code": storeCode,
        "outlet_name": outletName,
        "store_email": storeEmail,
        "outlet_image": outletImage,
        "outlet_address": outletAddress,
        "brand_code": brandCode,
        "brand_name": brandName,
        "merchant_name": merchantName,
        "merchant_code": merchantCode,
        "trxn_type": trxnType,
        "cashier_id": cashierId,
        "invoice_no": invoiceNo,
        "transaction_date": transactionDate,
        "points_earned": pointsEarned,
        "points_redeemed": pointsRedeemed,
      };
}
