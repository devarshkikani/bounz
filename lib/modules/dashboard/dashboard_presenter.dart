import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dashboard_view.dart';

class DashBoardPresenter {
  void redirectToSpinWheel(BuildContext context) {}

  void redirectToNotificationScreen(BuildContext context) {}

  void copyMembershipIdToClipboard(BuildContext context) {}

  void redirectToHome(BuildContext context, int index) {}

  void redirectToMyTravel(BuildContext context) {}

  void redirectToBuyGiftCard(BuildContext context) {}

  void redirectToPayBillDetail(BuildContext context, String serviceName,
      String serviceImgUrl, int serviceId, String moengageMsg) {}

  void redirectTopStories(
      BuildContext context, String navigationType, String navigationLink) {}

  void redirectToReferEarn(BuildContext context) {}

  void deepLinkNavigationWithEvent(
      BuildContext context, String moengageMsg, String navigationLink) {}

  void openExternalLink(
      BuildContext context, String moengageMsg, String navigationLink) {}

  void openWebLink(String moengageMsg, String navigationLink) {}
}

class BasicDashboardPresenter implements DashBoardPresenter {
  late DashBoardView view;

  BasicDashboardPresenter() {
    view = DashBoardView();
  }

  @override
  void redirectToSpinWheel(BuildContext context) {
    MoenageManager.logScreenEvent(name: 'Spin The Wheel');
    AutoRouter.of(context).pushNamed("/spin_the_wheel_screen/type/promo/false");
    // AutoRouter.of(context).pushNamed("/spin_the_wheel_screen/campaign_code/octTest/false");
  }

  @override
  void redirectToNotificationScreen(BuildContext context) {
    MoenageManager.logScreenEvent(name: 'Notification');

    AutoRouter.of(context).push(
      NotificationScreenRoute(),
    );
  }

  @override
  void copyMembershipIdToClipboard(BuildContext context) {
    NetworkDio.showWarning(
      context: context,
      message: 'Saved Membership Id in clipboard',
    );
    Clipboard.setData(
      ClipboardData(
        text: GlobalSingleton.userInformation.membershipNo.toString(),
      ),
    );
  }

  @override
  void redirectToHome(BuildContext context, int index) {
    MoenageManager.logScreenEvent(name: 'Main Home');

    AutoRouter.of(context).pushAndPopUntil(MainHomeScreenRoute(index: index),
        predicate: (_) => false);
  }

  @override
  void redirectToMyTravel(BuildContext context) {
    MoenageManager.logScreenEvent(name: 'My Travel');

    AutoRouter.of(context).push(
      MyTravelScreenRoute(
        apiPath: ApiPath.travelMoreWidBounz,
      ),
    );
  }

  @override
  void redirectToBuyGiftCard(BuildContext context) {
    MoenageManager.logScreenEvent(name: 'Buy Gift Cards');

    AutoRouter.of(context).push(
      BuyGiftCardsScreenRoute(),
    );
  }

  @override
  void redirectToPayBillDetail(BuildContext context, String serviceName,
      String serviceImgUrl, int serviceId, String moengageMsg) {
    MoenageManager.logScreenEvent(name: moengageMsg);

    AutoRouter.of(context)
        .pushNamed('pay_bill_screen/$serviceId/$serviceName/false');
  }

  @override
  Future<void> redirectTopStories(BuildContext context, String navigationType,
      String navigationLink) async {
    if (navigationType == "external") {
      if (!await launchUrl(Uri.parse(navigationLink))) {
        throw Exception('Could not launch $navigationLink');
      }
    }
  }

  @override
  void redirectToReferEarn(BuildContext context) {
    MoenageManager.logScreenEvent(name: 'Refer Earn');

    AutoRouter.of(context).push(
      ReferEarnScreenRoute(),
    );
  }

  @override
  void deepLinkNavigationWithEvent(
      BuildContext context, String moengageMsg, String navigationPath) {
    MoenageManager.logScreenEvent(name: moengageMsg);

    AutoRouter.of(context).pushNamed(navigationPath);
  }

  @override
  void openExternalLink(
      BuildContext context, String moengageMsg, String navigationLink) async {
    StorageManager.setStringValue(
      key: AppStorageKey.navLink,
      value: navigationLink,
    );
    MoenageManager.logScreenEvent(name: moengageMsg);
    AutoRouter.of(context).pushNamed('/external_link_screen/false');
  }

  @override
  Future<void> openWebLink(String moengageMsg, String navigationLink) async {
    MoenageManager.logScreenEvent(name: moengageMsg);
    Uri url = Uri.parse(navigationLink);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
