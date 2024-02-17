import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';

@RoutePage()
class MyInterestPreferencesUpdatedScreen extends StatefulWidget {
  const MyInterestPreferencesUpdatedScreen({super.key});

  @override
  State<MyInterestPreferencesUpdatedScreen> createState() =>
      _MyInterestPreferencesUpdatedScreenState();
}

class _MyInterestPreferencesUpdatedScreenState
    extends State<MyInterestPreferencesUpdatedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
              height: AppSizes.size30,
            ),
            Text(
              AppConstString.interestPreferencesUpdated.toUpperCase(),
              style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
            ),
            const SizedBox(
              height: AppSizes.size20,
            ),
            Text(
              AppConstString.interestPreferencesSaved,
              style: AppTextStyle.semiBold14,
            ),
            const SizedBox(
              height: AppSizes.size70,
            ),
            yellowRightIconGif(),
            const SizedBox(
              height: AppSizes.size30,
            ),
            const Spacer(),
            accountButtonWidget(),
          ],
        ),
      ),
    );
  }

  yellowRightIconGif() {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        height: 200,
        child: Lottie.asset(AppAssets.yellowRight),
      ),
    );
  }

  accountButtonWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          bottom: AppSizes.size30,
        ),
        child: PrimaryButton(
          showShadow: true,
          bColor: AppColors.btnBlueColor,
          text: "Home",
          onTap: () {
            MoenageManager.logScreenEvent(name: 'Main Home');

            AutoRouter.of(context).pushAndPopUntil(
                MainHomeScreenRoute(index: 4),
                predicate: (_) => false);
          },
        ),
      ),
    );
  }
}
