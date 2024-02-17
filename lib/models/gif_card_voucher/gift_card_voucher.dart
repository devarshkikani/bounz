import 'dart:convert';
// To parse this JSON data, do
//
//     final giftCardVoucher = giftCardVoucherFromJson(jsonString);

GiftCardVoucher giftCardVoucherFromJson(String str) =>
    GiftCardVoucher.fromJson(json.decode(str));

String giftCardVoucherToJson(GiftCardVoucher data) =>
    json.encode(data.toJson());

class GiftCardVoucher {
  int? giftcardId;
  String? name;
  String? supplierCode;
  String? supplierName;
  String? mobileImage;
  String? categoryName;
  String? categoryCode;
  String? brand;
  String? productType;
  String? denominationType;
  dynamic denominationFrom;
  dynamic denominationTo;
  num? homePgDenomination;
  String? fixedDenominationAmount;
  String? country;
  String? currency;
  dynamic currConvRate;
  int? earnPoints;
  int? payWithPoints;

  GiftCardVoucher({
    this.giftcardId,
    this.name,
    this.supplierCode,
    this.supplierName,
    this.mobileImage,
    this.categoryName,
    this.categoryCode,
    this.brand,
    this.productType,
    this.denominationType,
    this.denominationFrom,
    this.denominationTo,
    this.homePgDenomination,
    this.fixedDenominationAmount,
    this.country,
    this.currency,
    this.currConvRate,
    this.earnPoints,
    this.payWithPoints,
  });

  factory GiftCardVoucher.fromJson(Map<String, dynamic> json) =>
      GiftCardVoucher(
        giftcardId: json["giftcard_id"],
        name: json["name"],
        supplierCode: json["supplier_code"],
        supplierName: json["supplier_name"],
        mobileImage: json["mobile_image"],
        categoryName: json["category_name"],
        categoryCode: json["category_code"],
        brand: json["brand"],
        productType: json["product_type"],
        denominationType: json["denomination_type"],
        denominationFrom: json["denomination_from"],
        denominationTo: json["denomination_to"],
        homePgDenomination: json["home_pg_denomination"],
        fixedDenominationAmount: json["fixed_denomination_amount"],
        country: json["country"],
        currency: json["currency"],
        currConvRate: json["currConvRate"],
        earnPoints: json["earn_points"],
        payWithPoints: json["pay_with_points"],
      );

  Map<String, dynamic> toJson() => {
        "giftcard_id": giftcardId,
        "name": name,
        "supplier_code": supplierCode,
        "supplier_name": supplierName,
        "mobile_image": mobileImage,
        "category_name": categoryName,
        "category_code": categoryCode,
        "brand": brand,
        "product_type": productType,
        "denomination_type": denominationType,
        "denomination_from": denominationFrom,
        "denomination_to": denominationTo,
        "home_pg_denomination": homePgDenomination,
        "fixed_denomination_amount": fixedDenominationAmount,
        "country": country,
        "currency": currency,
        "currConvRate": currConvRate,
        "earn_points": earnPoints,
        "pay_with_points": payWithPoints,
      };
}
