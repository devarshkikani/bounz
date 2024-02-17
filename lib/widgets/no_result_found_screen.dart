import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';

@RoutePage()
class NoResultFoundScreen extends StatefulWidget {
  const NoResultFoundScreen({Key? key}) : super(key: key);

  @override
  State<NoResultFoundScreen> createState() => _NoResultFoundScreenState();
}

class _NoResultFoundScreenState extends State<NoResultFoundScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AppBackGroundWidget(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 26.0,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 20,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size30,
                  ),
                  Text(
                    "OOps!",
                    style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
                  ),
                  const SizedBox(
                    height: AppSizes.size14,
                  ),
                  Text(
                    "No Results Found!",
                    textAlign: TextAlign.center,
                    style: AppTextStyle.bold16,
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.size50,
              ),
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Image.asset(
                      AppAssets.searchIcon,
                      height: 120.0,
                      width: 150.0,
                    ),
                    const SizedBox(
                      height: AppSizes.size30,
                    ),
                    Text(
                      "Sorry, that filter combination has no\nresults. Please try different criteria.",
                      textAlign: TextAlign.center,
                      style: AppTextStyle.bold16,
                    ),
                    const SizedBox(
                      height: AppSizes.size50,
                    ),
                    RoundedBorderButton(
                      tColor: AppColors.blackColor,
                      bColor: AppColors.blackColor,
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      text: "Go Back",
                    ),
                    const SizedBox(
                      height: AppSizes.size10,
                    ),
                    PrimaryButton(
                      tColor: AppColors.whiteColor,
                      bColor: AppColors.btnBlueColor,
                      onTap: () {
                        MoenageManager.logScreenEvent(name: 'No Internet');

                        AutoRouter.of(context)
                            .push(const NoInternetScreenRoute());
                      },
                      text: "Home",
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
