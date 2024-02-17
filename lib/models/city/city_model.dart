// To parse this JSON data, do
//
//     final cityModel = cityModelFromJson(jsonString);

import 'dart:convert';

CityModel cityModelFromJson(String str) => CityModel.fromJson(json.decode(str));

String cityModelToJson(CityModel data) => json.encode(data.toJson());

class CityModel {
  String? message;
  String? code;
  bool? status;
  List<City>? city;

  CityModel({
    this.message,
    this.code,
    this.status,
    this.city,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) => CityModel(
        message: json["message"],
        code: json["code"],
        status: json["status"],
        city: json["values"] == null
            ? []
            : List<City>.from(json["values"]!.map((x) => City.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "code": code,
        "status": status,
        "values": city == null
            ? []
            : List<dynamic>.from(city!.map((x) => x.toJson())),
      };
}

class City {
  int? id;
  String? cityName;
  dynamic cityCode;
  int? countryId;
  String? image;
  String? unselectedImage;
  int? sequence;

  City({
    this.id,
    this.cityName,
    this.cityCode,
    this.countryId,
    this.image,
    this.unselectedImage,
    this.sequence,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        cityName: json["city_name"],
        cityCode: json["city_code"],
        countryId: json["country_id"],
        image: json["image"],
        unselectedImage: json["unselected_image"],
        sequence: json["sequence"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "city_name": cityName,
        "city_code": cityCode,
        "country_id": countryId,
        "image": image,
        "unselected_image": unselectedImage,
        "sequence": sequence,
      };
}
