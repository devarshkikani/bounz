import 'package:bounz_revamp_app/models/degital_receipts/receipts_model.dart';
import 'package:flutter/material.dart';

class ReceiptsListModel {
  List<Receipts>? receiptsList;
  int offset;
  int transactionCount;
  ScrollController? scrollController;
  ReceiptsListModel({
    this.receiptsList,
    this.offset = 0,
    this.transactionCount = 0,
    this.scrollController
  });
}
