// To parse this JSON data, do
//
//     final partnerListModel = partnerListModelFromJson(jsonString);

import 'dart:convert';

PartnerListModel partnerListModelFromJson(String str) =>
    PartnerListModel.fromJson(json.decode(str));

String partnerListModelToJson(PartnerListModel data) =>
    json.encode(data.toJson());

class PartnerListModel {
  List<CatValue>? catValues;
  List<DataList>? dataList;

  PartnerListModel({
    this.catValues,
    this.dataList,
  });

  factory PartnerListModel.fromJson(Map<String, dynamic> json) =>
      PartnerListModel(
        catValues: json["cat_values"] == null
            ? []
            : List<CatValue>.from(
                json["cat_values"]!.map((x) => CatValue.fromJson(x))),
        dataList: json["data_list"] == null
            ? []
            : List<DataList>.from(
                json["data_list"]!.map((x) => DataList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "cat_values": catValues == null
            ? []
            : List<dynamic>.from(catValues!.map((x) => x.toJson())),
        "data_list": dataList == null
            ? []
            : List<dynamic>.from(dataList!.map((x) => x.toJson())),
      };
}

class CatValue {
  int? catId;
  String? catName;
  String? catCode;
  String? catImage;

  CatValue({
    this.catId,
    this.catName,
    this.catCode,
    this.catImage,
  });

  factory CatValue.fromJson(Map<String, dynamic> json) => CatValue(
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

class DataList {
  String? name;
  String? newImage;
  String? catName;
  String? catCode;
  String? merchantCode;
  String? brandCode;

  DataList({
    this.name,
    this.newImage,
    this.catName,
    this.catCode,
    this.merchantCode,
    this.brandCode,
  });

  factory DataList.fromJson(Map<String, dynamic> json) => DataList(
        name: json["name"],
        newImage: json["new_image"],
        catName: json["cat_name"],
        catCode: json["cat_code"],
        merchantCode: json["merchant_code"],
        brandCode: json["brand_code"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "new_image": newImage,
        "cat_name": catName,
        "cat_code": catCode,
        "merchant_code": merchantCode,
        "brand_code": brandCode,
      };
}
