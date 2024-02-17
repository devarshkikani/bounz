import 'dart:convert';
// To parse this JSON data, do
//
//     final receipts = receiptsFromJson(jsonString);


Receipts receiptsFromJson(String str) => Receipts.fromJson(json.decode(str));

String receiptsToJson(Receipts data) => json.encode(data.toJson());

class Receipts {
    int? fullCount;
    int? points;
    double? amount;
    String? transactionId;
    String? transactionType;
    String? transactionDate;
    int? activityId;
    String? isTentative;
    String? partnerId;
    dynamic storeName;
    String? partnerName;
    String? outletName;
    String? billNumber;
    String? transactionLabel;
    String? image;
    String? activityName;
    String? activityImage;
    String? description;

    Receipts({
        this.fullCount,
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
        this.billNumber,
        this.transactionLabel,
        this.image,
        this.activityName,
        this.activityImage,
        this.description,
    });

    factory Receipts.fromJson(Map<String, dynamic> json) => Receipts(
        fullCount: json["full_count"],
        points: json["points"],
        amount: json["amount"]?.toDouble(),
        transactionId: json["transaction_id"],
        transactionType: json["transaction_type"],
        transactionDate: json["transaction_date"],
        activityId: json["activity_id"],
        isTentative: json["is_tentative"],
        partnerId: json["partner_id"],
        storeName: json["store_name"],
        partnerName: json["partner_name"],
        outletName: json["outlet_name"],
        billNumber: json["bill_number"],
        transactionLabel: json["transaction_label"],
        image: json["image"],
        activityName: json["activity_name"],
        activityImage: json["activity_image"],
        description: json["description"],
    );

    Map<String, dynamic> toJson() => {
        "full_count": fullCount,
        "points": points,
        "amount": amount,
        "transaction_id": transactionId,
        "transaction_type": transactionType,
        "transaction_date": transactionDate,
        "activity_id": activityId,
        "is_tentative": isTentative,
        "partner_id": partnerId,
        "store_name": storeName,
        "partner_name": partnerName,
        "outlet_name": outletName,
        "bill_number": billNumber,
        "transaction_label": transactionLabel,
        "image": image,
        "activity_name": activityName,
        "activity_image": activityImage,
        "description": description,
    };
}
