// To parse this JSON data, do
//
//     final historyExchangeModel = historyExchangeModelFromJson(jsonString);

import 'dart:convert';

HistoryExchangeModel historyExchangeModelFromJson(String str) => HistoryExchangeModel.fromJson(json.decode(str));

String historyExchangeModelToJson(HistoryExchangeModel data) => json.encode(data.toJson());

class HistoryExchangeModel {
  bool? status;
  int? statuscode;
  String? message;
  List<HistoryDataList>? data;

  HistoryExchangeModel({
    this.status,
    this.statuscode,
    this.message,
    this.data,
  });

  factory HistoryExchangeModel.fromJson(Map<String, dynamic> json) => HistoryExchangeModel(
    status: json["status"],
    statuscode: json["statuscode"],
    message: json["message"],
    data: json["data"] == null ? [] : List<HistoryDataList>.from(json["data"]!.map((x) => HistoryDataList.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "statuscode": statuscode,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class HistoryDataList {
  String? transactionType;
  String? transactionSubType;
  String? sourceTransactionId;
  String? sourceLoyaltyProgram;
  String? sourceLoyaltyProgramAr;
  String? sourceMembershipNo;
  String? targetLoyaltyProgram;
  String? targetLoyaltyProgramAr;
  String? targetMembershipNo;
  DateTime? transactionDate;
  String? originalMessageId;
  String? blckchainId;
  String? status;
  int? pointsSource;
  int? pointsConverted;
  String? unitType;
  String? unitTypeAr;

  HistoryDataList({
    this.transactionType,
    this.transactionSubType,
    this.sourceTransactionId,
    this.sourceLoyaltyProgram,
    this.sourceLoyaltyProgramAr,
    this.sourceMembershipNo,
    this.targetLoyaltyProgram,
    this.targetLoyaltyProgramAr,
    this.targetMembershipNo,
    this.transactionDate,
    this.originalMessageId,
    this.blckchainId,
    this.status,
    this.pointsSource,
    this.pointsConverted,
    this.unitType,
    this.unitTypeAr,
  });

  factory HistoryDataList.fromJson(Map<String, dynamic> json) => HistoryDataList(
    transactionType: json["transactionType"],
    transactionSubType: json["transactionSubType"],
    sourceTransactionId: json["sourceTransactionId"],
    sourceLoyaltyProgram: json["sourceLoyaltyProgram"],
    sourceLoyaltyProgramAr: json["sourceLoyaltyProgram_AR"],
    sourceMembershipNo: json["sourceMembershipNo"],
    targetLoyaltyProgram: json["targetLoyaltyProgram"],
    targetLoyaltyProgramAr: json["targetLoyaltyProgram_AR"],
    targetMembershipNo: json["targetMembershipNo"],
    transactionDate: json["transactionDate"] == null ? null : DateTime.parse(json["transactionDate"]),
    originalMessageId: json["originalMessageId"],
    blckchainId: json["blckchainId"],
    status: json["status"],
    pointsSource: json["pointsSource"],
    pointsConverted: json["pointsConverted"],
    unitType: json["unitType"],
    unitTypeAr: json["unitType_AR"],
  );

  Map<String, dynamic> toJson() => {
    "transactionType": transactionType,
    "transactionSubType": transactionSubType,
    "sourceTransactionId": sourceTransactionId,
    "sourceLoyaltyProgram": sourceLoyaltyProgram,
    "sourceLoyaltyProgram_AR": sourceLoyaltyProgramAr,
    "sourceMembershipNo": sourceMembershipNo,
    "targetLoyaltyProgram": targetLoyaltyProgram,
    "targetLoyaltyProgram_AR": targetLoyaltyProgramAr,
    "targetMembershipNo": targetMembershipNo,
    "transactionDate": transactionDate?.toIso8601String(),
    "originalMessageId": originalMessageId,
    "blckchainId": blckchainId,
    "status": status,
    "pointsSource": pointsSource,
    "pointsConverted": pointsConverted,
    "unitType": unitType,
    "unitType_AR": unitTypeAr,
  };
}
