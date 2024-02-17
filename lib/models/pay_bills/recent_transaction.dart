// To parse this JSON data, do
//
//     final recentTransaction = recentTransactionFromJson(jsonString);

import 'dart:convert';

RecentTransaction recentTransactionFromJson(String str) =>
    RecentTransaction.fromJson(json.decode(str));

String recentTransactionToJson(RecentTransaction data) =>
    json.encode(data.toJson());

class RecentTransaction {
  String? countryCode;
  String? isoCode;
  String? countryName;
  String? countryImgUrl;
  String? mobileNumberLength;
  String? transactionsId;
  String? amount;
  String? transactionType;
  String? transactionStatus;
  String? paymentStatus;
  String? customerName;
  String? customerEmail;
  String? customerPhone;
  String? customerId;
  String? productName;
  dynamic productValidity;
  int? productId;
  String? country;
  String? operatorName;
  String? operatorImage;
  String? serviceName;
  String? serviceImage;
  int? serviceId;
  int? operatorId;
  String? mobileNumber;
  dynamic accountNumber;
  dynamic accountQualifier;
  String? pricesRetailAmount;
  String? productType;
  dynamic supportsStatementInquiry;
  String? dtStatus;
  String? dtTransactionsid;
  dynamic totalAmount;
  int? convesFees;
  String? requiredCreditPartyIdentifierFields;
  DateTime? transactionDate;
  String? amtWithoutFee;
  String? code;
  String? serial;
  String? usageInfo;
  String? validity;
  int? requiredPoints;
  int? earnPoint;
  double? redemptionRate;
  int? offerPloughbackFactor;
  int? rpm;

  RecentTransaction({
    this.countryCode,
    this.isoCode,
    this.countryName,
    this.countryImgUrl,
    this.mobileNumberLength,
    this.transactionsId,
    this.amount,
    this.transactionType,
    this.transactionStatus,
    this.paymentStatus,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.customerId,
    this.productName,
    this.productValidity,
    this.productId,
    this.country,
    this.operatorName,
    this.operatorImage,
    this.serviceName,
    this.serviceImage,
    this.serviceId,
    this.operatorId,
    this.mobileNumber,
    this.accountNumber,
    this.accountQualifier,
    this.pricesRetailAmount,
    this.productType,
    this.supportsStatementInquiry,
    this.dtStatus,
    this.dtTransactionsid,
    this.totalAmount,
    this.convesFees,
    this.requiredCreditPartyIdentifierFields,
    this.transactionDate,
    this.amtWithoutFee,
    this.code,
    this.serial,
    this.usageInfo,
    this.validity,
    this.requiredPoints,
    this.earnPoint,
    this.redemptionRate,
    this.offerPloughbackFactor,
    this.rpm,
  });

  factory RecentTransaction.fromJson(Map<String, dynamic> json) =>
      RecentTransaction(
        countryCode: json["country_code"],
        isoCode: json["iso_code"],
        countryName: json["country_name"],
        countryImgUrl: json["country_img_url"],
        mobileNumberLength: json["mobile_number_length"],
        transactionsId: json["transactions_id"],
        amount: json["amount"],
        transactionType: json["transaction_type"],
        transactionStatus: json["transaction_status"],
        paymentStatus: json["payment_status"],
        customerName: json["customer_name"],
        customerEmail: json["customer_email"],
        customerPhone: json["customer_phone"],
        customerId: json["customer_id"],
        productName: json["product_name"],
        productValidity: json["product_validity"],
        productId: json["product_id"],
        country: json["country"],
        operatorName: json["operator_name"],
        operatorImage: json["operator_image"],
        serviceName: json["service_name"],
        serviceImage: json["service_image"],
        serviceId: json["service_id"],
        operatorId: json["operator_id"],
        mobileNumber: json["mobile_number"],
        accountNumber: json["account_number"],
        accountQualifier: json["account_qualifier"],
        pricesRetailAmount: json["prices_retail_amount"],
        productType: json["product_type"],
        supportsStatementInquiry: json["supports_statement_inquiry"],
        dtStatus: json["dt_status"],
        dtTransactionsid: json["dt_transactionsid"],
        totalAmount: json["total_amount"],
        convesFees: json["conves_fees"],
        requiredCreditPartyIdentifierFields:
            json["required_credit_party_identifier_fields"],
        transactionDate: json["transaction_date"] == null
            ? null
            : DateTime.parse(json["transaction_date"]),
        amtWithoutFee: json["amt_without_fee"],
        code: json["code"],
        serial: json["serial"],
        usageInfo: json["usage_info"],
        validity: json["validity"],
        requiredPoints: json["required_points"],
        earnPoint: json["earn_point"],
        redemptionRate: json["redemption_rate"]?.toDouble(),
        offerPloughbackFactor: json["offer_ploughback_factor"],
        rpm: json["rpm"],
      );

  Map<String, dynamic> toJson() => {
        "country_code": countryCode,
        "iso_code": isoCode,
        "country_name": countryName,
        "country_img_url": countryImgUrl,
        "mobile_number_length": mobileNumberLength,
        "transactions_id": transactionsId,
        "amount": amount,
        "transaction_type": transactionType,
        "transaction_status": transactionStatus,
        "payment_status": paymentStatus,
        "customer_name": customerName,
        "customer_email": customerEmail,
        "customer_phone": customerPhone,
        "customer_id": customerId,
        "product_name": productName,
        "product_validity": productValidity,
        "product_id": productId,
        "country": country,
        "operator_name": operatorName,
        "operator_image": operatorImage,
        "service_name": serviceName,
        "service_image": serviceImage,
        "service_id": serviceId,
        "operator_id": operatorId,
        "mobile_number": mobileNumber,
        "account_number": accountNumber,
        "account_qualifier": accountQualifier,
        "prices_retail_amount": pricesRetailAmount,
        "product_type": productType,
        "supports_statement_inquiry": supportsStatementInquiry,
        "dt_status": dtStatus,
        "dt_transactionsid": dtTransactionsid,
        "total_amount": totalAmount,
        "conves_fees": convesFees,
        "required_credit_party_identifier_fields":
            requiredCreditPartyIdentifierFields,
        "transaction_date": transactionDate?.toIso8601String(),
        "amt_without_fee": amtWithoutFee,
        "code": code,
        "serial": serial,
        "usage_info": usageInfo,
        "validity": validity,
        "required_points": requiredPoints,
        "earn_point": earnPoint,
        "redemption_rate": redemptionRate,
        "offer_ploughback_factor": offerPloughbackFactor,
        "rpm": rpm,
      };
}
