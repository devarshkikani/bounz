import 'package:bounz_revamp_app/models/link_smile_acc/link_smile_account.dart';
import 'package:bounz_revamp_app/models/reward_exchange/all_member_data.dart';

class RewardExchangeViewModel {
  DataAllMember? allMemberModel;
  DataLinkAcc? dataLinkAcc;
  LinkSmileAccModel? linkSmileAccModel;
  bool? status = false;
  bool? availablePoints = true;
  double? range = 0.0;
  String? userBounzPoints = "";
  String? smilesMemberID = "";
  double? value = 1.0;
  double? smilesPointsBal = 0;
  double? conversionRate = 0;
  double? minConversion = 0.0;
  String? roundOffMethod = "";
  double? equivalentPoint = 0;
  String? dropdownValue = "";


  RewardExchangeViewModel({
    this.allMemberModel,
    this.dataLinkAcc,
    this.linkSmileAccModel,
    this.status,
    this.range,
    this.userBounzPoints,
    this.value,
    this.smilesPointsBal,
    this.smilesMemberID,
    this.conversionRate,
    this.minConversion,
    this.availablePoints,
    this.equivalentPoint,
    this.dropdownValue,
  }
  );
}