import 'dart:convert';
// To parse this JSON data, do
//
//     final offerModel = offerModelFromJson(jsonString);


OfferModel offerModelFromJson(String str) => OfferModel.fromJson(json.decode(str));

String offerModelToJson(OfferModel data) => json.encode(data.toJson());

class OfferModel {
    String? outletCode;
    String? brandCode;
    String? ofrdCode;
    String? merchantCode;
    String? brandLogo;
    String? offerImage;
    String? offerTitle;
    String? brandName;
    String? categoryName;
    String? categoryCode;
    String? ofrDesc;
    String? latitude;
    String? longitude;
    double? distance;

    OfferModel({
        this.outletCode,
        this.brandCode,
        this.ofrdCode,
        this.merchantCode,
        this.brandLogo,
        this.offerImage,
        this.offerTitle,
        this.brandName,
        this.categoryName,
        this.categoryCode,
        this.ofrDesc,
        this.latitude,
        this.longitude,
        this.distance,
    });

    factory OfferModel.fromJson(Map<String, dynamic> json) => OfferModel(
        outletCode: json["outlet_code"],
        brandCode: json["brand_code"],
        ofrdCode: json["ofrd_code"],
        merchantCode: json["merchant_code"],
        brandLogo: json["brand_logo"],
        offerImage: json["offer_image"],
        offerTitle: json["offer_title"],
        brandName: json["brand_name"],
        categoryName: json["category_name"],
        categoryCode: json["category_code"],
        ofrDesc: json["ofr_desc"],
        latitude: json["latitude"],
        longitude: json["longitude"],
        distance: json["distance"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "outlet_code": outletCode,
        "brand_code": brandCode,
        "ofrd_code": ofrdCode,
        "merchant_code": merchantCode,
        "brand_logo": brandLogo,
        "offer_image": offerImage,
        "offer_title": offerTitle,
        "brand_name": brandName,
        "category_name": categoryName,
        "category_code": categoryCode,
        "ofr_desc": ofrDesc,
        "latitude": latitude,
        "longitude": longitude,
        "distance": distance,
    };
}
