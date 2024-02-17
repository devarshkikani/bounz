import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class ReffralBounsScreen extends StatefulWidget {
  const ReffralBounsScreen({Key? key}) : super(key: key);

  @override
  _ReffralBounsScreenState createState() => _ReffralBounsScreenState();
}

class _ReffralBounsScreenState extends State<ReffralBounsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        padding: EdgeInsets.zero,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
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
                        height: AppSizes.size30,
                      ),
                      Text(
                        AppConstString.creditedText,
                        style: AppTextStyle.regular36
                            .copyWith(fontFamily: 'Bebas'),
                      ),
                      Text(
                        AppConstString.bounzCount,
                        style: AppTextStyle.regular60
                            .copyWith(fontFamily: 'Bebas'),
                      ),
                      const SizedBox(
                        height: AppSizes.size30,
                      ),
                      Text(
                        AppConstString.frdReferText,
                        style: AppTextStyle.light16,
                      ),
                      const SizedBox(
                        height: AppSizes.size30,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SvgPicture.asset(
                        AppAssets.friendReferBg,
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20.0, top: 24.0),
                        child: Image.asset(
                          AppAssets.creditedBounzMen,
                          fit: BoxFit.contain,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              bottom: AppSizes.size30,
              right: 0.0,
              left: 0.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  continueButtonWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget continueButtonWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.size30),
      child: PrimaryButton(
        text: AppConstString.ctn,
        showShadow: true,
        onTap: () {
          MoenageManager.logScreenEvent(name: 'Spin The Wheel');
          AutoRouter.of(context)
              .pushNamed("/spin_the_wheel_screen/type/register/true");
        },
      ),
    );
  }
}
