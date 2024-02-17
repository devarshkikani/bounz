import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../config/routes/router_import.gr.dart';
import '../auth/login/login_registration_presenter.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/widgets/exit_bottomsheet.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';

@RoutePage()
class WelcomeScreen extends StatefulWidget {
  final bool fromSplash;
  const WelcomeScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: AppBackGroundWidget(
          padding: EdgeInsets.zero,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  AppAssets.onBoarding,
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSizes.size30),
              ),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: AppSizes.size30,
                    left: AppSizes.size26,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset(AppAssets.bounzWithLetter),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      Text(
                        AppConstString.makeItCount,
                        style: AppTextStyle.regular36
                            .copyWith(fontFamily: 'Bebas'),
                      ),
                      Text(
                        AppConstString.letsBounz,
                        style: AppTextStyle.regular60
                            .copyWith(fontFamily: 'Bebas'),
                      ),
                      const SizedBox(
                        height: AppSizes.size12,
                      ),
                      lineWidget(),
                    ],
                  ),
                ),
                Positioned(
                  bottom: AppSizes.size50,
                  child: GestureDetector(
                    onTap: () {
                      MoenageManager.logScreenEvent(name: 'Login Registration');

                      AutoRouter.of(context).push(
                        LoginRegistrationScreenRoute(
                          presenter: BasicLoginRegistrationPresenter(),
                        ),
                      );
                    },
                    child: Container(
                      height: AppSizes.size60,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.size40),
                      decoration: const BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(AppSizes.size30),
                          bottomRight: Radius.circular(AppSizes.size30),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            AppConstString.loginRegister,
                            style: AppTextStyle.bold14,
                          ),
                          const SizedBox(
                            width: AppSizes.size10,
                          ),
                          Image.asset(AppAssets.arrowRightAndroid)
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() async {
    return await exitBottomSheet(context) ?? false;
  }
}

Widget lineWidget() {
  return Row(
    children: [
      Container(
        color: AppColors.whiteColor,
        height: 1,
        width: AppSizes.size30,
      ),
      const SizedBox(
        width: 10.0,
      ),
      Container(
        color: AppColors.whiteColor,
        height: 1,
        width: AppSizes.size30,
      ),
      const SizedBox(
        width: 10.0,
      ),
      Container(
        color: AppColors.whiteColor,
        height: 2,
        width: AppSizes.size30,
      )
    ],
  );
}
