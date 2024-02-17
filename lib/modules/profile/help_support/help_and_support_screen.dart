import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/help_support/help_and_support.dart';
import 'package:bounz_revamp_app/modules/profile/help_support/help_and_support_model.dart';
import 'package:bounz_revamp_app/modules/profile/help_support/help_and_support_presenter.dart';
import 'package:bounz_revamp_app/modules/profile/help_support/help_and_support_view.dart';
import 'package:bounz_revamp_app/modules/profile/my_profile/customer_care_bottomsheet_widget.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class HelpSupportScreen extends StatefulWidget {
  final bool fromSplash;
  const HelpSupportScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen>
    implements HelpSupportView {
  HelpSupportPresenter presenter = BasicHelpSupportViewPresenter();
  late HelpSupportModelView model;

  @override
  initState() {
    super.initState();
    presenter.updateView = this;

    final String? encodeString =
        StorageManager.getStringValue(AppStorageKey.helpSupportData);

    if (encodeString != null) {
      GlobalSingleton.helpSupportData =
          HelpSupportModel.fromJson(jsonDecode(encodeString));
    }

    if (GlobalSingleton.helpSupportData != null) {
      model.helpSupportModel = GlobalSingleton.helpSupportData!;
    } else {
      presenter.getHelpSupportData(context);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromSplash) {
          MoenageManager.logScreenEvent(name: 'Main Home');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(isFirstLoad: true, index: 4),
              predicate: (_) => false);
        } else {
          AutoRouter.of(context).canPop();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: AppBackGroundWidget(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    if (widget.fromSplash) {
                      MoenageManager.logScreenEvent(name: 'Main Home');
                      AutoRouter.of(context).pushAndPopUntil(
                          MainHomeScreenRoute(
                            isFirstLoad: true,
                          ),
                          predicate: (_) => false);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(
                  height: AppSizes.size30,
                ),
                Text(
                  AppConstString.helpNSupport,
                  style: AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
                ),
                const SizedBox(
                  height: AppSizes.size26,
                ),
                Text(
                  AppConstString.howCanWeHelpYou,
                  style: AppTextStyle.semiBold14,
                ),
                const SizedBox(
                  height: AppSizes.size24,
                ),
                SizedBox(
                  height: AppSizes.size60,
                  child: ElevatedButton(
                    onPressed: () {
                      MoenageManager.logScreenEvent(name: 'Faq');

                      AutoRouter.of(context).push(
                        FaqRoute(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide.none,
                      ),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          AppAssets.faq,
                        ),
                        const SizedBox(
                          width: AppSizes.size14,
                        ),
                        Text(
                          AppConstString.faqText,
                          style: AppTextStyle.semiBold16.copyWith(
                              color: AppColors.whiteColor.withOpacity(0.9)),
                        ),
                        const Spacer(),
                        const Icon(
                          Icons.keyboard_arrow_right_rounded,
                          size: 22.0,
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSizes.size26,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              final properties = MoEProperties();
                              properties
                                  .addAttribute(
                                      TriggeringCondition.helpType, 'customer')
                                  .addAttribute(TriggeringCondition.screenName,
                                      'Help And Support')
                                  .setNonInteractiveEvent();
                              MoenageManager.logEvent(
                                MoenageEvent.helpSupport,
                                properties: properties,
                              );
                              customerCareBottomsheet(
                                context,
                                model.helpSupportModel?.data?.contactNo ?? "",
                              );
                            },
                            child: Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainerColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: AppSizes.size10,
                                  ),
                                  SvgPicture.asset(
                                    AppAssets.customerCare,
                                  ),
                                  const SizedBox(
                                    height: AppSizes.size8,
                                  ),
                                  Text(
                                    model.helpSupportModel?.data?.timing ?? "",
                                    style: AppTextStyle.semiBold12,
                                  ),
                                  const SizedBox(
                                    height: AppSizes.size8,
                                  ),
                                  Text(
                                    model.helpSupportModel?.data?.days ?? "",
                                    style: AppTextStyle.semiBold12,
                                  ),
                                  const SizedBox(
                                    height: AppSizes.size8,
                                  ),
                                  Text(
                                    model.helpSupportModel?.data?.contactNo ??
                                        "",
                                    style: AppTextStyle.semiBold12,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: AppSizes.size8,
                          ),
                          Text(
                            AppConstString.customerCare4,
                            style: AppTextStyle.semiBold12,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: AppSizes.size10,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final properties = MoEProperties();
                              properties
                                  .addAttribute(
                                      TriggeringCondition.helpType, 'email')
                                  .addAttribute(TriggeringCondition.screenName,
                                      'Help And Support')
                                  .setNonInteractiveEvent();
                              MoenageManager.logEvent(
                                MoenageEvent.helpSupport,
                                properties: properties,
                              );
                              final Uri url = Uri(
                                scheme: 'mailto',
                                path: 'support@bounz.ae',
                                queryParameters: {
                                  'subject': 'Contact\tUs',
                                  'body': 'Please\tleave\tthe\tinformation\tbelow\tso\twe\tcan\tbetter\tassist\tyou:\n\n\n\n\n\n\n\n\n\n\n'
                                      'Android\tversion:'
                                      '\nApp\tversion:\t${GlobalSingleton.appVersion}\n',
                                },
                              );

                              if (await canLaunchUrl(url)) {
                                await launchUrl(url);
                              }
                            },
                            child: Container(
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainerColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      top: 10.0,
                                    ),
                                    child: SvgPicture.asset(
                                      AppAssets.mail,
                                      height: 55.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: AppSizes.size8,
                                  ),
                                  Text(
                                    AppConstString.emailUs1,
                                    style: AppTextStyle.semiBold12,
                                  ),
                                  const SizedBox(
                                    height: AppSizes.size8,
                                  ),
                                  Text(
                                    model.helpSupportModel?.data?.email ?? "",
                                    style: AppTextStyle.semiBold12,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: AppSizes.size8,
                          ),
                          Text(AppConstString.emailUs3,
                              style: AppTextStyle.semiBold12),
                        ],
                      ),
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

  @override
  void refreshModel(HelpSupportModelView helpSupportModelView) {
    if(mounted) {
      setState(() {
      model = helpSupportModelView;
    });
    }
  }
}
