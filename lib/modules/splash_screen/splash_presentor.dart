import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/models/check_force_update/check_force_update_model.dart';
import 'package:bounz_revamp_app/modules/splash_screen/splash_model.dart';
import 'package:bounz_revamp_app/services/dynamiclinks.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:flutter/material.dart';
import 'package:moengage_flutter/model/app_status.dart';

class SplashViewPresenter {
  Future checkForceUpdateApiCall(BuildContext context) async {}
}

class BasicSplashPresenter implements SplashViewPresenter {
  late SplashViewModel model;

  BasicSplashPresenter() {
    model = SplashViewModel();
  }

  @override
  Future checkForceUpdateApiCall(context) async {
    Map<String, dynamic>? response = await NetworkDio.postCheckUpdateNetworkDio(
      url: ApiPath.checkForceUpdate,
      data: {
        "app_ver": GlobalSingleton.appVersion,
      },
    );
    if (response != null) {
      if (response['status'] == true) {
        model.checkForceUpdate = CheckForceUpdate.fromJson(response);
        if (model.checkForceUpdate != null) {
          if (model.checkForceUpdate!.status == true) {
            if (model.checkForceUpdate?.data?.forceUpdate == true) {
              AutoRouter.of(context).pushAndPopUntil(
                ForceUpdateScreenRoute(canSkip: true),
                predicate: (_) => true,
              );
            } else if (model.checkForceUpdate?.data?.update == true) {
              AutoRouter.of(context)
                  .pushAndPopUntil(
                ForceUpdateScreenRoute(canSkip: false),
                predicate: (_) => true,
              )
                  .then((value) {
                if (value == 'skip') {
                  navigate(context);
                }
              });
            } else {
              navigate(context);
            }
          } else {
            navigate(context);
          }
        }
      } else {
        navigate(context);
      }
    }
  }

  void navigate(context) async {
    StorageManager.setBoolValue(key: 'isBarcodeTapped', value: false);
    if (StorageManager.getBoolValue("isInstall") == null) {
      StorageManager.setBoolValue(key: 'isInstall', value: true);
      MoenageManager.moengagePlugin.setAppStatus(MoEAppStatus.install);
    }
    String? text =
        StorageManager.getStringValue(AppStorageKey.deletedAccountText);
    bool isProfileInCompleted = StorageManager.getBoolValue(
          AppStorageKey.isProfileInCompleted,
        ) ??
        false;
    if (text != null) {
      AutoRouter.of(context).pushAndPopUntil(
        DeletedAccountScreenRoute(
          isFromSplash: true,
        ),
        predicate: (_) => false,
      );
    } else if (isProfileInCompleted) {
      AutoRouter.of(context).pushAndPopUntil(
          MyProfileScreenRoute(
            fromSplash: true,
          ),
          predicate: (_) => false);
    } else {
      if (GlobalSingleton.isFromNotification != true) {
        String initialCheck =
            await FirebaseDynamicLinkService().initialCheck(context);
        if (initialCheck == '') {
          bool isLogedIn =
              StorageManager.getBoolValue(AppStorageKey.isLogIn) ?? false;
          if (isLogedIn) {
            navigateHome(context);
          } else {
            MoenageManager.logScreenEvent(name: 'Welcome');
            AutoRouter.of(context).pushAndPopUntil(
              WelcomeScreenRoute(),
              predicate: (_) => true,
            );
          }
        }
        return null;
      }
    }
  }

  void navigateHome(context) {
    MoenageManager.logScreenEvent(name: 'Main Home');
    MoenageManager.moengagePlugin
        .setUserAttribute("App Version", GlobalSingleton.appVersion);
    StorageManager.setBoolValue(key: 'isBarcodeTapped', value: false);
    AutoRouter.of(context).pushAndPopUntil(
        MainHomeScreenRoute(isFirstLoad: true),
        predicate: (_) => false);
  }
}
