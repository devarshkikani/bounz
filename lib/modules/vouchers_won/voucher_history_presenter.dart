import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/models/partner_coupon/partner_coupon.dart';
import 'package:bounz_revamp_app/modules/vouchers_won/voucher_history_model.dart';
import 'package:bounz_revamp_app/modules/vouchers_won/voucher_history_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';

class VoucherHistoryPresenter {
  Future<void> getVoucherList({required BuildContext context}) async {}
  set updateView(VoucherHistoryView view) {}
}

class BasicVoucherHistoryPresenter implements VoucherHistoryPresenter {
  late VoucherHistoryModel model;
  late VoucherHistoryView view;

  BasicVoucherHistoryPresenter() {
    view = VoucherHistoryView();
    model = VoucherHistoryModel(
      dataUpdated: false,
      isPageLoading: false,
      offSetCount: 0,
    );
  }

  @override
  Future getVoucherList({required BuildContext context}) async {
    model.isPageLoading = true;
    view.refreshModel(model);
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.partnerCouponSpinTheWheel,
      context: context,
      dontShowError: true,
      queryParameters: {
        "membership_no":
            GlobalSingleton.userInformation.membershipNo, //"1461424407",
        "limit": '10',
        "offset": model.offSetCount,
      },
    );
    model.partnerCouponList ??= [];
    if (response != null) {
      if (response['status'] == true) {
        model.partnerCouponsModel =
            PartnerCouponsModel.fromJson(response['data']);
        if (model.partnerCouponList != null) {
          model.partnerCouponList!.addAll(model.partnerCouponsModel!.values!);
        } else {
          model.partnerCouponList = model.partnerCouponsModel!.values;
        }
        if (model.partnerCouponsModel!.values!.length < 10) {
          model.dataUpdated = true;
        } else {
          model.offSetCount += 10;
        }
      }
    }
    model.isPageLoading = false;
    view.refreshModel(model);
  }

  @override
  set updateView(VoucherHistoryView voucherHistoryView) {
    view = voucherHistoryView;
    view.refreshModel(model);
  }
}
