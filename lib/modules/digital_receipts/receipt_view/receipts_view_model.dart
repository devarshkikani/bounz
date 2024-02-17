class ReceiptViewModel {
  String? merchantLogo;
  String? merchantName;
  String? storeAddress;
  String? storeTrn;
  String? storeName;
  String? storeEmail;
  String? storePhone;
  String? billNumber;
  String? cashierId;
  String? billDate;
  String? billTime;
  List<String>? invoiceDetails;
  String? sumTotal;
  String? paymentDetails;
  String? promotionalDetails;
  String? barcode;
  String? receiptNumber;
  String? footerMessageLine0;
  String? footerMessageLine1;
  

  // late String billNumber;
  late String partnerId;
  String? downloadURL;
  ReceiptViewModel({
    required this.billNumber,
    required this.partnerId,
    this.downloadURL,
  });
}
