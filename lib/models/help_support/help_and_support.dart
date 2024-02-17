// To parse this JSON data, do
//
//     final helpSupportModel = helpSupportModelFromJson(jsonString);

import 'dart:convert';

HelpSupportModel helpSupportModelFromJson(String str) => HelpSupportModel.fromJson(json.decode(str));

String helpSupportModelToJson(HelpSupportModel data) => json.encode(data.toJson());

class HelpSupportModel {
  bool? status;
  int? statuscode;
  String? message;
  Data? data;

  HelpSupportModel({
    this.status,
    this.statuscode,
    this.message,
    this.data,
  });

  factory HelpSupportModel.fromJson(Map<String, dynamic> json) => HelpSupportModel(
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
  String? days;
  String? timing;
  String? email;
  String? contactNo;

  Data({
    this.days,
    this.timing,
    this.email,
    this.contactNo,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    days: json["days"],
    timing: json["timing"],
    email: json["email"],
    contactNo: json["contact_no"],
  );

  Map<String, dynamic> toJson() => {
    "days": days,
    "timing": timing,
    "email": email,
    "contact_no": contactNo,
  };
}
