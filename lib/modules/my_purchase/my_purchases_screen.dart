import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MyPurchasesScreen extends StatefulWidget {
  final bool fromSplash;
  const MyPurchasesScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  State<MyPurchasesScreen> createState() => _MyPurchasesScreenState();
}

class _MyPurchasesScreenState extends State<MyPurchasesScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
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
        body: AppBackGroundWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
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
                AppConstString.myPurchases.toUpperCase(),
                style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              GestureDetector(
                onTap: () {
                  MoenageManager.logScreenEvent(name: 'Purchased History');

                  AutoRouter.of(context).push(
                    PurchasedHistoryScreenRoute(),
                  );
                },
                child: Image.asset(
                  AppAssets.myPurchase2,
                  width: screenWidth,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              GestureDetector(
                onTap: () {
                  MoenageManager.logScreenEvent(name: 'My Travel ');
                  AutoRouter.of(context).push(
                    MyTravelScreenRoute(apiPath: ApiPath.travelPurchase),
                  );
                },
                child: Image.asset(
                  AppAssets.myPurchase1,
                  fit: BoxFit.cover,
                  width: screenWidth,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
