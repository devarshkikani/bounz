import 'package:bounz_revamp_app/models/purchased_history_card/purchased_history_card.dart';

class PurchasedHistoryModel {
  double? redemptionRate; //=  0.012
  int? offerPloughbackFactor;
  int? rpm;
  List<PurchasedHistoryCard>? purchasedHistoryList;
  PurchasedHistoryModel({
    this.purchasedHistoryList,
    this.redemptionRate,
    this.offerPloughbackFactor,
    this.rpm,
  });
}
