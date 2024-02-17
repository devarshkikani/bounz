// To parse this JSON data, do
//
//     final billScreenModel = billScreenModelFromJson(jsonString);

import 'dart:convert';

BillScreenModel billScreenModelFromJson(String str) =>
    BillScreenModel.fromJson(json.decode(str));

String billScreenModelToJson(BillScreenModel data) =>
    json.encode(data.toJson());

class BillScreenModel {
  bool? status;
  List<Result>? result;

  BillScreenModel({
    this.status,
    this.result,
  });

  factory BillScreenModel.fromJson(Map<String, dynamic> json) =>
      BillScreenModel(
        status: json["status"],
        result: json["result"] == null
            ? []
            : List<Result>.from(json["result"]!.map((x) => Result.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "result": result == null
            ? []
            : List<dynamic>.from(result!.map((x) => x.toJson())),
      };
}

class Result {
  Balance? balance;
  Dates? dates;
  String? reference;

  Result({
    this.balance,
    this.dates,
    this.reference,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        balance:
            json["balance"] == null ? null : Balance.fromJson(json["balance"]),
        dates: json["dates"] == null ? null : Dates.fromJson(json["dates"]),
        reference: json["reference"],
      );

  Map<String, dynamic> toJson() => {
        "balance": balance?.toJson(),
        "dates": dates?.toJson(),
        "reference": reference,
      };
}

class Balance {
  double? amount;
  String? unit;
  String? unitType;
  int? requiredPoints;
  int? earnPoint;
  String? pricesRetailAmountMin;
  String? pricesRetailAmountMax;
  int? convesFees;
  double? totalAmount;

  Balance({
    this.amount,
    this.unit,
    this.unitType,
    this.requiredPoints,
    this.earnPoint,
    this.pricesRetailAmountMin,
    this.pricesRetailAmountMax,
    this.convesFees,
    this.totalAmount,
  });

  factory Balance.fromJson(Map<String, dynamic> json) => Balance(
        amount: json["amount"]?.toDouble(),
        unit: json["unit"],
        unitType: json["unit_type"],
        requiredPoints: json["required_points"],
        earnPoint: json["earn_point"],
        pricesRetailAmountMin: json["prices_retail_amount_min"],
        pricesRetailAmountMax: json["prices_retail_amount_max"],
        convesFees: json["conves_fees"],
        totalAmount: json["total_amount"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "amount": amount,
        "unit": unit,
        "unit_type": unitType,
        "required_points": requiredPoints,
        "earn_point": earnPoint,
        "prices_retail_amount_min": pricesRetailAmountMin,
        "prices_retail_amount_max": pricesRetailAmountMax,
        "conves_fees": convesFees,
        "total_amount": totalAmount,
      };
}

class Dates {
  DateTime? statement;

  Dates({
    this.statement,
  });

  factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        statement: json["statement"] == null
            ? null
            : DateTime.parse(json["statement"]),
      );

  Map<String, dynamic> toJson() => {
        "statement":
            "${statement!.year.toString().padLeft(4, '0')}-${statement!.month.toString().padLeft(2, '0')}-${statement!.day.toString().padLeft(2, '0')}",
      };
}
