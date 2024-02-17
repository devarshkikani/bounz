import 'dart:io';

import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:moengage_flutter/properties.dart';

import '../constants/app_const_text.dart';
import '../utils/network/network_dio.dart';

@RoutePage()
class NoInternetScreen extends StatefulWidget {
  const NoInternetScreen({Key? key}) : super(key: key);

  @override
  State<NoInternetScreen> createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  void initState() {
    super.initState();
    final properties = MoEProperties();
    MoenageManager.logEvent(
      MoenageEvent.noInternet,
      properties: properties,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        AutoRouter.of(context).pushAndPopUntil(
          MainHomeScreenRoute(isFirstLoad: false),
          predicate: (_) => false,
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: AppBackGroundWidget(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: AppSizes.size30,
                    ),
                    Text(
                      "No Connection",
                      style:
                          AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.size58,
                ),
                Column(
                  children: [
                    Image.asset(
                      AppAssets.electricSocketIcon,
                      height: 120.0,
                      width: 150.0,
                    ),
                    const SizedBox(
                      height: AppSizes.size40,
                    ),
                    Text(
                      "No internet connection found. Check your connection or try again.",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bold16,
                    ),
                    const SizedBox(
                      height: AppSizes.size60,
                    ),
                    PrimaryButton(
                      tColor: AppColors.whiteColor,
                      bColor: AppColors.btnBlueColor,
                      onTap: () async {
                        try {
                          final result = await InternetAddress.lookup('example.com');
                          if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
                            AutoRouter.of(context).push(
                              MainHomeScreenRoute(
                                isFirstLoad: false,
                              ),

                            );
                          }
                        } on SocketException catch (_) {
                          NetworkDio.showError(title: AppConstString.noInternet, errorMessage: AppConstString.internetError,context: context);
                        }
                      },
                      text: "Home",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
