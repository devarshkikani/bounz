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
class RegistrationCompleteScreen extends StatefulWidget {
  final String spinValue;
  final bool isFromDashboard;
  const RegistrationCompleteScreen(
      {Key? key, required this.spinValue, required this.isFromDashboard})
      : super(key: key);

  @override
  _RegistrationCompleteScreenState createState() =>
      _RegistrationCompleteScreenState();
}

class _RegistrationCompleteScreenState
    extends State<RegistrationCompleteScreen> {
  @override
  void initState() {
    super.initState();
    if (!widget.isFromDashboard) {
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
          if (widget.isFromDashboard) {
            AutoRouter.of(context).pushAndPopUntil(
                MainHomeScreenRoute(isFirstLoad: false),
                predicate: (_) => false);
            return true;
          } else {
            return false;
          }
        },
        child: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                    child: Text(
                      widget.isFromDashboard
                          ? widget.spinValue
                          : widget.spinValue.toUpperCase(),
                      textAlign: TextAlign.center,
                      style:
                          AppTextStyle.regular40.copyWith(fontFamily: 'Bebas'),
                    ),
                  ),
                  Center(
                    child: Stack(
                      children: [
                        SizedBox(
                          width: 400.0,
                          child: Image.asset(
                            AppAssets.earnedBounz,
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.cover,
                          ),
                        ),
                        widget.isFromDashboard
                            ? Positioned.fill(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: PrimaryButton(
                                      height: AppSizes.size60,
                                      text: AppConstString.goHome,
                                      onTap: () {
                                        AutoRouter.of(context).pushAndPopUntil(
                                            MainHomeScreenRoute(
                                                isFirstLoad: false),
                                            predicate: (_) => false);
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
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
