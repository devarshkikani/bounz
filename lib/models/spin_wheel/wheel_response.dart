// To parse this JSON data, do
//
//     final spinWheelGetSpokeModel = spinWheelGetSpokeModelFromJson(jsonString);

import 'dart:convert';

SpinWheelGetSpokeModel spinWheelGetSpokeModelFromJson(String str) =>
    SpinWheelGetSpokeModel.fromJson(json.decode(str));

String spinWheelGetSpokeModelToJson(SpinWheelGetSpokeModel data) =>
    json.encode(data.toJson());

class SpinWheelGetSpokeModel {
  bool? status;
  int? statuscode;
  String? message;
  SpinData? data;

  SpinWheelGetSpokeModel({
    this.status,
    this.statuscode,
    this.message,
    this.data,
  });

  factory SpinWheelGetSpokeModel.fromJson(Map<String, dynamic> json) =>
      SpinWheelGetSpokeModel(
        status: json["status"],
        statuscode: json["statuscode"],
        message: json["message"],
        data: json["data"] == null ? null : SpinData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "statuscode": statuscode,
        "message": message,
        "data": data?.toJson(),
      };
}

class SpinData {
  bool? status;
  String? statusCode;
  Values? values;

  SpinData({
    this.status,
    this.statusCode,
    this.values,
  });

  factory SpinData.fromJson(Map<String, dynamic> json) => SpinData(
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
  int? spokeId;
  String? successTitle;
  List<TransactionResponse>? transactionResponse;
  String? prizeType;
  String? couponCode;
  String? message;
  int? points;

  Values({
    this.spokeId,
    this.successTitle,
    this.transactionResponse,
    this.prizeType,
    this.couponCode,
    this.message,
    this.points,
  });

  factory Values.fromJson(Map<String, dynamic> json) => Values(
        spokeId: json["spoke_id"],
        successTitle: json["success_title"],
        prizeType: json["prize_type"],
        couponCode: json["coupon_code"],
        message: json["message"],
        points: json["points"],
        transactionResponse: json["transaction_response"] == null
            ? []
            : List<TransactionResponse>.from(json["transaction_response"]
                .map((x) => TransactionResponse.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "spoke_id": spokeId,
        "success_title": successTitle,
        "prize_type": prizeType,
        "coupon_code": couponCode,
        "message": message,
        "points": points,
        "transaction_response": transactionResponse == null
            ? []
            : List<dynamic>.from(transactionResponse!.map((x) => x.toJson())),
      };
}

class TransactionResponse {
  bool? status;
  String? statusCode;
  dynamic transactionId;
  dynamic tyTransactionId;
  int? points;
  String? message;

  TransactionResponse({
    this.status,
    this.statusCode,
    this.transactionId,
    this.tyTransactionId,
    this.points,
    this.message,
  });

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      TransactionResponse(
        status: json["status"],
        statusCode: json["status_code"],
        transactionId: json["transaction_id"],
        tyTransactionId: json["ty_transaction_id"],
        points: json["points"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "status_code": statusCode,
        "transaction_id": transactionId,
        "ty_transaction_id": tyTransactionId,
        "points": points,
        "message": message,
      };
}
