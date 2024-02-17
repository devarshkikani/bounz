// To parse this JSON data, do
//
//     final partnerCouponsModel = partnerCouponsModelFromJson(jsonString);

import 'dart:convert';

PartnerCouponsModel partnerCouponsModelFromJson(String str) =>
    PartnerCouponsModel.fromJson(json.decode(str));

String partnerCouponsModelToJson(PartnerCouponsModel data) =>
    json.encode(data.toJson());

class PartnerCouponsModel {
  String? message;
  String? code;
  bool? status;
  List<PartnerCouponList>? values;

  PartnerCouponsModel({
    this.message,
    this.code,
    this.status,
    this.values,
  });

  factory PartnerCouponsModel.fromJson(Map<String, dynamic> json) =>
      PartnerCouponsModel(
        message: json["message"],
        code: json["code"],
        status: json["status"],
        values: json["values"] == null
            ? []
            : List<PartnerCouponList>.from(
                json["values"]!.map((x) => PartnerCouponList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "status": status,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
      };
}

class PartnerCouponList {
  String? partnerName;
  String? couponImg;
  String? couponName;
  String? campaignId;
  String? description;
  String? termsAndConditions;
  String? couponCode;
  DateTime? expiryDate;
  DateTime? creationDate;

  PartnerCouponList({
    this.partnerName,
    this.couponImg,
    this.couponName,
    this.campaignId,
    this.description,
    this.termsAndConditions,
    this.couponCode,
    this.expiryDate,
    this.creationDate,
  });

  factory PartnerCouponList.fromJson(Map<String, dynamic> json) =>
      PartnerCouponList(
        partnerName: json["partner_name"],
        couponImg: json["coupon_img"],
        couponName: json["coupon_name"],
        campaignId: json["campaign_id"],
        description: json["description"],
        termsAndConditions: json["terms_and_conditions"],
        couponCode: json["coupon_code"],
        expiryDate: json["expiry_date"] == null
            ? null
            : DateTime.parse(json["expiry_date"]),
        creationDate: json["creation_date"] == null
            ? null
            : DateTime.parse(json["creation_date"]),
      );

  Map<String, dynamic> toJson() => {
        "partner_name": partnerName,
        "coupon_img": couponImg,
        "coupon_name": couponName,
        "campaign_id": campaignId,
        "description": description,
        "terms_and_conditions": termsAndConditions,
        "coupon_code": couponCode,
        "expiry_date":
            "${expiryDate?.year.toString().padLeft(4, '0')}-${expiryDate?.month.toString().padLeft(2, '0')}-${expiryDate?.day.toString().padLeft(2, '0')}",
        "creation_date": creationDate?.toIso8601String(),
      };
}
