// To parse this JSON data, do
//
//     final getOtpModel = getOtpModelFromJson(jsonString);

import 'dart:convert';

GetOtpModel getOtpModelFromJson(String str) => GetOtpModel.fromJson(json.decode(str));

String getOtpModelToJson(GetOtpModel data) => json.encode(data.toJson());

class GetOtpModel {
  bool? status;
  int? statuscode;
  String? message;
  Data? data;

  GetOtpModel({
    this.status,
    this.statuscode,
    this.message,
    this.data,
  });

  factory GetOtpModel.fromJson(Map<String, dynamic> json) => GetOtpModel(
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
  String? statusCode;
  String? message;
  Values? values;

  Data({
    this.status,
    this.statusCode,
    this.message,
    this.values,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    status: json["status"],
    statusCode: json["status_code"],
    message: json["message"],
    values: json["values"] == null ? null : Values.fromJson(json["values"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "status_code": statusCode,
    "message": message,
    "values": values?.toJson(),
  };
}

class Values {
  String? otp;

  Values({
    this.otp,
  });

  factory Values.fromJson(Map<String, dynamic> json) => Values(
    otp: json["otp"],
  );

  Map<String, dynamic> toJson() => {
    "otp": otp,
  };
}
