// ignore_for_file: avoid_print

import 'dart:developer';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/utils/progress_indicator.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:spike_flutter_sdk/spike_flutter_sdk.dart';
import 'package:bounz_revamp_app/services/print_logger.dart';

@RoutePage()
class ExternalLinkScreen extends StatefulWidget {
  final bool fromSplash;

  const ExternalLinkScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  State<ExternalLinkScreen> createState() => _ExternalLinkState();
}

class _ExternalLinkState extends State<ExternalLinkScreen> {
  late WebViewController controller;
  bool _isLoading = true;
  String navLink = "";
  String provider = "";

  @override
  void initState() {
    super.initState();
    navLink = StorageManager.getStringValue(AppStorageKey.navLink) ?? "";
    // WidgetsBinding.instance.addObserver(this);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setUserAgent('random')
      ..setNavigationDelegate(
        NavigationDelegate(
          onUrlChange: (change) {
            String url = change.url.toString();
            if (url.contains(
                "https://wearables.bounzrewards.com/delink?membership_no")) {
              StorageManager.setBoolValue(
                key: AppStorageKey.healthConnected,
                value: false,
              );
            }
          },
          onNavigationRequest: (request) async {
            if (request.url.contains(
                    'https://api.spikeapi.com/init-user-integration/?provider=apple&user_id=') ||
                request.url.contains(
                    'https://api.spikeapi.com/init-user-integration/?provider=health_connect&user_id=')) {
              PermissionStatus status =
                  await Permission.activityRecognition.status;
              if (status != PermissionStatus.granted &&
                  status != PermissionStatus.limited) {
                await Permission.activityRecognition.request();
              }
              await initalizeStrike(context, request.url);
              return NavigationDecision.prevent;
            } else {
              return NavigationDecision.navigate;
            }
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(
        Uri.parse(navLink),
      );
    checkIfError();
  }

  void checkIfError() {
    if (navLink
        .contains("https://wearables.bounzrewards.com/?membership_no=")) {
      bool isConnected =
          StorageManager.getBoolValue(AppStorageKey.healthConnected) ?? false;
      if (isConnected) {
        if (GlobalSingleton.spikeErrorMessage != null) {
          Map? message =
              errorMessage(GlobalSingleton.spikeErrorMessage.toString());
          if (message != null) {
            GlobalSingleton.spikeErrorMessage = null;
            Future.delayed(Duration.zero, () {
              NetworkDio.showError(
                  title: message['title'],
                  errorMessage: message['message'],
                  context: context);
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromSplash) {
          MoenageManager.logScreenEvent(name: 'Main Home');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(isFirstLoad: true, index: 0),
              predicate: (_) => false);
        } else {
          AutoRouter.of(context).canPop();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: AppBackGroundWidget(
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              if (_isLoading)
                const Center(
                  child: ProcessIndicator(),
                ),
              WebViewWidget(
                controller: controller,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: AppSizes.size20, top: AppSizes.size20),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> initalizeStrike(context, url) async {
    final connection = await SpikeSDK.createConnection(
      authToken: GlobalSingleton.authToken,
      appId: GlobalSingleton.appId,
      customerEndUserId:
          GlobalSingleton.userInformation.membershipNo.toString(),
      postbackURL: GlobalSingleton.postbackURL + 'webhook',
      logger: const PrintLogger(),
    );
    try {
      bool permission = await connection.ensurePermissionsAreGranted(types: [
        SpikeDataType.activitiesStream,
        SpikeDataType.activitiesSummary,
        SpikeDataType.heart,
        SpikeDataType.body,
        SpikeDataType.calories,
        SpikeDataType.breathing,
        SpikeDataType.calories,
        SpikeDataType.distance,
        SpikeDataType.oxygenSaturation,
        SpikeDataType.sleep,
        SpikeDataType.steps
      ]);
      if (Platform.isIOS) {
        await connection.enableBackgroundDelivery([
          SpikeDataType.activitiesStream,
          SpikeDataType.activitiesSummary,
          SpikeDataType.heart,
          SpikeDataType.body,
          SpikeDataType.calories,
          SpikeDataType.breathing,
          SpikeDataType.calories,
          SpikeDataType.distance,
          SpikeDataType.oxygenSaturation,
          SpikeDataType.sleep,
          SpikeDataType.steps
        ]);
      }
      for (var i = 0; i < 7; i++) {
        final fromDate = DateTime.now().subtract(Duration(days: i));
        await connection.extractAndPostData(
          SpikeDataType.activitiesStream,
          from: fromDate,
          to: fromDate,
        );
        await connection.extractAndPostData(
          SpikeDataType.activitiesSummary,
          from: fromDate,
          to: fromDate,
        );
        await connection.extractAndPostData(
          SpikeDataType.steps,
          from: fromDate,
          to: fromDate,
        );
      }
      String spikeUserId = await connection.getSpikeEndUserId();
      String thatUrl =
          "${GlobalSingleton.postbackURL}link_device?user_id=$spikeUserId&provider=${url.split('provider=').last.split('&').first}&customer_user_id=${GlobalSingleton.userInformation.membershipNo}";
      if (permission) {
        StorageManager.setStringValue(
          key: AppStorageKey.navLink,
          value: thatUrl,
        );
        StorageManager.setBoolValue(
            key: AppStorageKey.healthConnected, value: true);
        StorageManager.setStringValue(
            key: AppStorageKey.lastSyncData, value: DateTime.now().toString());
        debugPrint('permission :: $thatUrl');
        connection.close();
        navLink = thatUrl;
        controller.loadRequest(Uri.parse(navLink));
      }
    } on SpikeException catch (e) {
      Map? message = errorMessage(e.message.toString());
      if (message != null) {
        NetworkDio.showError(
            title: message['title'],
            errorMessage: message['message'],
            context: context);
      }
      if (e.message!.contains('permissions are not granted')) {
        Future.delayed(const Duration(seconds: 3), () {
          connection.manageHealthConnect();
        });
      }
    }
  }

  Map? errorMessage(String message) {
    String provider = Platform.isAndroid ? 'Health Connect' : 'Apple Health';

    if (message.contains('Service not available') ||
        message.contains('Error while checking permissions')) {
      return {
        'title':
            'This requires the $provider app which you have not installed.',
        'message':
            'Please install the $provider app on your phone to link with $provider.'
      };
    } else if (message.contains('permissions are not granted')) {
      return {
        'title': '$provider Permissions Required.',
        'message':
            'Please grant the necessary permissions in the $provider app.'
      };
    } else {
      log(message);
      return null;
    }
  }
}
