import 'dart:convert';
// To parse this JSON data, do
//
//     final digitalreceiptmodel = digitalreceiptmodelFromJson(jsonString);

Digitalreceiptmodel digitalreceiptmodelFromJson(String str) =>
    Digitalreceiptmodel.fromJson(json.decode(str));

String digitalreceiptmodelToJson(Digitalreceiptmodel data) =>
    json.encode(data.toJson());

class Digitalreceiptmodel {
  String? merchantLogo;
  String? merchantName;
  dynamic membershipNo;
  String? customerPhone;
  String? countryCode;
  String? storeAddress;
  String? storeTrn;
  String? storeDetail;
  String? storeName;
  String? storeEmail;
  String? storePhone;
  String? billNumber;
  String? cashierId;
  String? billDate;
  String? billTime;
  String? receiptNumber;
  String? barcode;
  String? footerMessageLine0;
  String? footerMessageLine1;
  String? customerTrn;
  List<InvoiceDetail>? invoiceDetails;
  SumTotal? sumTotal;
  List<PaymentDetail>? paymentDetails;
  List<PromotionalDetail>? promotionalDetails;
  bool? apiLogin;
  String? partnerId;
  String? downloadURL;

  Digitalreceiptmodel(
      {this.merchantLogo,
      this.merchantName,
      this.membershipNo,
      this.customerPhone,
      this.countryCode,
      this.storeAddress,
      this.storeTrn,
      this.storeDetail,
      this.storeName,
      this.storeEmail,
      this.storePhone,
      this.billNumber,
      this.cashierId,
      this.billDate,
      this.billTime,
      this.receiptNumber,
      this.barcode,
      this.footerMessageLine0,
      this.footerMessageLine1,
      this.customerTrn,
      this.invoiceDetails,
      this.sumTotal,
      this.paymentDetails,
      this.promotionalDetails,
      this.apiLogin,
      this.partnerId,
      this.downloadURL});

  factory Digitalreceiptmodel.fromJson(Map<String, dynamic> json) =>
      Digitalreceiptmodel(
        merchantLogo: json["merchant_logo"],
        merchantName: json["merchant_name"],
        membershipNo: json["membership_no"],
        customerPhone: json["customer_phone"],
        countryCode: json["country_code"],
        storeAddress: json["store_address"],
        storeTrn: json["store_trn"],
        storeDetail: json["store_detail"],
        storeName: json["store_name"],
        storeEmail: json["store_email"],
        storePhone: json["store_phone"],
        billNumber: json["bill_number"],
        cashierId: json["cashier_id"],
        billDate: json["bill_date"],
        billTime: json["bill_time"],
        receiptNumber: json["receipt_number"],
        barcode: json["barcode"],
        apiLogin: json["api_login"],
        footerMessageLine0: json["footer_message_line0"],
        footerMessageLine1: json["footer_message_line1"],
        customerTrn: json["customer_trn"],
        invoiceDetails: json["invoice_details"] == null
            ? []
            : List<InvoiceDetail>.from(
                json["invoice_details"]!.map((x) => InvoiceDetail.fromJson(x))),
        sumTotal: json["sum_total"] == null
            ? null
            : SumTotal.fromJson(json["sum_total"]),
        paymentDetails: json["payment_details"] == null
            ? []
            : List<PaymentDetail>.from(
                json["payment_details"]!.map((x) => PaymentDetail.fromJson(x))),
        promotionalDetails: json["promotional_details"] == null
            ? []
            : List<PromotionalDetail>.from(json["promotional_details"]!
                .map((x) => PromotionalDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "merchant_logo": merchantLogo,
        "merchant_name": merchantName,
        "membership_no": membershipNo,
        "customer_phone": customerPhone,
        "country_code": countryCode,
        "store_address": storeAddress,
        "store_trn": storeTrn,
        "store_detail": storeDetail,
        "store_name": storeName,
        "store_email": storeEmail,
        "store_phone": storePhone,
        "bill_number": billNumber,
        "cashier_id": cashierId,
        "bill_date": billDate,
        "bill_time": billTime,
        "receipt_number": receiptNumber,
        "barcode": barcode,
        "footer_message_line0": footerMessageLine0,
        "footer_message_line1": footerMessageLine1,
        "customer_trn": customerTrn,
        "api_login": apiLogin,
        "invoice_details": invoiceDetails == null
            ? []
            : List<dynamic>.from(invoiceDetails!.map((x) => x.toJson())),
        "sum_total": sumTotal?.toJson(),
        "payment_details": paymentDetails == null
            ? []
            : List<dynamic>.from(paymentDetails!.map((x) => x.toJson())),
        "promotional_details": promotionalDetails == null
            ? []
            : List<dynamic>.from(promotionalDetails!.map((x) => x.toJson())),
      };
}

class InvoiceDetail {
  String? skuBarcode;
  String? skuItemName;
  num? skuQuantity;
  num? skuPrice;
  num? skuTax;
  num? skuBaseAmount;
  num? skuTotalAmount;
  String? vatRate;
  num? srNo;
  String? unitExclPrice;
  num? amount;
  String? totExclPrice;
  String? vatAmount;

  InvoiceDetail({
    this.skuBarcode,
    this.skuItemName,
    this.skuQuantity,
    this.skuPrice,
    this.skuTax,
    this.skuBaseAmount,
    this.skuTotalAmount,
    this.vatRate,
    this.srNo,
    this.unitExclPrice,
    this.amount,
    this.totExclPrice,
    this.vatAmount,
  });

  factory InvoiceDetail.fromJson(Map<String, dynamic> json) => InvoiceDetail(
        skuBarcode: json["sku_barcode"],
        skuItemName: json["sku_item_name"],
        skuQuantity: json["sku_quantity"],
        skuPrice: json["sku_price"],
        skuTax: json["sku_tax"],
        skuBaseAmount: json["sku_base_amount"],
        skuTotalAmount: json["sku_total_amount"],
        vatRate: json["VAT_rate"],
        srNo: json["sr_no"],
        unitExclPrice: json["unit_excl_price"],
        amount: json["amount"],
        totExclPrice: json["tot_excl_price"].toString(),
        vatAmount: json["VAT_amount"],
      );

  Map<String, dynamic> toJson() => {
        "sku_barcode": skuBarcode,
        "sku_item_name": skuItemName,
        "sku_quantity": skuQuantity,
        "sku_price": skuPrice,
        "sku_tax": skuTax,
        "sku_base_amount": skuBaseAmount,
        "sku_total_amount": skuTotalAmount,
        "VAT_rate": vatRate,
        "sr_no": srNo,
        "unit_excl_price": unitExclPrice,
        "amount": amount,
        "tot_excl_price": totExclPrice,
        "VAT_amount": vatAmount,
      };
}

class PaymentDetail {
  String? paymentType;
  num? amount;

  PaymentDetail({
    this.paymentType,
    this.amount,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) => PaymentDetail(
        paymentType: json["payment_type"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "payment_type": paymentType,
        "amount": amount,
      };
}

class PromotionalDetail {
  String? promoType;
  String? value;

  PromotionalDetail({
    this.promoType,
    this.value,
  });

  factory PromotionalDetail.fromJson(Map<String, dynamic> json) =>
      PromotionalDetail(
        promoType: json["promo_type"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "promo_type": promoType,
        "value": value,
      };
}

class SumTotal {
  num? quantity;
  String? totalExclVat;
  String? taxAmount;
  String? billAmount;
  String? billAmountWords;
  String? paidAmount;

  SumTotal({
    this.quantity,
    this.totalExclVat,
    this.taxAmount,
    this.billAmount,
    this.billAmountWords,
    this.paidAmount,
  });

  factory SumTotal.fromJson(Map<String, dynamic> json) => SumTotal(
      quantity: json["quantity"]?.toDouble(),
      totalExclVat: json["total_excl_vat"],
      taxAmount: json["tax_amount"],
      billAmount: json["bill_amount"],
      billAmountWords: json["bill_amount_words"],
      paidAmount: json["paid_amount"].toString());

  Map<String, dynamic> toJson() => {
        "quantity": quantity,
        "total_excl_vat": totalExclVat,
        "tax_amount": taxAmount,
        "bill_amount": billAmount,
        "bill_amount_words": billAmountWords,
        "paid_amount": paidAmount,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
