import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:share_plus/share_plus.dart';

import '../../config/manager/global_singleton.dart';
import '../../config/routes/router_import.gr.dart';
import '../../services/dynamiclinks.dart';

@RoutePage()
class ReferEarnScreen extends StatefulWidget {
  final bool fromSplash;
  const ReferEarnScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen> {
  String referalLink = '';
  bool sharetapped = false;

  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Future getDynamicLink() async {
    referalLink =
        await FirebaseDynamicLinkService().createReferandEarnDynamicLink();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getDynamicLink();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: GestureDetector(
        onTap: () {
          if (_focusNode.hasFocus) {
            _focusNode.unfocus();
          }
        },
        child: AppBackGroundWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.fromSplash) {
                    MoenageManager.logScreenEvent(name: 'Main Home');
                    AutoRouter.of(context).pushAndPopUntil(
                        MainHomeScreenRoute(isFirstLoad: true, index: 0),
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
                AppConstString.referNEarn,
                style: AppTextStyle.regular36.copyWith(
                  fontFamily: 'Bebas',
                ),
              ),
              const SizedBox(
                height: AppSizes.size12,
              ),
              Text(
                AppConstString.referralCode,
                style: AppTextStyle.semiBold12,
              ),
              const SizedBox(
                height: AppSizes.size12,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.whiteColor),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        referalLink,
                        // AppConstString.linkText,
                        style: AppTextStyle.bold14,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: AppSizes.size14,
                  ),
                  Container(
                    height: 40.0,
                    width: 40.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.circleGradient,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            if (referalLink != '' && sharetapped == false) {
                              setState(() {
                                sharetapped == true;
                              });
                              final properties = MoEProperties();
                              properties
                                  .addAttribute(
                                    TriggeringCondition.referCode,
                                    GlobalSingleton
                                        .userInformation.referralCode,
                                  )
                                  .addAttribute(TriggeringCondition.screenName,
                                      'ReferAndEarn')
                                  .setNonInteractiveEvent();
                              MoenageManager.logEvent(
                                MoenageEvent.referralShared,
                                properties: properties,
                              );

                              Share.share(
                                  '''Hey, there is a new currency in town! 
Use my code ${GlobalSingleton.userInformation.referralCode} during registration and get 100 BOUNZ on becoming a BOUNZ member. 
Download the app here: ''' +
                                      referalLink);
                            }
                          },
                          child: SvgPicture.asset(
                            AppAssets.share,
                            height: 30.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              Expanded(
                child: Image.asset(
                  AppAssets.refer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//use this container after image remove
  Widget referContainer() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.size10),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainerColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        children: [
          Image.asset(AppAssets.referAndEarnCotnImage),
          const SizedBox(
            width: AppSizes.size30,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstString.youBothEarn,
                style: AppTextStyle.regular14,
              ),
              Text(
                AppConstString.bounz100,
                style: AppTextStyle.bold20,
              )
            ],
          )
        ],
      ),
    );
  }
}
