import 'package:flutter_html/flutter_html.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';

@RoutePage()
class UserGoingStoreScreen extends StatefulWidget {
  final String merchantCode;
  final int outletId;
  final String title;
  final String termCondition;
  const UserGoingStoreScreen({
    Key? key,
    required this.merchantCode,
    required this.outletId,
    required this.title,
    required this.termCondition,
  }) : super(key: key);

  @override
  State<UserGoingStoreScreen> createState() => _UserGoingStoreScreenState();
}

class _UserGoingStoreScreenState extends State<UserGoingStoreScreen> {
  Future<void> continueButtonClick({
    required BuildContext context,
  }) async {
    Map<String, dynamic> reqbody = {
      'membership_no': GlobalSingleton.userInformation.membershipNo,
      'merchant_code': widget.merchantCode,
      'outlet_id': widget.outletId,
      'type': 'visit',
      'lat': GlobalSingleton.currentPosition!.latitude,
      'long': GlobalSingleton.currentPosition!.longitude
    };

    Map<String, dynamic>? response = await NetworkDio.postPartnerNetworkDio(
      url: ApiPath.earn,
      context: context,
      data: reqbody,
    );
    if (response != null) {
      if (response['status'] == true) {
        if (response["data"]["values"]["earned"] != null) {
          MoenageManager.logScreenEvent(name: 'Bounz Received');
          AutoRouter.of(context).push(
            BounzReceivedScreenRoute(
                earned: response["data"]["values"]["earned"]),
          );
        } else {
          NetworkDio.showWarning(
            message: response['message'],
            context: context,
          );
        }
      } else {
        if (response['message'] ==
            'You should be in 100 Meter radius of store location to earn BOUNZ') {
          MoenageManager.logScreenEvent(name: 'User Far From Stores');
          AutoRouter.of(context).push(
            UserFarFromStoreScreenRoute(
              title: widget.title,
            ),
          );
        } else if (response['message'] ==
            'Bonus BOUNZ can only be collected on first visit to the store.') {
          MoenageManager.logScreenEvent(name: 'Bounz Alreday Earned');
          AutoRouter.of(context).push(const BounzAlreadyEarnedRoute());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundColor,
        child: AppBackGroundWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back,
                  color: AppColors.whiteColor,
                ),
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              Text(
                widget.title,
                style: AppTextStyle.regular36.copyWith(
                  fontFamily: "Bebas",
                ),
              ),
              Html(
                data: widget.termCondition,
              ),
              const SizedBox(
                height: AppSizes.size10,
              ),
              const Spacer(),
              Center(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Lottie.asset(
                      height: MediaQuery.of(context).size.height * 0.356,
                      AppAssets.earnBounzStoreVisit,
                      repeat: false,
                    ),
                    Positioned(
                      bottom: AppSizes.size30,
                      child: PrimaryButton(
                        height: MediaQuery.of(context).size.height * 0.065,
                        text: AppConstString.continueButton,
                        onTap: () {
                          continueButtonClick(
                            context: context,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
