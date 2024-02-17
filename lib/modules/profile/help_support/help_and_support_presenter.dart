import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/models/help_support/help_and_support.dart';
import 'package:bounz_revamp_app/modules/profile/help_support/help_and_support_view.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:flutter/material.dart';

import 'help_and_support_model.dart';

class HelpSupportPresenter {
  Future getHelpSupportData(BuildContext context) async {}
  set updateView(HelpSupportView model) {}
}

class BasicHelpSupportViewPresenter implements HelpSupportPresenter {

  late HelpSupportModelView model;
  late HelpSupportView view;

  BasicHelpSupportViewPresenter() {
    view = HelpSupportView();
    model = HelpSupportModelView();
  }

  @override
  Future getHelpSupportData(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.helpSupportEndPoint,
      context: context
    );
    if(response != null){
      model.helpSupportModel = HelpSupportModel.fromJson(response);
      StorageManager.setStringValue(
        key: AppStorageKey.helpSupportData,
        value: helpSupportModelToJson(model.helpSupportModel!),
      );
    }
    view.refreshModel(model);
  }

  @override
  set updateView(HelpSupportView helpSupportView) {
    view = helpSupportView;
    view.refreshModel(model);
  }

}