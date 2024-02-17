import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/modules/offers/offer_home/offer_home_screen.dart';
import 'package:bounz_revamp_app/utils/get_user_location.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'offer_home_view.dart';
import 'offer_home_model.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/models/offer/offer_model.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/models/offer/offer_category_model.dart';

class OfferHomePresenter {
  Future getOfferHomeData(BuildContext context) async {}
  set updateView(OfferHomeView offerHomeView) {}
}

class BasicOfferHomePresenter implements OfferHomePresenter {
  late OfferHomeViewModel model;
  late OfferHomeView view;

  BasicOfferHomePresenter() {
    view = OfferHomeView();
    model = OfferHomeViewModel();
  }

  @override
  Future getOfferHomeData(BuildContext context) async {
    String getUserLocation = await UserLocation().getCurrentPosition(
      () {
        getOfferHomeData(context);
      },
      null,
      0,
    );
    if (getUserLocation == "SUCCESS") {
      Map<String, dynamic>? response = await NetworkDio.postOfferListCat(
        url: ApiPath.offer,
        data: {
          "searchtext": '',
          "lat": GlobalSingleton.currentPosition?.latitude,
          "long": GlobalSingleton.currentPosition?.longitude,
          "customer_id": GlobalSingleton.userInformation.membershipNo,
          "limit": '1000000',
          "offset": '0',
          "user_type": 'staff',
        },
      );
      model.offerList = [];
      model.offerCategoryList = [];
      if (response != null) {
        if (response['statuscode'] == 200) {
          isOfferApiCalled = true;
          for (Map<String, dynamic> e in response['data']['values']
              ['search_offers']['offerslist']) {
            model.offerList!.add(OfferModel.fromJson(e));
          }
          for (Map<String, dynamic> e in response['data']['values']
              ['search_offers']['categorylist']) {
            model.offerCategoryList!.add(OfferCategoryModel.fromJson(e));
          }
        }
      }
      convertNetworkToFile();
      view.refreshModelOffer(model);
    } else if (getUserLocation == "PERMISSION") {
      AutoRouter.of(context).push(
        MainHomeScreenRoute(
          isFirstLoad: GlobalSingleton.fromSplash == false,
          index: 0,
          isShowDialog: true,
        ),
      );
    }
  }

  Future<void> convertNetworkToFile() async {
    for (var i = 0; i < model.offerCategoryList!.length; i++) {
      if (model.offerCategoryList![i].catImage != null) {
        if (!(model.offerCategoryList![i].catImage.toString().contains('['))) {
          final http.Response responseData =
              await http.get(Uri.parse(model.offerCategoryList![i].catImage!));
          Uint8List uint8list = responseData.bodyBytes;
          model.offerCategoryList![i].catImage = uint8list.toString();
        }
      }
    }
    StorageManager.setStringValue(
        key: AppStorageKey.storeOfferCatImage,
        value: jsonEncode(model.offerCategoryList!));
  }

  @override
  set updateView(OfferHomeView offerHomeView) {
    view = offerHomeView;
    view.refreshModelOffer(model);
  }
}
