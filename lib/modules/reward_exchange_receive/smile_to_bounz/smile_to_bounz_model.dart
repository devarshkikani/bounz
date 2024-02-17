import 'package:bounz_revamp_app/models/link_smile_acc/link_smile_account.dart';
import 'package:bounz_revamp_app/models/reward_exchange/all_member_data.dart';
import 'package:bounz_revamp_app/utils/progress_indicator.dart';

class SmileToBounzViewModel {
  DataAllMember? allMemberModel;
  String? smileId;
  LinkSmileAccModel? linkSmileAccModel;
  bool? status = false;
  bool? availablePoints = true;
  bool isGetData;
  bool isConversionDone;
  double? range = 0.0;
  String? userBounzPoints = "";
  String? smilesMemberID = "";
  double? value = 1.0;
  double? smilesPointsBal = 0;
  double? conversionRate = 0;
  double? conversionRateB = 0;
  double? conversionRateS = 0;
  double? minConversion = 0.0;
  String? roundOffMethod = "";
  double? equivalentPoint = 0;
  int? multiple;
  Circle? isLoading;

  SmileToBounzViewModel({
    this.allMemberModel,
    this.smileId,
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
    this.isGetData = false,
    this.isConversionDone = false,
    this.equivalentPoint,
    this.isLoading,
    this.multiple = 10,
  });
}
