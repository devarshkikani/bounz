import 'dart:convert';
// To parse this JSON data, do
//
//     final offerCategoryModel = offerCategoryModelFromJson(jsonString);


OfferCategoryModel offerCategoryModelFromJson(String str) => OfferCategoryModel.fromJson(json.decode(str));

String offerCategoryModelToJson(OfferCategoryModel data) => json.encode(data.toJson());

class OfferCategoryModel {
    int? catId;
    String? catName;
    String? catCode;
    String? catImage;

    OfferCategoryModel({
        this.catId,
        this.catName,
        this.catCode,
        this.catImage,
    });

    factory OfferCategoryModel.fromJson(Map<String, dynamic> json) => OfferCategoryModel(
        catId: json["cat_id"],
        catName: json["cat_name"],
        catCode: json["cat_code"],
        catImage: json["cat_image"],
    );

    Map<String, dynamic> toJson() => {
        "cat_id": catId,
        "cat_name": catName,
        "cat_code": catCode,
        "cat_image": catImage,
    };
}
