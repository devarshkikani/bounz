// To parse this JSON data, do
//
//     final redeemOffer = redeemOfferFromJson(jsonString);

import 'dart:convert';

RedeemOffer redeemOfferFromJson(String str) => RedeemOffer.fromJson(json.decode(str));

String redeemOfferToJson(RedeemOffer data) => json.encode(data.toJson());

class RedeemOffer {
  bool? status;
  int? statuscode;
  String? message;
  Data? data;

  RedeemOffer({
    this.status,
    this.statuscode,
    this.message,
    this.data,
  });

  factory RedeemOffer.fromJson(Map<String, dynamic> json) => RedeemOffer(
    status: json["status"],
    statuscode: json["statuscode"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statuscode": statuscode,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  String? message;
  String? code;
  bool? status;
  List<RedeemOfferValues>? values;

  Data({
    this.message,
    this.code,
    this.status,
    this.values,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    message: json["message"],
    code: json["code"],
    status: json["status"],
    values: json["values"] == null
        ? []
        : List<RedeemOfferValues>.from(json["values"]!.map((x) => RedeemOfferValues.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "code": code,
    "status": status,
    "values": values == null
        ? []
        : List<RedeemOfferValues>.from(values!.map((x) => x.toJson())),
  };
}

RedeemOfferValues redeemOfferValuesFromJson(String str) => RedeemOfferValues.fromJson(json.decode(str));

String redeemOfferValuesToJson(RedeemOfferValues data) => json.encode(data.toJson());

class RedeemOfferValues {
  String? transactionId;
  String? brandName;
  String? brandImage;
  String? outletName;
  String? outletImage;
  String? cashierId;
  String? invoiceNo;
  String? totalAmount;
  String? pointsEarned;
  String? pointsRedeemed;
  String? transactionType;
  String? transactionDate;
  String? offerDescription;
  String? categoryName;

  RedeemOfferValues({
    this.transactionId,
    this.brandName,
    this.brandImage,
    this.outletName,
    this.outletImage,
    this.cashierId,
    this.invoiceNo,
    this.totalAmount,
    this.pointsEarned,
    this.pointsRedeemed,
    this.transactionType,
    this.transactionDate,
    this.offerDescription,
    this.categoryName,
  });

  factory RedeemOfferValues.fromJson(Map<String, dynamic> json) => RedeemOfferValues(
    transactionId: json["transaction_id"],
    brandName: json["brand_name"],
    brandImage: json["brand_image"],
    outletName: json["outlet_name"],
    outletImage: json["outlet_image"],
    cashierId: json["cashier_id"],
    invoiceNo: json["invoice_no"],
    totalAmount: json["total_amount"],
    pointsEarned: json["points_earned"],
    pointsRedeemed: json["points_redeemed"],
    transactionType: json["transaction_type"],
    transactionDate: json["transaction_date"],
    offerDescription: json["offer_description"],
    categoryName: json["category_name"],
  );

  Map<String, dynamic> toJson() => {
    "transaction_id": transactionId,
    "brand_name": brandName,
    "brand_image": brandImage,
    "outlet_name": outletName,
    "outlet_image": outletImage,
    "cashier_id": cashierId,
    "invoice_no": invoiceNo,
    "total_amount": totalAmount,
    "points_earned": pointsEarned,
    "points_redeemed": pointsRedeemed,
    "transaction_type": transactionType,
    "transaction_date": transactionDate,
    "offer_description": offerDescription,
    "category_name": categoryName,
  };
}

