import 'dart:convert';
// To parse this JSON data, do
//
//     final partneroOutletDetailModel = partneroOutletDetailModelFromJson(jsonString);

PartneroOutletDetailModel partneroOutletDetailModelFromJson(String str) =>
    PartneroOutletDetailModel.fromJson(json.decode(str));

String partneroOutletDetailModelToJson(PartneroOutletDetailModel data) =>
    json.encode(data.toJson());

class PartneroOutletDetailModel {
  String? brandCode;
  String? brandName;
  dynamic brandImage;
  dynamic brandTag;
  dynamic brandDetails;
  String? type;
  String? lat;
  String? long;
  String? outletName;
  String? outletAddress;
  String? outletImage;
  String? outletWeekDayOpeningTime;
  String? outletWeekDayClosingTime;
  String? outletWeekEndOpeningTime;
  String? outletWeekEndClosingTime;
  String? outletEmail;
  String? outletCountry;
  String? outletCity;
  String? outletCode;
  String? merchantCode;
  int? distanceInKm;
  List<Offer>? offers;
  List<PartneroOutletDetailModel>? otherBranches;

  PartneroOutletDetailModel({
    this.brandCode,
    this.brandName,
    this.brandImage,
    this.brandTag,
    this.brandDetails,
    this.type,
    this.lat,
    this.long,
    this.outletName,
    this.outletAddress,
    this.outletImage,
    this.outletWeekDayOpeningTime,
    this.outletWeekDayClosingTime,
    this.outletWeekEndOpeningTime,
    this.outletWeekEndClosingTime,
    this.outletEmail,
    this.outletCountry,
    this.outletCity,
    this.outletCode,
    this.merchantCode,
    this.distanceInKm,
    this.offers,
    this.otherBranches,
  });

  factory PartneroOutletDetailModel.fromJson(Map<String, dynamic> json) =>
      PartneroOutletDetailModel(
        brandCode: json["brand_code"],
        brandName: json["brand_name"],
        brandImage: json["brand_image"],
        brandTag: json["brand_tag"],
        brandDetails: json["brand_details"],
        type: json["type"],
        lat: json["lat"],
        long: json["long"],
        outletName: json["outlet_name"],
        outletAddress: json["outlet_address"],
        outletImage: json["outlet_image"],
        outletWeekDayOpeningTime: json["outlet_week_day_opening_time"],
        outletWeekDayClosingTime: json["outlet_week_day_closing_time"],
        outletWeekEndOpeningTime: json["outlet_week_end_opening_time"],
        outletWeekEndClosingTime: json["outlet_week_end_closing_time"],
        outletEmail: json["outlet_email"],
        outletCountry: json["outlet_country"],
        outletCity: json["outlet_city"],
        outletCode: json["outlet_code"],
        merchantCode: json["merchant_code"],
        distanceInKm: json["distance_in_KM"],
        offers: json["offers"] == null
            ? []
            : List<Offer>.from(json["offers"]!.map((x) => Offer.fromJson(x))),
        otherBranches: json["otherBranches"] == null
            ? []
            : List<PartneroOutletDetailModel>.from(json["otherBranches"]!
                .map((x) => PartneroOutletDetailModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "brand_code": brandCode,
        "brand_name": brandName,
        "brand_image": brandImage,
        "brand_tag": brandTag,
        "brand_details": brandDetails,
        "type": type,
        "lat": lat,
        "long": long,
        "outlet_name": outletName,
        "outlet_address": outletAddress,
        "outlet_image": outletImage,
        "outlet_week_day_opening_time": outletWeekDayOpeningTime,
        "outlet_week_day_closing_time": outletWeekDayClosingTime,
        "outlet_week_end_opening_time": outletWeekEndOpeningTime,
        "outlet_week_end_closing_time": outletWeekEndClosingTime,
        "outlet_email": outletEmail,
        "outlet_country": outletCountry,
        "outlet_city": outletCity,
        "outlet_code": outletCode,
        "merchant_code": merchantCode,
        "distance_in_KM": distanceInKm,
        "offers": offers == null
            ? []
            : List<dynamic>.from(offers!.map((x) => x.toJson())),
        "otherBranches": otherBranches == null
            ? []
            : List<dynamic>.from(otherBranches!.map((x) => x.toJson())),
      };
}

class Offer {
  int? ofdId;
  String? offerTitle;
  String? offerCode;
  dynamic offerText;
  String? offerDiscount;
  dynamic offerDescription;
  String? offerLimit;
  String? type;
  dynamic routetype;
  String? vouchercode;
  dynamic url;
  dynamic partnerOfferid;
  dynamic voucherCodeType;
  DateTime? availabiltyDate;
  String? offerTermsCon;
  dynamic affiliateId;
  dynamic ofrUrl;
  String? ofrSkipCode;
  dynamic ofrPinMandatory;
  dynamic offerExpiry;
  dynamic offerPin;
  dynamic partnerId;
  dynamic ofrIosDeepLink;
  dynamic ofrAndroidDeepLink;

  Offer({
    this.ofdId,
    this.offerTitle,
    this.offerCode,
    this.offerText,
    this.offerDiscount,
    this.offerDescription,
    this.offerLimit,
    this.type,
    this.routetype,
    this.vouchercode,
    this.url,
    this.partnerOfferid,
    this.voucherCodeType,
    this.availabiltyDate,
    this.offerTermsCon,
    this.affiliateId,
    this.ofrUrl,
    this.ofrSkipCode,
    this.ofrPinMandatory,
    this.offerExpiry,
    this.offerPin,
    this.partnerId,
    this.ofrIosDeepLink,
    this.ofrAndroidDeepLink,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        ofdId: json["ofd_id"],
        offerTitle: json["offer_title"],
        offerCode: json["offer_code"],
        offerText: json["offer_text"],
        offerDiscount: json["offer_discount"],
        offerDescription: json["offer_description"],
        offerLimit: json["offer_limit"],
        type: json["type"],
        routetype: json["routetype"],
        vouchercode: json["vouchercode"],
        url: json["url"],
        partnerOfferid: json["partner_offerid"],
        voucherCodeType: json["voucher_code_type"],
        availabiltyDate: json["availabilty_date"] == null
            ? null
            : DateTime.parse(json["availabilty_date"]),
        offerTermsCon: json["offer_terms_con"],
        affiliateId: json["affiliate_id"],
        ofrUrl: json["ofr_url"],
        ofrSkipCode: json["ofr_skip_code"],
        ofrPinMandatory: json["ofr_pin_mandatory"],
        offerExpiry: json["offer_expiry"],
        offerPin: json["offer_pin"],
        partnerId: json["partner_id"],
        ofrIosDeepLink: json["ofr_ios_deep_link"],
        ofrAndroidDeepLink: json["ofr_android_deep_link"],
      );

  Map<String, dynamic> toJson() => {
        "ofd_id": ofdId,
        "offer_title": offerTitle,
        "offer_code": offerCode,
        "offer_text": offerText,
        "offer_discount": offerDiscount,
        "offer_description": offerDescription,
        "offer_limit": offerLimit,
        "type": type,
        "routetype": routetype,
        "vouchercode": vouchercode,
        "url": url,
        "partner_offerid": partnerOfferid,
        "voucher_code_type": voucherCodeType,
        "availabilty_date": availabiltyDate?.toIso8601String(),
        "offer_terms_con": offerTermsCon,
        "affiliate_id": affiliateId,
        "ofr_url": ofrUrl,
        "ofr_skip_code": ofrSkipCode,
        "ofr_pin_mandatory": ofrPinMandatory,
        "offer_expiry": offerExpiry,
        "offer_pin": offerPin,
        "partner_id": partnerId,
        "ofr_ios_deep_link": ofrIosDeepLink,
        "ofr_android_deep_link": ofrAndroidDeepLink,
      };
}