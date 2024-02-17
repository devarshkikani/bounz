import 'package:bounz_revamp_app/models/my_bounz/expiry_detail_model.dart';
import 'package:bounz_revamp_app/models/my_bounz/my_bounz_card_model.dart';

class MybounzModel {
  int totalRedeemPoint;
  int currentIndex;
  int currentTabIndex;
  bool isExpiring;
  Map<String, dynamic> selectedMonth;
  ExpiryDetails? expiryDetails;
  List<MyBounzCardModel>? myBounzCardList;
  List<MyBounzCardModel>? filteredMyBounzCardList;
  List<Map<String, dynamic>>? merchantList;
  List<MyBounzCardModel>? earnedList;
  List<MyBounzCardModel>? reedemList;
  MybounzModel({
    required this.currentIndex,
    required this.currentTabIndex,
    required this.isExpiring,
    required this.selectedMonth,
    this.expiryDetails,
    required this.totalRedeemPoint,
    this.filteredMyBounzCardList,
    this.merchantList,
    this.earnedList,
    this.reedemList,
  });
}
