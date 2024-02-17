// To parse this JSON data, do
//
//     final expiryDetails = expiryDetailsFromJson(jsonString);

import 'dart:convert';

ExpiryDetails expiryDetailsFromJson(String str) =>
    ExpiryDetails.fromJson(json.decode(str));

String expiryDetailsToJson(ExpiryDetails data) => json.encode(data.toJson());

class ExpiryDetails {
  List<Expir>? expired;
  List<Expir>? expiry;

  ExpiryDetails({
    this.expired,
    this.expiry,
  });

  factory ExpiryDetails.fromJson(Map<String, dynamic> json) => ExpiryDetails(
        expired: json["expired"] == null
            ? []
            : List<Expir>.from(json["expired"]!.map((x) => Expir.fromJson(x))),
        expiry: json["expiry"] == null
            ? []
            : List<Expir>.from(json["expiry"]!.map((x) => Expir.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "expired": expired == null
            ? []
            : List<dynamic>.from(expired!.map((x) => x.toJson())),
        "expiry": expiry == null
            ? []
            : List<dynamic>.from(expiry!.map((x) => x.toJson())),
      };
}

class Expir {
  String? title;
  int? points;

  Expir({
    this.title,
    this.points,
  });

  factory Expir.fromJson(Map<String, dynamic> json) => Expir(
        title: json["title"],
        points: json["points"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "points": points,
      };
}
