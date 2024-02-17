import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/modules/partners/partner_home/partner_home_screen.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/models/partner/partner_list_model.dart';
import 'package:bounz_revamp_app/modules/partners/partner_home/partner_home_view.dart';
import 'package:bounz_revamp_app/modules/partners/partner_home/partner_home_model.dart';

class PartnerHomeViewPresenter {
  Future getPartnerHomeData() async {}
  set updateView(PartnerHomeView partnerHomeView) {}
}

class BasicPartnerHomeViewPresenter implements PartnerHomeViewPresenter {
  late PartnerHomeViewModel model;
  late PartnerHomeView view;
  bool isCalling = true;

  BasicPartnerHomeViewPresenter() {
    view = PartnerHomeView();
    model = PartnerHomeViewModel();
  }

  @override
  Future getPartnerHomeData() async {
    String? partnerListModel =
        StorageManager.getStringValue(AppStorageKey.storePartner);
    if (partnerListModel != null) {
      model.partnerListModel = partnerListModelFromJson(partnerListModel);
    }
    if (isCalling) {
      isCalling = false;
      Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
        url: ApiPath.allPartnerListCat,
        data: {
          "platform": Platform.isAndroid ? 'android' : 'ios',
        },
      );
      if (response != null) {
        isPartnerApiCalled = true;
        isCalling = true;
        model.partnerListModel =
            PartnerListModel.fromJson(response['data']['values']);
        convertNetworkToFile();
      }
      view.refreshModel(model);
    }
  }

  Future<void> convertNetworkToFile() async {
    for (var i = 0; i < model.partnerListModel!.catValues!.length; i++) {
      if (model.partnerListModel!.catValues![i].catImage != null) {
        if (!(model.partnerListModel!.catValues![i].catImage
            .toString()
            .contains('['))) {
          final http.Response responseData = await http
              .get(Uri.parse(model.partnerListModel!.catValues![i].catImage!));
          Uint8List uint8list = responseData.bodyBytes;
          model.partnerListModel!.catValues![i].catImage = uint8list.toString();
        }
      }
    }
    StorageManager.setStringValue(
        key: AppStorageKey.storePartner,
        value: partnerListModelToJson(model.partnerListModel!));
  }

  @override
  set updateView(PartnerHomeView partnerHomeView) {
    view = partnerHomeView;
    view.refreshModel(model);
  }
}
