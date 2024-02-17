// To parse this JSON data, do
//
//     final spinTheWheelDesignModel = spinTheWheelDesignModelFromJson(jsonString);

import 'dart:convert';

SpinTheWheelDesignModel spinTheWheelDesignModelFromJson(String str) => SpinTheWheelDesignModel.fromJson(json.decode(str));

String spinTheWheelDesignModelToJson(SpinTheWheelDesignModel data) => json.encode(data.toJson());

class SpinTheWheelDesignModel {
  bool? status;
  int? statuscode;
  String? message;
  DataWheelDesign? data;

  SpinTheWheelDesignModel({
    this.status,
    this.statuscode,
    this.message,
    this.data,
  });

  factory SpinTheWheelDesignModel.fromJson(Map<String, dynamic> json) => SpinTheWheelDesignModel(
    status: json["status"],
    statuscode: json["statuscode"],
    message: json["message"],
    data: json["data"] == null ? null : DataWheelDesign.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statuscode": statuscode,
    "message": message,
    "data": data?.toJson(),
  };
}

class DataWheelDesign {
  bool? status;
  String? statusCode;
  Values? values;

  DataWheelDesign({
    this.status,
    this.statusCode,
    this.values,
  });

  factory DataWheelDesign.fromJson(Map<String, dynamic> json) => DataWheelDesign(
    status: json["status"],
    statusCode: json["status_code"],
    values: json["values"] == null ? null : Values.fromJson(json["values"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "status_code": statusCode,
    "values": values?.toJson(),
  };
}

class Values {
  String? spinCode;
  String? type;
  String? title;
  String? subtitle;
  List<WheelDatum>? wheelData;

  Values({
    this.spinCode,
    this.type,
    this.title,
    this.subtitle,
    this.wheelData,
  });

  factory Values.fromJson(Map<String, dynamic> json) => Values(
    spinCode: json["spin_code"],
    type: json["type"],
    title: json["title"],
    subtitle: json["subtitle"],
    wheelData: json["wheel_data"] == null ? [] : List<WheelDatum>.from(json["wheel_data"]!.map((x) => WheelDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "spin_code": spinCode,
    "type": type,
    "title": title,
    "subtitle": subtitle,
    "wheel_data": wheelData == null ? [] : List<dynamic>.from(wheelData!.map((x) => x.toJson())),
  };
}

class WheelDatum {
  int? spokeId;
  String? name;
  String? spinName;
  String? title;
  String? popupTitle;
  String? colorCode;
  String? description;

  WheelDatum({
    this.spokeId,
    this.name,
    this.spinName,
    this.title,
    this.popupTitle,
    this.colorCode,
    this.description,
  });

  factory WheelDatum.fromJson(Map<String, dynamic> json) => WheelDatum(
    spokeId: json["spoke_id"],
    name: json["name"],
    spinName: json["spin_name"],
    title: json["title"],
    popupTitle: json["popup_title"],
    colorCode: json["color_code"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "spoke_id": spokeId,
    "name": name,
    "spin_name": spinName,
    "title": title,
    "popup_title": popupTitle,
    "color_code": colorCode,
    "description": description,
  };
}
