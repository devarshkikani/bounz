import 'package:bounz_revamp_app/models/partner_coupon/partner_coupon.dart';

class VoucherHistoryModel {
  int offSetCount;
  bool dataUpdated;
  bool isPageLoading;
  PartnerCouponsModel? partnerCouponsModel;
  List<PartnerCouponList>? partnerCouponList;
  VoucherHistoryModel(
      {this.partnerCouponsModel,
      this.partnerCouponList,
      required this.offSetCount,
      required this.isPageLoading,
      required this.dataUpdated});
}
