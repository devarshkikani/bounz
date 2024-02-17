import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/modules/redeemed_offer/redeem_offer_home/redeem_offer_model.dart';
import 'package:bounz_revamp_app/modules/redeemed_offer/redeem_offer_home/redeem_offer_view.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:flutter/material.dart';

import '../../../models/redeem_offer/redeem_offer.dart';

class RedeemOfferPresenter {
  Future getRedeemOfferData(BuildContext context) async {}
  set updateView(RedeemOfferView offerHomeView) {}
}

class BasicRedeemOfferViewPresenter implements RedeemOfferPresenter {
  late RedeemOfferViewModel model;
  late RedeemOfferView view;

  BasicRedeemOfferViewPresenter() {
    view = RedeemOfferView();
    model = RedeemOfferViewModel();
  }

  @override
  Future getRedeemOfferData(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.redeemOfferDetail,
      context: context,
      data: {
        "customer_id": GlobalSingleton.userInformation.membershipNo,
      },
    );
    if (response != null) {
      if (response['data']['code'] == 'CUS_00100') {
        List<RedeemOfferValues> redeemOfferList = [];
        for (Map<String, dynamic> i in response['data']['values']) {
          redeemOfferList.add(RedeemOfferValues.fromJson(i));
        }
        model.redeemOfferList = redeemOfferList;
      }
    }
    view.refreshModel(model);
  }

  @override
  set updateView(RedeemOfferView offerHomeView) {
    view = offerHomeView;
    view.refreshModel(model);
  }
}
