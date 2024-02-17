import 'dart:convert';
// To parse this JSON data, do
//
//     final myBounzCardModel = myBounzCardModelFromJson(jsonString);

MyBounzCardModel myBounzCardModelFromJson(String str) =>
    MyBounzCardModel.fromJson(json.decode(str));

String myBounzCardModelToJson(MyBounzCardModel data) =>
    json.encode(data.toJson());

class MyBounzCardModel {
  int? points;
  num? amount;
  String? transactionId;
  String? transactionType;
  DateTime? transactionDate;
  int? activityId;
  String? isTentative;
  String? partnerId;
  dynamic storeName;
  String? partnerName;
  String? outletName;
  String? transactionLabel;
  String? activityName;
  String? image;
  String? description;

  MyBounzCardModel({
    this.points,
    this.amount,
    this.transactionId,
    this.transactionType,
    this.transactionDate,
    this.activityId,
    this.isTentative,
    this.partnerId,
    this.storeName,
    this.partnerName,
    this.outletName,
    this.transactionLabel,
    this.activityName,
    this.image,
    this.description,
  });

  factory MyBounzCardModel.fromJson(Map<String, dynamic> json) =>
      MyBounzCardModel(
        points: json["points"],
        amount: json["amount"],
        transactionId: json["transaction_id"],
        transactionType: json["transaction_type"],
        transactionDate: json["transaction_date"] == null
            ? null
            : DateTime.parse(json["transaction_date"]),
        activityId: json["activity_id"],
        isTentative: json["is_tentative"],
        partnerId: json["partner_id"],
        storeName: json["store_name"],
        partnerName: json["partner_name"],
        outletName: json["outlet_name"],
        transactionLabel: json["transaction_label"],
        activityName: json["activity_name"],
        image: json["image"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "points": points,
        "amount": amount,
        "transaction_id": transactionId,
        "transaction_type": transactionType,
        "transaction_date": transactionDate?.toIso8601String(),
        "activity_id": activityId,
        "is_tentative": isTentative,
        "partner_id": partnerId,
        "store_name": storeName,
        "partner_name": partnerName,
        "outlet_name": outletName,
        "transaction_label": transactionLabel,
        "activity_name": activityName,
        "image": image,
        "description": description,
      };
}
