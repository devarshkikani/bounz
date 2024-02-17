import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/models/gif_card_voucher/gift_voucher_details.dart';
import 'package:bounz_revamp_app/modules/gift_cards/gift_card_details/gift_card_details_view.dart';
import 'package:bounz_revamp_app/modules/gift_cards/gift_card_details/gift_card_details_model.dart';

class GiftCardDetailsPresenter {
  Future getVoucherDetails() async {}
  set updateModel(GiftCardDetailsView model) {}
}

class BasicGiftCardDetailsPresenter implements GiftCardDetailsPresenter {
  late GiftCardDetailsView view;
  late GiftCardDetailsModel model;
  BasicGiftCardDetailsPresenter({
    required String giftCategory,
    required String supplierCode,
    required int giftcardId,
  }) {
    view = GiftCardDetailsView();
    model = GiftCardDetailsModel(
      giftCategory: giftCategory,
      supplierCode: supplierCode,
      giftcardId: giftcardId,
      valuesList: [],
      selectedIndex: 0,
      price: 0,
      showPrice: 0,
      error: false,
    );
  }

  @override
  Future getVoucherDetails() async {
    final Map<String, dynamic> queryParameters = {
      "channel": 'mobile',
      "supplier_code": model.supplierCode,
      "giftcard_id": model.giftcardId,
    };
    Map<String, dynamic>? response =
        await NetworkDio.getGiftVoucherDioHttpMethod(
      url: ApiPath.giftCardEndPoint + ApiPath.giftVoucherDetails,
      queryParameters: queryParameters,
    );
    if (response != null) {
      if (response['status'] == true) {
        model.error = false;
        model.giftVouchersDetail = GiftVouchersDetail.fromJson(response);
        if (model.giftVouchersDetail?.objects?.denominationType == 'Range') {
          double currentValue = 0;
          for (var i = 0;
              i < model.giftVouchersDetail!.objects!.denominationTo! / 50;
              i++) {
            if (i == 0) {
              currentValue = model
                  .giftVouchersDetail!.objects!.denominationFrom!
                  .toDouble();
            } else if ((i + 1) ==
                model.giftVouchersDetail!.objects!.denominationTo! / 50) {
              currentValue =
                  model.giftVouchersDetail!.objects!.denominationTo!.toDouble();
            } else {
              currentValue += 50.0;
            }
            model.valuesList.add(currentValue);
          }
        }
      } else {
        model.error = true;
      }
    } else {
      model.error = true;
    }
    view.refreshModel(model);
  }

  @override
  set updateModel(GiftCardDetailsView giftCardDetailsView) {
    view = giftCardDetailsView;
    view.refreshModel(model);
  }
}
