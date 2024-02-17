import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/modules/my_purchase/my_travel/my_travel_screen_model.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';

import 'my_travel_screen_view.dart';
import 'package:flutter/material.dart';
import 'my_travel_screen_presenter.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/utils/api_keys.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';

@RoutePage()
class MyTravelScreen extends StatefulWidget {
  final String apiPath;
  const MyTravelScreen({Key? key, required this.apiPath}) : super(key: key);

  @override
  State<MyTravelScreen> createState() => _MyTravelScreenState();
}

class _MyTravelScreenState extends State<MyTravelScreen>
    implements MyTravelScreenView {
  MyTravelPresenter myTravelPresenter = BasicMyTravelPresenter();
  late MyTravelScreenModel model;
  @override
  void initState() {
    super.initState();
    myTravelPresenter.updateView = this;
    myTravelPresenter.generateBookingLinkForTravelP(
        context: context,
        data: {
          ApiKeys.siteIdK: GlobalSingleton.isProd
              ? "641892e61c02d574905f8a5e"
              : "63f8cedfdf466f0b935c9a73",
          ApiKeys.firstNameK: GlobalSingleton.userInformation.firstName,
          ApiKeys.lastNameK: GlobalSingleton.userInformation.lastName,
          ApiKeys.mobileNumK: GlobalSingleton.userInformation.mobileNumber,
          ApiKeys.emailAddersK: GlobalSingleton.userInformation.email,
          ApiKeys.bounzMembershipK:
              GlobalSingleton.userInformation.membershipNo,
          ApiKeys.loyaltyTypeK: "BOUNZ"
        },
        apiPath: widget.apiPath);
    //},apiPath: ApiPath.travelPurchase);
  }

  @override
  void refreshModel(MyTravelScreenModel myTravelScreenModel) {
    setState(() {
      model = myTravelScreenModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        confirmBackBottomsheet();
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: AppBackGroundWidget(
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              Container(
                color: AppColors.whiteColor,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      confirmBackBottomsheet();
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(
                          left: AppSizes.size20, top: AppSizes.size20),
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  model.controller != null
                      ? Expanded(
                          child: WebViewWidget(
                            controller: model.controller!,
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void confirmBackBottomsheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.secondaryContainerColor,
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.size20),
              topRight: Radius.circular(AppSizes.size20)),
        ),
        builder: (context) {
          return Builder(builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                top: AppSizes.size20,
                right: AppSizes.size20,
                left: AppSizes.size20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: 130.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppConstString.conformExitText,
                      style: AppTextStyle.semiBold14.copyWith(
                        color: AppColors.btnBlueColor,
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.size20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: RoundedBorderButton(
                            height: AppSizes.size60,
                            onTap: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            bColor: AppColors.btnBlueColor,
                            tColor: AppColors.btnBlueColor,
                            text: AppConstString.yes,
                          ),
                        ),
                        const SizedBox(
                          width: AppSizes.size10,
                        ),
                        Expanded(
                          child: PrimaryButton(
                            height: AppSizes.size60,
                            text: AppConstString.no,
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: AppSizes.size20,
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}
