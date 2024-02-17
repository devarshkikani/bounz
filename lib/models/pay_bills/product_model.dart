import 'dart:convert';
// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

ProductModel productModelFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  int? id;
  int? productId;
  String? name;
  String? description;
  int? serviceId;
  String? serviceName;
  int? operatorId;
  String? operatorName;
  String? operatorImgUrl;
  String? country;
  String? sourceAmount;
  String? sourceAmountMin;
  String? sourceAmountMax;
  String? sourceCurrency;
  String? destinationAmount;
  String? destinationAmountMin;
  String? destinationAmountMax;
  String? destinationAmountIncrement;
  String? destinationCurrency;
  String? buying;
  String? buyingMin;
  String? buyingMax;
  String? buyingFee;
  String? buyingCurrency;
  String? selling;
  String? sellingMin;
  String? sellingMax;
  String? sellingFee;
  String? sellingCurrency;
  String? baseRate;
  String? retailRate;
  String? wholesaleRate;
  String? productValidity;
  String? requiredDebitPartyIdentifierFields;
  String? requiredCreditPartyIdentifierFields;
  String? requiredSenderFields;
  String? requiredBeneficiaryFields;
  String? availabilityZones;
  String? productType;
  String? pinUsageInfo;
  String? pinValidity;
  String? creditsAmount;
  String? creditsMinimumAmount;
  String? creditsMaximumAmount;
  String? creditsUnit;
  String? creditsAdditionalInformation;
  String? talktimeAmount;
  String? talktimeMinimumAmount;
  String? talktimeMaximumAmount;
  String? talktimeUnit;
  String? talktimeAdditionalInformation;
  String? dataAmount;
  String? dataMinimumAmount;
  String? dataMaximumAmount;
  String? dataUnit;
  String? dataAdditionalInformation;
  String? smsAmount;
  String? smsMinimumAmount;
  String? smsMaximumAmount;
  String? smsUnit;
  String? smsAdditionalInformation;
  String? paymentAmount;
  String? paymentMinimumAmount;
  String? paymentMaximumAmount;
  String? paymentUnit;
  String? paymentAdditionalInformation;
  String? supportsStatementInquiry;
  String? isoCode;
  int? convesFees;
  dynamic pricesRetailAmountMin;
  dynamic pricesRetailAmountMax;
  String? pricesRetailAmount;
  num? totalAmount;
  int? requiredPoints;
  int? earnPoint;

  ProductModel({
    this.id,
    this.productId,
    this.name,
    this.description,
    this.serviceId,
    this.serviceName,
    this.operatorId,
    this.operatorName,
    this.operatorImgUrl,
    this.country,
    this.sourceAmount,
    this.sourceAmountMin,
    this.sourceAmountMax,
    this.sourceCurrency,
    this.destinationAmount,
    this.destinationAmountMin,
    this.destinationAmountMax,
    this.destinationAmountIncrement,
    this.destinationCurrency,
    this.buying,
    this.buyingMin,
    this.buyingMax,
    this.buyingFee,
    this.buyingCurrency,
    this.selling,
    this.sellingMin,
    this.sellingMax,
    this.sellingFee,
    this.sellingCurrency,
    this.baseRate,
    this.retailRate,
    this.wholesaleRate,
    this.productValidity,
    this.requiredDebitPartyIdentifierFields,
    this.requiredCreditPartyIdentifierFields,
    this.requiredSenderFields,
    this.requiredBeneficiaryFields,
    this.availabilityZones,
    this.productType,
    this.pinUsageInfo,
    this.pinValidity,
    this.creditsAmount,
    this.creditsMinimumAmount,
    this.creditsMaximumAmount,
    this.creditsUnit,
    this.creditsAdditionalInformation,
    this.talktimeAmount,
    this.talktimeMinimumAmount,
    this.talktimeMaximumAmount,
    this.talktimeUnit,
    this.talktimeAdditionalInformation,
    this.dataAmount,
    this.dataMinimumAmount,
    this.dataMaximumAmount,
    this.dataUnit,
    this.dataAdditionalInformation,
    this.smsAmount,
    this.smsMinimumAmount,
    this.smsMaximumAmount,
    this.smsUnit,
    this.smsAdditionalInformation,
    this.paymentAmount,
    this.paymentMinimumAmount,
    this.paymentMaximumAmount,
    this.paymentUnit,
    this.paymentAdditionalInformation,
    this.supportsStatementInquiry,
    this.isoCode,
    this.convesFees,
    this.pricesRetailAmountMin,
    this.pricesRetailAmountMax,
    this.pricesRetailAmount,
    this.totalAmount,
    this.requiredPoints,
    this.earnPoint,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        productId: json["product_id"],
        name: json["name"],
        description: json["description"],
        serviceId: json["service_id"],
        serviceName: json["service_name"],
        operatorId: json["operator_id"],
        operatorName: json["operator_name"],
        operatorImgUrl: json["operator_img_url"],
        country: json["country"],
        sourceAmount: json["source_amount"],
        sourceAmountMin: json["source_amount_min"],
        sourceAmountMax: json["source_amount_max"],
        sourceCurrency: json["source_currency"],
        destinationAmount: json["destination_amount"],
        destinationAmountMin: json["destination_amount_min"],
        destinationAmountMax: json["destination_amount_max"],
        destinationAmountIncrement: json["destination_amount_increment"],
        destinationCurrency: json["destination_currency"],
        buying: json["buying"],
        buyingMin: json["buying_min"],
        buyingMax: json["buying_max"],
        buyingFee: json["buying_fee"],
        buyingCurrency: json["buying_currency"],
        selling: json["selling"],
        sellingMin: json["selling_min"],
        sellingMax: json["selling_max"],
        sellingFee: json["selling_fee"],
        sellingCurrency: json["selling_currency"],
        baseRate: json["base_rate"],
        retailRate: json["retail_rate"],
        wholesaleRate: json["wholesale_rate"],
        productValidity: json["product_validity"],
        requiredDebitPartyIdentifierFields:
            json["required_debit_party_identifier_fields"],
        requiredCreditPartyIdentifierFields:
            json["required_credit_party_identifier_fields"],
        requiredSenderFields: json["required_sender_fields"],
        requiredBeneficiaryFields: json["required_beneficiary_fields"],
        availabilityZones: json["availability_zones"],
        productType: json["product_type"],
        pinUsageInfo: json["pin_usage_info"],
        pinValidity: json["pin_validity"],
        creditsAmount: json["credits_amount"],
        creditsMinimumAmount: json["credits_minimum_amount"],
        creditsMaximumAmount: json["credits_maximum_amount"],
        creditsUnit: json["credits_unit"],
        creditsAdditionalInformation: json["credits_additional_information"],
        talktimeAmount: json["talktime_amount"],
        talktimeMinimumAmount: json["talktime_minimum_amount"],
        talktimeMaximumAmount: json["talktime_maximum_amount"],
        talktimeUnit: json["talktime_unit"],
        talktimeAdditionalInformation: json["talktime_additional_information"],
        dataAmount: json["data_amount"],
        dataMinimumAmount: json["data_minimum_amount"],
        dataMaximumAmount: json["data_maximum_amount"],
        dataUnit: json["data_unit"],
        dataAdditionalInformation: json["data_additional_information"],
        smsAmount: json["sms_amount"],
        smsMinimumAmount: json["sms_minimum_amount"],
        smsMaximumAmount: json["sms_maximum_amount"],
        smsUnit: json["sms_unit"],
        smsAdditionalInformation: json["sms_additional_information"],
        paymentAmount: json["payment_amount"],
        paymentMinimumAmount: json["payment_minimum_amount"],
        paymentMaximumAmount: json["payment_maximum_amount"],
        paymentUnit: json["payment_unit"],
        paymentAdditionalInformation: json["payment_additional_information"],
        supportsStatementInquiry: json["supports_statement_inquiry"],
        isoCode: json["iso_code"],
        convesFees: json["conves_fees"],
        pricesRetailAmountMin: json["prices_retail_amount_min"],
        pricesRetailAmountMax: json["prices_retail_amount_max"],
        pricesRetailAmount: json["prices_retail_amount"],
        totalAmount: json["total_amount"],
        requiredPoints: json["required_points"],
        earnPoint: json["earn_point"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product_id": productId,
        "name": name,
        "description": description,
        "service_id": serviceId,
        "service_name": serviceName,
        "operator_id": operatorId,
        "operator_name": operatorName,
        "operator_img_url": operatorImgUrl,
        "country": country,
        "source_amount": sourceAmount,
        "source_amount_min": sourceAmountMin,
        "source_amount_max": sourceAmountMax,
        "source_currency": sourceCurrency,
        "destination_amount": destinationAmount,
        "destination_amount_min": destinationAmountMin,
        "destination_amount_max": destinationAmountMax,
        "destination_amount_increment": destinationAmountIncrement,
        "destination_currency": destinationCurrency,
        "buying": buying,
        "buying_min": buyingMin,
        "buying_max": buyingMax,
        "buying_fee": buyingFee,
        "buying_currency": buyingCurrency,
        "selling": selling,
        "selling_min": sellingMin,
        "selling_max": sellingMax,
        "selling_fee": sellingFee,
        "selling_currency": sellingCurrency,
        "base_rate": baseRate,
        "retail_rate": retailRate,
        "wholesale_rate": wholesaleRate,
        "product_validity": productValidity,
        "required_debit_party_identifier_fields":
            requiredDebitPartyIdentifierFields,
        "required_credit_party_identifier_fields":
            requiredCreditPartyIdentifierFields,
        "required_sender_fields": requiredSenderFields,
        "required_beneficiary_fields": requiredBeneficiaryFields,
        "availability_zones": availabilityZones,
        "product_type": productType,
        "pin_usage_info": pinUsageInfo,
        "pin_validity": pinValidity,
        "credits_amount": creditsAmount,
        "credits_minimum_amount": creditsMinimumAmount,
        "credits_maximum_amount": creditsMaximumAmount,
        "credits_unit": creditsUnit,
        "credits_additional_information": creditsAdditionalInformation,
        "talktime_amount": talktimeAmount,
        "talktime_minimum_amount": talktimeMinimumAmount,
        "talktime_maximum_amount": talktimeMaximumAmount,
        "talktime_unit": talktimeUnit,
        "talktime_additional_information": talktimeAdditionalInformation,
        "data_amount": dataAmount,
        "data_minimum_amount": dataMinimumAmount,
        "data_maximum_amount": dataMaximumAmount,
        "data_unit": dataUnit,
        "data_additional_information": dataAdditionalInformation,
        "sms_amount": smsAmount,
        "sms_minimum_amount": smsMinimumAmount,
        "sms_maximum_amount": smsMaximumAmount,
        "sms_unit": smsUnit,
        "sms_additional_information": smsAdditionalInformation,
        "payment_amount": paymentAmount,
        "payment_minimum_amount": paymentMinimumAmount,
        "payment_maximum_amount": paymentMaximumAmount,
        "payment_unit": paymentUnit,
        "payment_additional_information": paymentAdditionalInformation,
        "supports_statement_inquiry": supportsStatementInquiry,
        "iso_code": isoCode,
        "conves_fees": convesFees,
        "prices_retail_amount_min": pricesRetailAmountMin,
        "prices_retail_amount_max": pricesRetailAmountMax,
        "prices_retail_amount": pricesRetailAmount,
        "total_amount": totalAmount,
        "required_points": requiredPoints,
        "earn_point": earnPoint,
      };
}
