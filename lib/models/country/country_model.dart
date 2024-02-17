// To parse this JSON data, do
//
//     final countryModel = countryModelFromJson(jsonString);

import 'dart:convert';

CountryModel countryModelFromJson(String str) => CountryModel.fromJson(json.decode(str));

String countryModelToJson(CountryModel data) => json.encode(data.toJson());



class CountryModel {
  CountryModel({
    required this.message,
    required this.code,
    required this.status,
    required this.values,
  });

  String message;
  String code;
  bool status;
  Values values;

  factory CountryModel.fromJson(Map<String, dynamic> json) => CountryModel(
    message: json["message"],
    code: json["code"],
    status: json["status"],
    values: Values.fromJson(json["values"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "code": code,
    "status": status,
    "values": values.toJson(),
  };
}

class Values {
  Values({
    required this.topCountry,
    required this.otherCountry,
  });

  List<Country> topCountry;
  List<Country> otherCountry;

  factory Values.fromJson(Map<String, dynamic> json) => Values(
    topCountry: List<Country>.from(json["top_country"].map((x) => Country.fromJson(x))),
    otherCountry: List<Country>.from(json["other_country"].map((x) => Country.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "top_country": List<dynamic>.from(topCountry.map((x) => x.toJson())),
    "other_country": List<dynamic>.from(otherCountry.map((x) => x.toJson())),
  };
}

class Country {
  Country({
    required this.id,
    required this.name,
    required this.code,
    required this.nationality,
    required this.countryCode,
    required this.mobileNumberLength,
    required this.image,
  });

  int? id;
  String? name;
  String? code;
  String? nationality;
  String? countryCode;
  int? mobileNumberLength;
  String? image;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
    id: json["id"],
    name: json["name"],
    code: json["code"],
    nationality: json["nationality"],
    countryCode: json["country_code"],
    mobileNumberLength: json["mobile_number_length"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "code": code,
    "nationality": nationality,
    "country_code": countryCode,
    "mobile_number_length": mobileNumberLength,
    "image": image,
  };
}
