import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:moengage_flutter/model/app_status.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class ForceUpdateScreen extends StatefulWidget {
  final bool canSkip;
  final bool fromSplash;
  const ForceUpdateScreen(
      {Key? key,
      @PathParam('fromSplash') this.fromSplash = false,
      @PathParam('canSkip') required this.canSkip})
      : super(key: key);

  @override
  _ForceUpdate createState() => _ForceUpdate();
}

class _ForceUpdate extends State<ForceUpdateScreen> {
  @override
  void initState() {
    MoenageManager.moengagePlugin.setAppStatus(MoEAppStatus.update);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: AppBackGroundWidget(
            padding: EdgeInsets.zero,
            child: updateBody(),
          ),
        ));
  }

  Widget updateBody() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 40,
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 1.5,
                child: Image.asset(
                  AppAssets.forceUpdate,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Text(
                AppConstString.newExpAwait,
                style: AppTextStyle.semiBold26
                    .copyWith(color: AppColors.whiteColor.withOpacity(0.9)),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                AppConstString.forceUpdateDesc,
                style: AppTextStyle.semiBold20
                    .copyWith(color: AppColors.whiteColor.withOpacity(0.9)),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                height: 60,
                child: PrimaryButton(
                  height: AppSizes.size60,
                  text: AppConstString.updateNow,
                  onTap: () {
                    final properties = MoEProperties();
                    properties.addAttribute(
                        TriggeringCondition.forceUpdate, true);

                    MoenageManager.logEvent(
                      MoenageEvent.forceUpdate,
                      properties: properties,
                    );
                    if (Platform.isAndroid) {
                      _launchURL(
                          "https://play.google.com/store/apps/details?id=com.citypoints.bounzrewards");
                    } else {
                      _launchURL(
                          "https://apps.apple.com/us/app/bounz-rewards/id1573809550");
                    }
                  },
                ),
              ),
              widget.canSkip == false
                  ? InkWell(
                      onTap: () async {
                        final properties = MoEProperties();
                        properties.addAttribute(
                            TriggeringCondition.forceSkip, true);

                        MoenageManager.logEvent(
                          MoenageEvent.forceSkip,
                          properties: properties,
                        );
                        Navigator.of(context).pop('skip');
                      },
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              AppConstString.skip,
                              style: AppTextStyle.regular14.copyWith(
                                  color: AppColors.blackColor.withOpacity(0.9)),
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Container(
                              alignment: Alignment.center,
                              height: 18,
                              width: 18,
                              decoration: const BoxDecoration(
                                  color: AppColors.blackColor,
                                  shape: BoxShape.circle),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 15,
                                color: AppColors.whiteColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(
                      height: 0,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
