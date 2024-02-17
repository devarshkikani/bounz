import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ProfileCreatedScreen extends StatefulWidget {
  final bool isReffer;
  const ProfileCreatedScreen({Key? key, required this.isReffer})
      : super(key: key);

  @override
  _ProfileCreatedScreenState createState() => _ProfileCreatedScreenState();
}

class _ProfileCreatedScreenState extends State<ProfileCreatedScreen> {
  String? referralCode;

  @override
  void initState() {
    super.initState();
    getReferralCode();
  }

  void getReferralCode() async {
    setState(() {
      referralCode = StorageManager.getStringValue(AppStorageKey.isFilled);
    });
  }

  void redirectToNextPage() {
    if (referralCode!.isNotEmpty &&
        referralCode == GlobalSingleton.referralno) {
      MoenageManager.logScreenEvent(name: 'Reffral Bouns');
      AutoRouter.of(context).push(
        const ReffralBounsScreenRoute(),
      );
    } else {
      MoenageManager.logScreenEvent(name: 'Spin The Wheel');
      AutoRouter.of(context)
          .pushNamed("/spin_the_wheel_screen/type/register/true");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: AppBackGroundWidget(
          padding: EdgeInsets.zero,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset(
                AppAssets.onBoardingCompleted,
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 1.55,
                fit: BoxFit.fill,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: AppSizes.size30,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                    child: Text(
                      AppConstString.kudos,
                      style: AppTextStyle.regular60.copyWith(
                        fontFamily: 'Bebas',
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size8,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                    child: Text(
                      AppConstString.profileCreated,
                      style:
                          AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: nextButtonWidget(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget nextButtonWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.size30),
      child: PrimaryButton(
        onTap: () {
          redirectToNextPage();
        },
        showShadow: true,
        text: AppConstString.next,
      ),
    );
  }
}
