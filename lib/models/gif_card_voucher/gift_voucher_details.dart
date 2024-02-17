import 'dart:convert';
// To parse this JSON data, do
//
//     final giftVouchersDetail = giftVouchersDetailFromJson(jsonString);

GiftVouchersDetail giftVouchersDetailFromJson(String str) =>
    GiftVouchersDetail.fromJson(json.decode(str));

String giftVouchersDetailToJson(GiftVouchersDetail data) =>
    json.encode(data.toJson());

class GiftVouchersDetail {
  String? message;
  String? code;
  bool? status;
  Objects? objects;
  PriceRange? priceRange;
  double? redemptionRate;
  String? offerPloughbackFactor;
  String? rpm;
  int? total;
  int? limit;
  List<Country>? countries;

  GiftVouchersDetail({
    this.message,
    this.code,
    this.status,
    this.objects,
    this.priceRange,
    this.redemptionRate,
    this.total,
    this.limit,
    this.offerPloughbackFactor,
    this.rpm,
    this.countries,
  });

  factory GiftVouchersDetail.fromJson(Map<String, dynamic> json) =>
      GiftVouchersDetail(
        message: json["message"],
        code: json["code"],
        status: json["status"],
        objects:
            json["objects"] == null ? null : Objects.fromJson(json["objects"]),
        priceRange: json["price_range"] == null
            ? null
            : PriceRange.fromJson(json["price_range"]),
        redemptionRate: json["redemption_rate"]?.toDouble(),
        offerPloughbackFactor: json["offer_ploughback_factor"],
        rpm: json["rpm"],
        total: json["total"],
        limit: json["limit"],
        countries: json["countries"] == null
            ? []
            : List<Country>.from(
                json["countries"]!.map((x) => Country.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "status": status,
        "objects": objects?.toJson(),
        "price_range": priceRange?.toJson(),
        "redemption_rate": redemptionRate,
        "offer_ploughback_factor": offerPloughbackFactor,
        "rpm": rpm,
        "total": total,
        "limit": limit,
        "countries": countries == null
            ? []
            : List<dynamic>.from(countries!.map((x) => x.toJson())),
      };
}

class Country {
  int? countryId;
  String? countryName;
  String? countryCode;
  String? currency;
  PriceRange? priceRange;

  Country({
    this.countryId,
    this.countryName,
    this.countryCode,
    this.currency,
    this.priceRange,
  });

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        countryId: json["country_id"],
        countryName: json["country_name"],
        countryCode: json["country_code"],
        currency: json["currency"],
        priceRange: json["price_range"] == null
            ? null
            : PriceRange.fromJson(json["price_range"]),
      );

  Map<String, dynamic> toJson() => {
        "country_id": countryId,
        "country_name": countryName,
        "country_code": countryCode,
        "currency": currency,
        "price_range": priceRange?.toJson(),
      };
}

class PriceRange {
  int? min;
  int? max;

  PriceRange({
    this.min,
    this.max,
  });

  factory PriceRange.fromJson(Map<String, dynamic> json) => PriceRange(
        min: json["min"],
        max: json["max"],
      );

  Map<String, dynamic> toJson() => {
        "min": min,
        "max": max,
      };
}

class Objects {
  int? giftcardId;
  String? name;
  String? mobileImage;
  dynamic homepageMobileImage;
  String? description;
  dynamic category;
  String? subCategory;
  String? supplierName;
  String? supplierCode;
  String? denominationType;
  String? fixedDenominationAmount;
  String? country;
  String? currency;
  num? currConvRate;
  dynamic termsCondition;
  String? howToRedeem;
  String? productType;
  String? earnPoints;
  String? payWithPoints;
  double? redemptionRate;
  int? offerPloughbackFactor;
  int? rpm;
  int? denominationFrom;
  int? denominationTo;

  Objects({
    this.giftcardId,
    this.name,
    this.mobileImage,
    this.homepageMobileImage,
    this.description,
    this.category,
    this.subCategory,
    this.supplierName,
    this.supplierCode,
    this.denominationType,
    this.fixedDenominationAmount,
    this.country,
    this.currency,
    this.currConvRate,
    this.termsCondition,
    this.howToRedeem,
    this.productType,
    this.earnPoints,
    this.payWithPoints,
    this.redemptionRate,
    this.offerPloughbackFactor,
    this.rpm,
    this.denominationFrom,
    this.denominationTo,
  });

  factory Objects.fromJson(Map<String, dynamic> json) => Objects(
        giftcardId: json["giftcard_id"],
        name: json["name"],
        mobileImage: json["mobile_image"],
        homepageMobileImage: json["homepage_mobile_image"],
        description: json["description"],
        category: json["category"],
        subCategory: json["sub_category"],
        supplierName: json["supplier_name"],
        supplierCode: json["supplier_code"],
        denominationType: json["denomination_type"],
        fixedDenominationAmount: json["fixed_denomination_amount"],
        country: json["country"],
        currency: json["currency"],
        currConvRate: json["currConvRate"],
        termsCondition: json["terms_condition"],
        howToRedeem: json["how_to_redeem"],
        productType: json["product_type"],
        earnPoints: json["earn_points"],
        payWithPoints: json["pay_with_points"],
        redemptionRate: json["redemption_rate"]?.toDouble(),
        offerPloughbackFactor: json["offer_ploughback_factor"],
        rpm: json["rpm"],
        denominationFrom: json["denomination_from"],
        denominationTo: json["denomination_to"],
      );

  Map<String, dynamic> toJson() => {
        "giftcard_id": giftcardId,
        "name": name,
        "mobile_image": mobileImage,
        "homepage_mobile_image": homepageMobileImage,
        "description": description,
        "category": category,
        "sub_category": subCategory,
        "supplier_name": supplierName,
        "supplier_code": supplierCode,
        "denomination_type": denominationType,
        "fixed_denomination_amount": fixedDenominationAmount,
        "country": country,
        "currency": currency,
        "currConvRate": currConvRate,
        "terms_condition": termsCondition,
        "how_to_redeem": howToRedeem,
        "product_type": productType,
        "earn_points": earnPoints,
        "pay_with_points": payWithPoints,
        "redemption_rate": redemptionRate,
        "offer_ploughback_factor": offerPloughbackFactor,
        "rpm": rpm,
        "denomination_from": denominationFrom,
        "denomination_to": denominationTo,
      };
}
