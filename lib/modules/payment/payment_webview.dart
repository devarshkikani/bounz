// import 'dart:math';

import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/utils/progress_indicator.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';

@RoutePage()
class PaymentWebviewScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final int index;
  final String amount;
  const PaymentWebviewScreen({
    Key? key,
    required this.amount,
    required this.index,
    required this.data,
  }) : super(key: key);

  @override
  State<PaymentWebviewScreen> createState() => _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends State<PaymentWebviewScreen> {
  int progress = 0;

  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              this.progress = progress;
            });
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            if (url.contains('/ccavResponseHandler')) {
              if (widget.index == 2) {
                updatePBTransaction(context);
              } else {
                updateGVTransaction(context);
              }
            }
          },
          onWebResourceError: (WebResourceError error) {},
        ),
      )
      ..loadRequest(
        Uri.parse(widget.data['url']),
      );
  }

  Future updatePBTransaction(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.dtOneEndPoint + ApiPath.updatePBTransaction,
      context: context,
      forceReturn: true,
      data: {
        'transactions_id': widget.data['transaction_id'],
      },
    );
    if (response != null) {
      if (response['status'] == true) {
        getProfileData(
          context,
          response['values']['total_earn_point'].toString(),
          response['values'],
        );
      } else {
        MoenageManager.logScreenEvent(name: 'Payment Failed');
        final properties = MoEProperties();
        properties
            .addAttribute(TriggeringCondition.paymentType,
                widget.index == 2 ? 'Pay Bills' : 'Gift Voucher')
            .addAttribute(TriggeringCondition.amount, widget.amount.toString())
            .setNonInteractiveEvent();
        MoenageManager.logEvent(
          MoenageEvent.paymentFailed,
          properties: properties,
        );

        AutoRouter.of(context).popAndPush(
          PaymentFailedScreenRoute(
              pageIndex: widget.index, reason: response['message']),
        );
      }
    } else {
      MoenageManager.logScreenEvent(name: 'Payment Failed');
      final properties = MoEProperties();
      properties
          .addAttribute(TriggeringCondition.paymentType,
              widget.index == 2 ? 'Pay Bills' : 'Gift Voucher')
          .addAttribute(TriggeringCondition.amount, widget.amount.toString())
          .setNonInteractiveEvent();
      MoenageManager.logEvent(
        MoenageEvent.paymentFailed,
        properties: properties,
      );

      AutoRouter.of(context).popAndPush(
        PaymentFailedScreenRoute(
          pageIndex: widget.index,
        ),
      );
    }
  }

  Future updateGVTransaction(BuildContext context) async {
    Map<String, dynamic>? response =
        await NetworkDio.postGiftVoucherDioHttpMethod(
      url: ApiPath.giftCardEndPoint + ApiPath.updateGVTransaction,
      notShowError: true,
      context: context,
      data: {
        'transaction_id': widget.data['transaction_id'],
      },
    );
    if (response != null) {
      if (response['status'] == true || response['code'] == 'trnx_0010') {
        getProfileData(context, response['earn_points'].toString(), null);
      } else {
        MoenageManager.logScreenEvent(name: 'Payment Failed');
        final properties = MoEProperties();
        properties
            .addAttribute(TriggeringCondition.paymentType,
                widget.index == 2 ? 'Pay Bills' : 'Gift Voucher')
            .addAttribute(TriggeringCondition.amount, widget.amount.toString())
            .setNonInteractiveEvent();
        MoenageManager.logEvent(
          MoenageEvent.paymentFailed,
          properties: properties,
        );

        AutoRouter.of(context).popAndPush(
          PaymentFailedScreenRoute(
            pageIndex: widget.index,
          ),
        );
      }
    } else {
      MoenageManager.logScreenEvent(name: 'Payment Failed');
      final properties = MoEProperties();
      properties
          .addAttribute(TriggeringCondition.paymentType,
              widget.index == 2 ? 'Pay Bills' : 'Gift Voucher')
          .addAttribute(TriggeringCondition.amount, widget.amount.toString())
          .setNonInteractiveEvent();
      MoenageManager.logEvent(
        MoenageEvent.paymentFailed,
        properties: properties,
      );

      AutoRouter.of(context).popAndPush(
        PaymentFailedScreenRoute(
          pageIndex: widget.index,
        ),
      );
    }
  }

  Future getProfileData(
      BuildContext context, String points, fixedValueData) async {
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.getProfile,
      context: context,
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
      MoenageManager.logScreenEvent(name: 'Payment Successful');
      final properties = MoEProperties();
      properties
          .addAttribute(
              TriggeringCondition.transactionId, widget.data['transaction_id'])
          .addAttribute(TriggeringCondition.paymentMethod, 'Credit/Debit')
          .addAttribute(TriggeringCondition.amount, widget.amount.toString())
          .addAttribute(TriggeringCondition.purchaseItem,
              widget.index == 2 ? 'Pay Bills' : 'Gift Voucher')
          .setNonInteractiveEvent();
      MoenageManager.logEvent(
        MoenageEvent.purchase,
        properties: properties,
      );
      AutoRouter.of(context).popAndPush(
        PaymentSuccessfulRoute(
            totalPoints: points,
            pageIndex: widget.index,
            fixedValueData: fixedValueData),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AppBackGroundWidget(
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Container(
              color: AppColors.whiteColor,
            ),
            if (progress < 100)
              const Center(
                child: ProcessIndicator(),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(
                      left: AppSizes.size20,
                      top: AppSizes.size20,
                    ),
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.blackColor,
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                Expanded(
                  child: WebViewWidget(
                    controller: controller,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
