// To parse this JSON data, do
//
//     final newPartnerDetailModel = newPartnerDetailModelFromJson(jsonString);

import 'dart:convert';

NewPartnerDetailModel newPartnerDetailModelFromJson(String str) =>
    NewPartnerDetailModel.fromJson(json.decode(str));

String newPartnerDetailModelToJson(NewPartnerDetailModel data) =>
    json.encode(data.toJson());

class NewPartnerDetailModel {
  int? id;
  String? name;
  String? image;
  String? newImage;
  String? catName;
  String? catCode;
  List<BrandCat>? brandCat;
  List<AllBranch>? allBranches;
  String? merchantCode;
  String? redeemUi;
  String? brandCode;
  String? brandText;
  String? brandTermsCondition;
  String? brandStaffKey;
  String? partnerId;
  List<DataListLobType>? lobTypes;
  String? termsConditions;
  bool? partInRedeem;
  bool? isPinBased;
  dynamic accrualRate;
  String? redemptionRate;
  String? isExternalBrowser;
  List<PartnerCategory>? partnerCategories;
  List<int>? outletIds;

  NewPartnerDetailModel({
    this.id,
    this.name,
    this.image,
    this.newImage,
    this.catName,
    this.catCode,
    this.brandCat,
    this.allBranches,
    this.merchantCode,
    this.redeemUi,
    this.brandCode,
    this.brandText,
    this.brandTermsCondition,
    this.brandStaffKey,
    this.partnerId,
    this.lobTypes,
    this.termsConditions,
    this.partInRedeem,
    this.isPinBased,
    this.accrualRate,
    this.redemptionRate,
    this.isExternalBrowser,
    this.partnerCategories,
    this.outletIds,
  });

  factory NewPartnerDetailModel.fromJson(Map<String, dynamic> json) =>
      NewPartnerDetailModel(
        id: json["id"],
        name: json["name"],
        image: json["image"],
        newImage: json["new_image"],
        catName: json["cat_name"],
        catCode: json["cat_code"],
        brandCat: json["brand_cat"] == null
            ? []
            : List<BrandCat>.from(
                json["brand_cat"]!.map((x) => BrandCat.fromJson(x))),
        allBranches: json["all_branches"] == null
            ? []
            : List<AllBranch>.from(
                json["all_branches"].map((x) => AllBranch.fromJson(x))),
        merchantCode: json["merchant_code"],
        redeemUi: json["Redeem_UI"],
        brandCode: json["brand_code"],
        brandText: json["brand_text"],
        brandTermsCondition: json["brand_terms_condition"],
        brandStaffKey: json["brand_staff_key"],
        partnerId: json["partner_id"],
        lobTypes: json["lobTypes"] == null
            ? []
            : List<DataListLobType>.from(
                json["lobTypes"]!.map((x) => DataListLobType.fromJson(x))),
        termsConditions: json["terms_conditions"],
        partInRedeem: json["part_in_redeem"],
        isPinBased: json["is_pin_based"],
        accrualRate: json["accrual_rate"],
        redemptionRate: json["redemption_rate"],
        isExternalBrowser: json["is_external_browser"],
        partnerCategories: json["partner_categories"] == null
            ? []
            : List<PartnerCategory>.from(json["partner_categories"]!
                .map((x) => PartnerCategory.fromJson(x))),
        outletIds: json["outlet_ids"] == null
            ? []
            : List<int>.from(json["outlet_ids"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "image": image,
        "new_image": newImage,
        "cat_name": catName,
        "cat_code": catCode,
        "brand_cat": brandCat == null
            ? []
            : List<dynamic>.from(brandCat!.map((x) => x.toJson())),
        "all_branches": allBranches == null
            ? []
            : List<dynamic>.from(allBranches!.map((x) => x.toJson())),
        "Redeem_UI": redeemUi,
        "brand_code": brandCode,
        "brand_text": brandText,
        "brand_terms_condition": brandTermsCondition,
        "brand_staff_key": brandStaffKey,
        "partner_id": partnerId,
        "lobTypes": lobTypes == null
            ? []
            : List<dynamic>.from(lobTypes!.map((x) => x.toJson())),
        "terms_conditions": termsConditions,
        "part_in_redeem": partInRedeem,
        "is_pin_based": isPinBased,
        "accrual_rate": accrualRate,
        "redemption_rate": redemptionRate,
        "is_external_browser": isExternalBrowser,
        "partner_categories": partnerCategories == null
            ? []
            : List<dynamic>.from(partnerCategories!.map((x) => x.toJson())),
        "outlet_ids": outletIds == null
            ? []
            : List<dynamic>.from(outletIds!.map((x) => x)),
      };
}

class AllBranch {
  int? id;
  String? outletCode;
  String? bannerImage;
  String? newBannerImage;
  bool? isCashierId;
  bool? isInvoiceNo;
  bool? showCategories;
  String? offerImage;
  String? newOfferImage;
  String? title;
  String? address;
  String? outletWeekDayOpeningTime;
  String? outletWeekDayClosingTime;
  String? outletWeekEndOpeningTime;
  String? outletWeekEndClosingTime;
  CurrentStatus? currentStatus;
  String? desc;
  double? lat;
  double? long;
  double? distance;
  String? accrualPin;
  String? redemptionPin;
  String? thresholdPin;
  int? thresholdAmount;
  String? userProximity;
  String? url;
  String? platform;
  List<AllBranchLobType>? lobTypes;
  List<Offer>? offers;
  List? allPhotos;

  AllBranch({
    this.id,
    this.outletCode,
    this.bannerImage,
    this.newBannerImage,
    this.isCashierId,
    this.isInvoiceNo,
    this.showCategories,
    this.offerImage,
    this.newOfferImage,
    this.title,
    this.address,
    this.outletWeekDayOpeningTime,
    this.outletWeekDayClosingTime,
    this.outletWeekEndOpeningTime,
    this.outletWeekEndClosingTime,
    this.currentStatus,
    this.desc,
    this.lat,
    this.long,
    this.distance,
    this.accrualPin,
    this.redemptionPin,
    this.thresholdPin,
    this.thresholdAmount,
    this.userProximity,
    this.url,
    this.platform,
    this.lobTypes,
    this.offers,
    this.allPhotos,
  });

  factory AllBranch.fromJson(Map<String, dynamic> json) => AllBranch(
        id: json["id"],
        outletCode: json["outlet_code"],
        bannerImage: json["banner_image"],
        newBannerImage: json["new_banner_image"],
        isCashierId: json["is_cashier_id"],
        isInvoiceNo: json["is_invoice_no"],
        showCategories: json["show_categories"],
        offerImage: json["offer_image"],
        newOfferImage: json["new_offer_image"],
        title: json["title"],
        address: json["address"],
        outletWeekDayOpeningTime: json["outlet_week_day_opening_time"],
        outletWeekDayClosingTime: json["outlet_week_day_closing_time"],
        outletWeekEndOpeningTime: json["outlet_week_end_opening_time"],
        outletWeekEndClosingTime: json["outlet_week_end_closing_time"],
        currentStatus: currentStatusValues.map[json["current_status"]],
        desc: json["desc"],
        lat: json["lat"]?.toDouble(),
        long: json["long"]?.toDouble(),
        distance: json["distance"]?.toDouble(),
        accrualPin: json["accrual_pin"],
        redemptionPin: json["redemption_pin"],
        thresholdPin: json["threshold_pin"],
        thresholdAmount: json["threshold_amount"],
        userProximity: json["user_proximity"],
        url: json["url"],
        platform: json["platform"],
        lobTypes: json["lobTypes"] == null
            ? []
            : List<AllBranchLobType>.from(
                json["lobTypes"]!.map((x) => AllBranchLobType.fromJson(x))),
        offers: json["offers"] == null
            ? []
            : List<Offer>.from(json["offers"]!.map((x) => Offer.fromJson(x))),
        allPhotos: json["All_photos"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "outlet_code": outletCode,
        "banner_image": bannerImage,
        "new_banner_image": newBannerImage,
        "is_cashier_id": isCashierId,
        "is_invoice_no": isInvoiceNo,
        "show_categories": showCategories,
        "offer_image": offerImage,
        "new_offer_image": newOfferImage,
        "title": title,
        "address": address,
        "outlet_week_day_opening_time": outletWeekDayOpeningTime,
        "outlet_week_day_closing_time": outletWeekDayClosingTime,
        "outlet_week_end_opening_time": outletWeekEndOpeningTime,
        "outlet_week_end_closing_time": outletWeekEndClosingTime,
        "current_status": currentStatusValues.reverse[currentStatus],
        "desc": desc,
        "lat": lat,
        "long": long,
        "distance": distance,
        "accrual_pin": accrualPin,
        "redemption_pin": redemptionPin,
        "threshold_pin": thresholdPin,
        "threshold_amount": thresholdAmount,
        "user_proximity": userProximity,
        "url": url,
        "platform": platform,
        "lobTypes": lobTypes == null
            ? []
            : List<dynamic>.from(lobTypes!.map((x) => x.toJson())),
        "offers": offers == null
            ? []
            : List<dynamic>.from(offers!.map((x) => x.toJson())),
        "All_photos": allPhotos,
      };
}

enum CurrentStatus { open, closed }

final currentStatusValues =
    EnumValues({"Closed": CurrentStatus.closed, "Open": CurrentStatus.open});

class AllBranchLobType {
  Type? type;
  String? title;
  String? subtitle;
  String? url;
  String? termsConditions;
  String? icon;
  String? eshopProductCode;

  AllBranchLobType({
    this.type,
    this.title,
    this.subtitle,
    this.url,
    this.termsConditions,
    this.icon,
    this.eshopProductCode,
  });

  factory AllBranchLobType.fromJson(Map<String, dynamic> json) =>
      AllBranchLobType(
        type: typeValues.map[json["type"]]!,
        title: json["title"],
        subtitle: json["subtitle"],
        url: json["url"],
        termsConditions: json["terms_conditions"],
        icon: json["icon"],
        eshopProductCode: json["eshop_product_code"],
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "title": title,
        "subtitle": subtitle,
        "url": url,
        "terms_conditions": termsConditions,
        "icon": icon,
        "eshop_product_code": eshopProductCode,
      };
}

enum Type {
  spdinstr,
  redeem,
  spdon,
  rdmon,
  eshop, //
  click,
  visit,
  posredeem,
  spend,
  afl //
}

final typeValues = EnumValues({
  "AFL": Type.afl,
  "click": Type.click,
  "eshop": Type.eshop,
  "POSREDEEM": Type.posredeem,
  "RDMON": Type.rdmon,
  "Redeem": Type.redeem, //PIN red
  "SPDINSTR": Type.spdinstr, // accu
  "SPDON": Type.spdon,
  "spend": Type.spend,
  "visit": Type.visit
});

class Offer {
  String? offerTitle;
  String? offerCode;
  String? outletCode;
  String? brandCode;
  String? merchantCode;

  Offer({
    this.offerTitle,
    this.offerCode,
    this.outletCode,
    this.brandCode,
    this.merchantCode,
  });

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        offerTitle: json["offer_title"],
        offerCode: json["offer_code"],
        outletCode: json["outlet_code"],
        brandCode: json["brand_code"],
        merchantCode: json["merchant_code"],
      );

  Map<String, dynamic> toJson() => {
        "offer_title": offerTitle,
        "offer_code": offerCode,
        "outlet_code": outletCode,
        "brand_code": brandCode,
        "merchant_code": merchantCode,
      };
}

class BrandCat {
  String? tagName;
  String? tagCode;

  BrandCat({
    this.tagName,
    this.tagCode,
  });

  factory BrandCat.fromJson(Map<String, dynamic> json) => BrandCat(
        tagName: json["tag_name"],
        tagCode: json["tag_code"],
      );

  Map<String, dynamic> toJson() => {
        "tag_name": tagName,
        "tag_code": tagCode,
      };
}

class DataListLobType {
  Type? type;
  dynamic title;
  dynamic subtitle;
  String? url;
  dynamic earn;

  DataListLobType({
    this.type,
    this.title,
    this.subtitle,
    this.url,
    this.earn,
  });

  factory DataListLobType.fromJson(Map<String, dynamic> json) =>
      DataListLobType(
        type: typeValues.map[json["type"]]!,
        title: json["title"],
        subtitle: json["subtitle"],
        url: json["url"],
        earn: json["earn"],
      );

  Map<String, dynamic> toJson() => {
        "type": typeValues.reverse[type],
        "title": title,
        "subtitle": subtitle,
        "url": url,
        "earn": earn,
      };
}

class PartnerCategory {
  String? categoryCode;
  dynamic earnRate;
  String? categoryName;
  int? merchantCode;
  String? categoryTrm;

  PartnerCategory({
    this.categoryCode,
    this.earnRate,
    this.categoryName,
    this.merchantCode,
    this.categoryTrm,
  });

  factory PartnerCategory.fromJson(Map<String, dynamic> json) =>
      PartnerCategory(
        categoryCode: json["category_code"],
        earnRate: json["earn_rate"],
        categoryName: json["category_name"],
        merchantCode: json["merchant_code"],
        categoryTrm: json["category_trm"],
      );

  Map<String, dynamic> toJson() => {
        "category_code": categoryCode,
        "earn_rate": earnRate,
        "category_name": categoryName,
        "merchant_code": merchantCode,
        "category_trm": categoryTrm,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
