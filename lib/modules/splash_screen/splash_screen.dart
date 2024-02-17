import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/modules/splash_screen/splash_presentor.dart';
import 'package:bounz_revamp_app/utils/get_user_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen> {
  SplashViewPresenter presenter = BasicSplashPresenter();

  @override
  void initState() {
    super.initState();
    handleNotificationPermission(context);
  }

  Future<void> handleNotificationPermission(context) async {
    PermissionStatus status = await Permission.notification.status;

    if (status != PermissionStatus.granted &&
        status != PermissionStatus.limited) {
      await Permission.notification.request();
      final properties = MoEProperties();
      properties
          .addAttribute(TriggeringCondition.notificationPermission, "Deny")
          .setNonInteractiveEvent();
      MoenageManager.logEvent(
        MoenageEvent.subscribeToNotification,
        properties: properties,
      );
    }
    bool isShow =
        StorageManager.getBoolValue(AppStorageKey.showLocationPopUp) ?? false;
    if (!isShow) {
      UserLocation().getCurrentPosition(() => null, null, 0, dontDo: true);
      StorageManager.setBoolValue(
          key: AppStorageKey.showLocationPopUp, value: true);
    }
    presenter.checkForceUpdateApiCall(context);
    final properties = MoEProperties();
    properties
        .addAttribute(TriggeringCondition.notificationPermission, "Allow")
        .setNonInteractiveEvent();
    MoenageManager.logEvent(
      MoenageEvent.subscribeToNotification,
      properties: properties,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkOrangeColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AppAssets.backgroundLayer,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Center(
              child: Lottie.asset(
                AppAssets.roundedCircleYellow,
                repeat: true,
                fit: BoxFit.cover,
              ),
            ),
            Center(
              child: SvgPicture.asset(
                AppAssets.bounzWithLetter,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
