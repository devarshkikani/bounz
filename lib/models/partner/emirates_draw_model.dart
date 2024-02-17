// To parse this JSON data, do
//
//     final emiratesDrawModel = emiratesDrawModelFromJson(jsonString);

import 'dart:convert';

EmiratesDrawModel emiratesDrawModelFromJson(String str) => EmiratesDrawModel.fromJson(json.decode(str));

String emiratesDrawModelToJson(EmiratesDrawModel data) => json.encode(data.toJson());

class EmiratesDrawModel {
  bool? status;
  int? statuscode;
  String? message;
  Data? data;

  EmiratesDrawModel({
    this.status,
    this.statuscode,
    this.message,
    this.data,
  });

  factory EmiratesDrawModel.fromJson(Map<String, dynamic> json) => EmiratesDrawModel(
    status: json["status"],
    statuscode: json["statuscode"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statuscode": statuscode,
    "message": message,
    "data": data?.toJson(),
  };
}

class Data {
  bool? status;
  String? redirectUrl;

  Data({
    this.status,
    this.redirectUrl,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    redirectUrl: json["redirectURL"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "redirectURL": redirectUrl,
  };
}
