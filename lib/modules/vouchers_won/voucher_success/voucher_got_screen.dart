import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';

@RoutePage()
class VoucherGotScreen extends StatefulWidget {
  final String spinValue;
  final bool fromSplash;
  final bool showVoucherButton;
  const VoucherGotScreen(
      {Key? key,
      required this.spinValue,
      required this.fromSplash,
      required this.showVoucherButton})
      : super(key: key);

  @override
  _VoucherGotScreenState createState() => _VoucherGotScreenState();
}

class _VoucherGotScreenState extends State<VoucherGotScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.fromSplash) {
      Future.delayed(const Duration(seconds: 4), () {
        MoenageManager.logScreenEvent(name: 'Main Home');
        AutoRouter.of(context).pushAndPopUntil(
            MainHomeScreenRoute(isFirstLoad: true),
            predicate: (_) => false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldOrangeColor,
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  /* Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                    child: Text(AppConstString.congratulationsMsg,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.regular26.copyWith(fontFamily: 'Bebas'),
                    ),
                  ),*/
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                    child: Text(
                      widget.spinValue.toUpperCase(),
                      textAlign: TextAlign.center,
                      style:
                          AppTextStyle.regular40.copyWith(fontFamily: 'Bebas'),
                    ),
                  ),
                  Center(
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 380.0,
                          child: Image.asset(
                            AppAssets.earnedBounz,
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.cover,
                          ),
                        ),
                        widget.fromSplash
                            ? const SizedBox()
                            : Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      if (widget.showVoucherButton == true)
                                        PrimaryButton(
                                          height: AppSizes.size60,
                                          text: AppConstString.myVouchers,
                                          onTap: () {
                                            MoenageManager.logScreenEvent(
                                                name: 'Vouchers history');

                                            AutoRouter.of(context).push(
                                              VoucherWonHistoryScreenRoute(),
                                            );
                                          },
                                        ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      PrimaryButton(
                                        height: AppSizes.size60,
                                        text: AppConstString.goHome,
                                        onTap: () {
                                          AutoRouter.of(context)
                                              .pushAndPopUntil(
                                                  MainHomeScreenRoute(
                                                      isFirstLoad: false),
                                                  predicate: (_) => false);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
