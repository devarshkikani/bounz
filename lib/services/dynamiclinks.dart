// ignore_for_file: invalid_use_of_protected_member

import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/main.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class FirebaseDynamicLinkService {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<String> createReferandEarnDynamicLink() async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse(
          'https://www.bounz.com?membership_no=${GlobalSingleton.userInformation.referralCode}'),
      uriPrefix: "https://bounzappuat.page.link",
      androidParameters: AndroidParameters(
          packageName: "com.vernost.BounzAppUAT", //"com.vernost.BounzAppUAT"
          fallbackUrl: Uri.parse(
              "https://play.google.com/store/apps/details?id=com.citypoints.bounzrewards")),
      iosParameters: const IOSParameters(bundleId: "com.vernost.bounzuat"),
    );
    final dynamicLink = await dynamicLinks.buildShortLink(dynamicLinkParams);
    return dynamicLink.shortUrl.toString();
  }

  Future<String> createPartnerDeepLink(String data) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse('https://www.bounz.com?data=$data'),
      uriPrefix: "https://bounzappuat.page.link",
      androidParameters: AndroidParameters(
          packageName: "com.vernost.BounzAppUAT", //"com.vernost.BounzAppUAT"
          fallbackUrl: Uri.parse(
              "https://play.google.com/store/apps/details?id=com.citypoints.bounzrewards")),
      iosParameters: const IOSParameters(bundleId: "com.vernost.bounzuat"),
    );
    final dynamicLink = await dynamicLinks.buildShortLink(dynamicLinkParams);
    return dynamicLink.shortUrl.toString();
  }

  Future<String> createOfferDeepLink(String offerCode) async {
    final dynamicLinkParams = DynamicLinkParameters(
      link: Uri.parse('https://www.bounz.com?offerCode=$offerCode'),
      uriPrefix: "https://bounzappuat.page.link",
      androidParameters: AndroidParameters(
          packageName: "com.vernost.BounzAppUAT", //"com.vernost.BounzAppUAT"
          fallbackUrl: Uri.parse(
              "https://play.google.com/store/apps/details?id=com.citypoints.bounzrewards")),
      iosParameters: const IOSParameters(bundleId: "com.vernost.bounzuat"),
    );
    final dynamicLink = await dynamicLinks.buildShortLink(dynamicLinkParams);
    return dynamicLink.shortUrl.toString();
  }

  Future<String> initialCheck(BuildContext context) async {
    String pagelink = '';

    dynamicLinks.onLink.listen((PendingDynamicLinkData? dynamiclink) async {
      final Uri? deepLink = dynamiclink?.link;
      if (deepLink!.query.contains("membership_no=")) {
        List<String> link = deepLink.query.split('=');
        if (link.length == 2) {
          GlobalSingleton.referralno = link[1];
        } else {
          GlobalSingleton.referralno = link[1].split('&').first;
        }
        if (deepLink.query.contains("store_code")) {
          GlobalSingleton.storeCode = link[2].split('&').first;
        }
        if (deepLink.query.contains("partner_id")) {
          GlobalSingleton.partnerId = link.last;
        }
      } else if (deepLink.query.contains("data")) {
        pagelink = deepLink.queryParametersAll['data']![0];
        final Map partnerDetails = jsonDecode(pagelink);

        final brandCode = partnerDetails['brandCode'];
        final merchantCode = partnerDetails['merchantCode'];
        bool isLogedIn =
            StorageManager.getBoolValue(AppStorageKey.isLogIn) ?? false;
        if (isLogedIn) {
          appRouter.pushNamed(
            '/partner_details_screen/$merchantCode/$brandCode/true',
          );
        } else {
          MoenageManager.logScreenEvent(name: 'Welcome');
          AutoRouter.of(context).pushAndPopUntil(
            WelcomeScreenRoute(),
            predicate: (_) => true,
          );
        }
      } else if (deepLink.query.contains('offerCode')) {
        pagelink = deepLink.query.split('=')[1];
        bool isLogedIn =
            StorageManager.getBoolValue(AppStorageKey.isLogIn) ?? false;
        if (isLogedIn) {
          appRouter.pushNamed(
              '/offer_detail_screen/${deepLink.query.split('=')[1]}/true');
        } else {
          MoenageManager.logScreenEvent(name: 'Welcome');
          AutoRouter.of(context).pushAndPopUntil(
            WelcomeScreenRoute(),
            predicate: (_) => true,
          );
        }
      } else if (deepLink.query.contains('open_barcode')) {
        pagelink = 'open_barcode';
        bool isLogedIn =
            StorageManager.getBoolValue(AppStorageKey.isLogIn) ?? false;
        if (isLogedIn) {
          StorageManager.setBoolValue(key: 'isBarcodeTapped', value: true);
          if (appRouter.currentPath == '/main_home_screen/true') {
            // if ((dashboardKey.currentContext?.mounted).toString() != 'null') {
            //   dashboardKey.currentState!.setState(() {
            //     dashboardKey.currentState?.isTapped = true;
            //   });
            // } else {
            appRouter.pushAndPopUntil(
              MainHomeScreenRoute(isFirstLoad: true, index: 0),
              predicate: (_) => true,
            );
            // }
          }
          appRouter.pushAndPopUntil(
            MainHomeScreenRoute(isFirstLoad: true, index: 0),
            predicate: (_) => true,
          );
        } else {
          MoenageManager.logScreenEvent(name: 'Welcome');
          AutoRouter.of(context).pushAndPopUntil(
            WelcomeScreenRoute(),
            predicate: (_) => true,
          );
        }
      } else if (deepLink.query.contains('route')) {
        pagelink = 'route';
        final String route = deepLink.query.split('=')[1];
        bool fromSplash = GlobalSingleton.fromSplash ?? false;
        appRouter.pushNamed(route + (fromSplash == false ? '/true' : '/false'));
      }
    });
    final PendingDynamicLinkData? data = await dynamicLinks.getInitialLink();

    final Uri? deepLink = data?.link;
    if (deepLink != null) {
      if (deepLink.query.contains("membership_no=")) {
        List<String> link = deepLink.query.split('=');
        if (link.length == 2) {
          GlobalSingleton.referralno = link[1];
        } else {
          GlobalSingleton.referralno = link[1].split('&').first;
        }
        if (deepLink.query.contains("store_code")) {
          GlobalSingleton.storeCode = link[2].split('&').first;
        }
        if (deepLink.query.contains("partner_id")) {
          GlobalSingleton.partnerId = link.last;
        }
      } else if (deepLink.query.contains("data")) {
        pagelink = deepLink.queryParametersAll['data']![0];
        final Map partnerDetails = jsonDecode(pagelink);

        final brandCode = partnerDetails['brandCode'];
        final merchantCode = partnerDetails['merchantCode'];
        bool isLogedIn =
            StorageManager.getBoolValue(AppStorageKey.isLogIn) ?? false;
        if (isLogedIn) {
          appRouter.pushNamed(
            '/partner_details_screen/$merchantCode/$brandCode/true',
          );
        } else {
          MoenageManager.logScreenEvent(name: 'Welcome');
          AutoRouter.of(context).pushAndPopUntil(
            WelcomeScreenRoute(),
            predicate: (_) => true,
          );
        }
      } else if (deepLink.query.contains('offerCode')) {
        pagelink = deepLink.query.split('=')[1];
        bool isLogedIn =
            StorageManager.getBoolValue(AppStorageKey.isLogIn) ?? false;
        if (isLogedIn) {
          appRouter.pushNamed(
              '/offer_detail_screen/${deepLink.query.split('=')[1]}/true');
        }
      } else if (deepLink.query.contains('open_barcode')) {
        pagelink = 'open_barcode';
        bool isLogedIn =
            StorageManager.getBoolValue(AppStorageKey.isLogIn) ?? false;
        if (isLogedIn) {
          StorageManager.setBoolValue(key: 'isBarcodeTapped', value: true);
          if (appRouter.currentPath == '/main_home_screen/true') {
            // if ((dashboardKey.currentContext?.mounted).toString() != 'null') {
            //   dashboardKey.currentState!.setState(() {
            //     dashboardKey.currentState?.isTapped = true;
            //   });
            // } else {
            appRouter.pushAndPopUntil(
              MainHomeScreenRoute(isFirstLoad: true, index: 0),
              predicate: (_) => true,
            );
            // }
          }
          appRouter.pushAndPopUntil(
            MainHomeScreenRoute(isFirstLoad: true, index: 0),
            predicate: (_) => true,
          );
        } else {
          MoenageManager.logScreenEvent(name: 'Welcome');
          AutoRouter.of(context).pushAndPopUntil(
            WelcomeScreenRoute(),
            predicate: (_) => true,
          );
        }
      } else if (deepLink.query.contains('route')) {
        pagelink = 'route';
        final String route = deepLink.query.split('=')[1];
        bool fromSplash = GlobalSingleton.fromSplash ?? false;
        appRouter.pushNamed(route + (fromSplash == false ? '/true' : '/false'));
      } else {
        MoenageManager.logScreenEvent(name: 'Welcome');
        AutoRouter.of(context).pushAndPopUntil(
          WelcomeScreenRoute(),
          predicate: (_) => true,
        );
      }
    }
    return pagelink;
  }
}
