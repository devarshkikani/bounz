// To parse this JSON data, do
//
//     final linkSmileAccModel = linkSmileAccModelFromJson(jsonString);

import 'dart:convert';

LinkSmileAccModel linkSmileAccModelFromJson(String str) => LinkSmileAccModel.fromJson(json.decode(str));

String linkSmileAccModelToJson(LinkSmileAccModel data) => json.encode(data.toJson());

class LinkSmileAccModel {
  bool? status;
  int? statuscode;
  String? message;
  DataLinkAcc? data;

  LinkSmileAccModel({
    this.status,
    this.statuscode,
    this.message,
    this.data,
  });

  factory LinkSmileAccModel.fromJson(Map<String, dynamic> json) => LinkSmileAccModel(
    status: json["status"],
    statuscode: json["statuscode"],
    message: json["message"],
    data: json["data"] == null ? null : DataLinkAcc.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statuscode": statuscode,
    "message": message,
    "data": data?.toJson(),
  };
}

class DataLinkAcc {
  bool? status;
  int? statusCode;
  String? message;

  DataLinkAcc({
    this.status,
    this.statusCode,
    this.message,
  });

  factory DataLinkAcc.fromJson(Map<String, dynamic> json) => DataLinkAcc(
    status: json["status"],
    statusCode: json["status_code"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "status_code": statusCode,
    "message": message,
  };
}
