import 'dart:convert';
// To parse this JSON data, do
//
//     final purchasedHistoryCard = purchasedHistoryCardFromJson(jsonString);

PurchasedHistoryCard purchasedHistoryCardFromJson(String str) =>
    PurchasedHistoryCard.fromJson(json.decode(str));

String purchasedHistoryCardToJson(PurchasedHistoryCard data) =>
    json.encode(data.toJson());

class PurchasedHistoryCard {
  String? transactionId;
  String? productName;
  String? mobileImage;
  String? paymentType;
  String? purchasedFor;
  num? denominationAmount;
  num? totalAmount;
  num? payWithPoints;
  num? amountPaid;
  num? earnPoints;
  num? pointsRedeemed;
  String? giftcardUrl;
  String? giftcardId;
  String? supplierCode;
  DateTime? validity;
  int? isExpired;
  String? receiverEmail;
  String? receiverMobile;
  DateTime? purchasedDate;
  String? transactionType;
  String? transactionStatus;
  String? categoryName;
  String? categoryCode;
  List<Value>? values;
  int? quantity;

  PurchasedHistoryCard({
    this.transactionId,
    this.productName,
    this.mobileImage,
    this.paymentType,
    this.purchasedFor,
    this.payWithPoints,
    this.denominationAmount,
    this.totalAmount,
    this.amountPaid,
    this.earnPoints,
    this.pointsRedeemed,
    this.giftcardUrl,
    this.giftcardId,
    this.supplierCode,
    this.validity,
    this.isExpired,
    this.receiverEmail,
    this.receiverMobile,
    this.purchasedDate,
    this.transactionType,
    this.transactionStatus,
    this.categoryName,
    this.categoryCode,
    this.values,
    this.quantity,
  });

  factory PurchasedHistoryCard.fromJson(Map<String, dynamic> json) =>
      PurchasedHistoryCard(
        transactionId: json["transaction_id"],
        productName: json["product_name"],
        mobileImage: json["mobile_image"],
        payWithPoints: json["pay_with_points"],
        paymentType: json["payment_type"],
        denominationAmount: json["denomination_amount"],
        totalAmount: json["total_amount"],
        amountPaid: json["amount_paid"],
        earnPoints: json["earn_points"],
        pointsRedeemed: json["points_redeemed"],
        giftcardUrl: json["giftcard_url"],
        giftcardId: json["giftcard_id"],
        supplierCode: json["supplier_code"],
        purchasedFor: json["purchased_for"],
        validity:
            json["validity"] == null ? null : DateTime.parse(json["validity"]),
        isExpired: json["is_expired"],
        receiverEmail: json["receiver_email"],
        receiverMobile: json["receiver_mobile"],
        purchasedDate: json["purchased_date"] == null
            ? null
            : DateTime.parse(json["purchased_date"]),
        transactionType: json["transaction_type"],
        transactionStatus: json["transaction_status"],
        categoryName: json["category_name"],
        categoryCode: json["category_code"],
        values: json["values"] == null
            ? []
            : List<Value>.from(json["values"]!.map((x) => Value.fromJson(x))),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "transaction_id": transactionId,
        "product_name": productName,
        "mobile_image": mobileImage,
        "payment_type": paymentType,
        "pay_with_points": payWithPoints,
        "denomination_amount": denominationAmount,
        "total_amount": totalAmount,
        "amount_paid": amountPaid,
        "earn_points": earnPoints,
        "points_redeemed": pointsRedeemed,
        "giftcard_url": giftcardUrl,
        "giftcard_id": giftcardId,
        "supplier_code": supplierCode,
        "purchased_for": purchasedFor,
        "validity":
            "${validity!.year.toString().padLeft(4, '0')}-${validity!.month.toString().padLeft(2, '0')}-${validity!.day.toString().padLeft(2, '0')}",
        "is_expired": isExpired,
        "receiver_email": receiverEmail,
        "receiver_mobile": receiverMobile,
        "purchased_date": purchasedDate?.toIso8601String(),
        "transaction_type": transactionType,
        "transaction_status": transactionStatus,
        "category_name": categoryName,
        "category_code": categoryCode,
        "values": values == null
            ? []
            : List<dynamic>.from(values!.map((x) => x.toJson())),
        "quantity": quantity,
      };
}

class Value {
  String? voucherCode;
  String? giftcardUrl;

  Value({
    this.voucherCode,
    this.giftcardUrl,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        voucherCode: json["voucher_code"],
        giftcardUrl: json["giftcard_url"],
      );

  Map<String, dynamic> toJson() => {
        "voucher_code": voucherCode,
        "giftcard_url": giftcardUrl,
      };
}
