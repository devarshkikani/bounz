import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/main.dart';
import 'package:bounz_revamp_app/models/offer/new_offer_detail_model.dart';
import 'package:bounz_revamp_app/modules/offers/offer_detail/offer_detail_model.dart';
import 'package:bounz_revamp_app/modules/offers/offer_detail/offer_detail_view.dart';
import 'package:bounz_revamp_app/services/dynamiclinks.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/get_user_location.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';

class OfferDetailPresenter {
  Future<void> getOfferDetails({
    required String offerCode,
  }) async {}
  set updateView(OfferDetailView offerDetailView) {}
}

class BasicOfferDetailPresenter implements OfferDetailPresenter {
  late OfferDetailView view;
  late OfferDetailModel model;

  BasicOfferDetailPresenter() {
    view = OfferDetailView();
    model = OfferDetailModel(
      selectedOutletIndex: 0,
    );
  }

  Future getDynamicLink() async {
    try {
      model.offerDynamicLin = await FirebaseDynamicLinkService()
          .createOfferDeepLink(model.newOfferDetailModel!.offerCode!);
    } catch (_) {}
    view.refreshModel(model);
  }

  @override
  set updateView(OfferDetailView offerDetailView) {
    view = offerDetailView;
    view.refreshModel(model);
  }

  @override
  Future<void> getOfferDetails({
    required String offerCode,
  }) async {
    String getUserLocation = await UserLocation().getCurrentPosition(() {
      getOfferDetails(offerCode: offerCode);
    }, null, 0);
    if (getUserLocation == "SUCCESS") {
      Map<String, dynamic>? response = await NetworkDio.postOfferListCat(
        url: ApiPath.offerDetail,
        data: {
          "offer_code": offerCode,
          "lat": GlobalSingleton.currentPosition?.latitude,
          "long": GlobalSingleton.currentPosition?.longitude
        },
      );
      if (response != null) {
        if (response['statuscode'] == 200) {
          model.errorMessgae = null;
          model.newOfferDetailModel =
              NewOfferDetailModel.fromJson(response['data']['values']);
          model.newOfferDetailModel!.allBranches
              ?.sort((a, b) => a.distanceInKm!.compareTo(b.distanceInKm!));
          await getDynamicLink();
        } else if (response['statuscode'] == 800) {
          model.errorMessgae = response['message'];
        }
      }
      view.refreshModel(model);
    } else if (getUserLocation == "PERMISSION") {
      appRouter.push(
        MainHomeScreenRoute(
          isFirstLoad: GlobalSingleton.fromSplash == false,
          index: 0,
          isShowDialog: true,
        ),
      );
    }
  }
}
