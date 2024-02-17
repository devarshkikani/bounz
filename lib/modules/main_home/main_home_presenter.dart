import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/models/spin_wheel/wheel_details.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:bounz_revamp_app/utils/api_keys.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/models/dashboard/dashboard_model.dart';
import 'package:bounz_revamp_app/modules/main_home/main_home_view.dart';
import 'package:bounz_revamp_app/modules/dashboard/dashboard_local.dart';
import 'package:bounz_revamp_app/modules/main_home/main_home_model.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';

class MainHomePresenter {
  Future getHomePageData(BuildContext? context) async {}
  Future getProfileData() async {}
  void getFooterData() {}
  Future spinTheWheelListDesign(BuildContext? context) async {}
  set updateView(MainHomeView mainHomeView) {}
}

class BasicMainHomePresenter implements MainHomePresenter {
  late MainHomeView view;
  late MainHomeModel model;

  BasicMainHomePresenter() {
    view = MainHomeView();
    model = MainHomeModel(
      footerBgColor: AppColors.blackColor,
      footerHoverBgColor: AppColors.blackColor,
      footerHoverColor: AppColors.blackColor,
      footerTextColor: AppColors.blackColor,
    );
  }
  @override
  set updateView(MainHomeView mainHomeView) {
    view = mainHomeView;
    view.refreshModel(model);
  }

  @override
  Future getHomePageData(BuildContext? context) async {
    String cacheDate =
        StorageManager.getStringValue(AppConstString.cacheDatePrefKey) ??
            DateTime.now().dateTimeWithTZFormat.toString();
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethodCMS(
        // context: context,
        url: ApiPath.cmsEndPoint + ApiPath.getDashBoard,
        queryParams: {
          ApiKeys.screenCodeK: ApiKeys.dashboardScreenCode,
          ApiKeys.osK: GlobalSingleton.osType,
          ApiKeys.customerTierK: AppConstString.customerTierValue, // static
          ApiKeys.membershipNoK: GlobalSingleton.userInformation.membershipNo,
          ApiKeys.cacheDateK: cacheDate,
        });
    if (response != null) {
      model.dashBoardModel = DashBoardModel.fromJson(response);
      if (model.dashBoardModel?.status == true) {
        if (model.dashBoardModel?.statusCode == "SCR_0001") {
          DashboardLocal().dashboardSaveToLocal(model.dashBoardModel!);
          getFooterData();
        }
      } else if (model.dashBoardModel?.status == false) {
        if (model.dashBoardModel?.statusCode == "SCR_0002") {
          String? encodedData = StorageManager.getStringValue(
              AppConstString.dashboardDataPrefKey);
          if (encodedData != null) {
            model.dashBoardModel = dashBoardModelFromJson(encodedData);
            getFooterData();
          }
        }
      }
    }
    if (!GlobalSingleton.appLoaded) {
      MoenageManager.moengagePlugin.showInApp();
      GlobalSingleton.appLoaded = true;
    }
    view.refreshModel(model);
  }

  @override
  void getFooterData() {
    if (model.dashBoardModel != null) {
      model.footer = model.dashBoardModel!.data!.footer;
      for (int i = 0; i < model.footer![0].data!.length; i++) {
        if (model.footer![0].data![i].key == AppConstString.backgroundColor) {
          model.footerBgColor = getColor(model.footer![0].data![i].value!);
        } else if (model.footer![0].data![i].key == AppConstString.fontColor) {
          model.footerTextColor = getColor(model.footer![0].data![i].value!);
        } else if (model.footer![0].data![i].key == AppConstString.hoverColor) {
          model.footerHoverColor = getColor(model.footer![0].data![i].value!);
        } else if (model.footer![0].data![i].key ==
            AppConstString.hoverBackgroundColor) {
          model.footerHoverBgColor = getColor(model.footer![0].data![i].value!);
        }
      }
    }
    convertNetworkToFile();
    view.refreshModel(model);
  }

  Color getColor(String color) {
    String subStringColor = color.substring(1);
    return Color(int.parse("0xff" + subStringColor));
  }

  @override
  Future spinTheWheelListDesign(BuildContext? context) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpSpinWheel(
      url: ApiPath.apiEndPoint + ApiPath.spinTheWheelDesign,
      context: context,
      data: {
        "membership_no": GlobalSingleton.userInformation.membershipNo,
        'type': 'promo',
      },
    );
    if (response != null) {
      if (response['status'] == true) {
        GlobalSingleton.spinData = DataWheelDesign.fromJson(response);
        GlobalSingleton.isWheelSpined = false;
      } else if (response['status'] == false) {
        GlobalSingleton.showBottomSheet = true;
        GlobalSingleton.isWheelSpined = true;
      }
      view.refreshModel(model);
    }
  }

  Future<void> convertNetworkToFile() async {
    if (model.dashBoardModel != null) {
      for (var i = 0;
          i < model.dashBoardModel!.data!.footer![0].tabs!.length;
          i++) {
        String url = model.dashBoardModel!.data!.assetPath! +
            model.dashBoardModel!.data!.footer![0].tabs![i].iconUrl!;
        if (!(url.contains('['))) {
          final http.Response responseData = await http.get(Uri.parse(url));
          Uint8List uint8list = responseData.bodyBytes;
          model.dashBoardModel!.data!.footer![0].tabs![i].iconUrl =
              uint8list.toString();
        }
      }
      for (int i = 0; i < model.dashBoardModel!.data!.body!.length; i++) {
        if (model.dashBoardModel!.data!.body![i].sectionCode ==
            AppConstString.moreWithBounz) {
          for (int j = 0;
              j <
                  model.dashBoardModel!.data!.body![i].sectionData[0]['data']
                      .length;
              j++) {
            String url = model.dashBoardModel!.data!.assetPath! +
                model.dashBoardModel!.data!.body![i].sectionData[0]['data'][j]
                    ['icon_url'];
            if (!(url.contains('['))) {
              final http.Response responseData = await http.get(Uri.parse(url));
              Uint8List uint8list = responseData.bodyBytes;
              model.dashBoardModel!.data!.body![i].sectionData[0]['data'][j]
                  ['icon_url'] = uint8list.toString();
            }
          }
        }
      }
      DashboardLocal().dashboardSaveToLocal(model.dashBoardModel!);
    }
  }

  @override
  Future getProfileData() async {
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.getProfile,
      queryParameters: {
        'membership_no': GlobalSingleton.userInformation.membershipNo,
      },
    );
    if (response != null) {
      GlobalSingleton.userInformation = UserInformation.fromJson(
        response['data']['values'][0],
      );
      StorageManager.setStringValue(
        key: AppStorageKey.userInformation,
        value: userInformationToJson(GlobalSingleton.userInformation),
      );
    }
  }
}
