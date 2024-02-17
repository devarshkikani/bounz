import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/dashboard/dashboard_model.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/modules/account/my_account_model.dart';
import 'package:bounz_revamp_app/modules/account/my_account_presenter.dart';
import 'package:bounz_revamp_app/modules/account/my_account_view.dart';
import 'package:bounz_revamp_app/modules/social_media/bounz_facebook.dart';
import 'package:bounz_revamp_app/modules/social_media/bounz_instagram.dart';
import 'package:bounz_revamp_app/modules/social_media/bounz_linkedin.dart';
import 'package:bounz_revamp_app/modules/social_media/bounz_twitter.dart';
import 'package:bounz_revamp_app/modules/social_media/bounz_youtube.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/widgets/my_behavior.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_inbox/inbox_data.dart';
import 'package:moengage_inbox/moengage_inbox.dart';

enum Availability { loading, available, unavailable }

class MyAccountScreen extends StatefulWidget {
  final DashBoardModel dashBoardModel;
  const MyAccountScreen({Key? key, required this.dashBoardModel})
      : super(key: key);

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen>
    implements MyAccountView {
  MyAccountPresenter presenter = BasicMyAccountPresenter();
  late MyAccountModel model;
  Color headerTextColor = AppColors.whiteColor;
  ScrollController? _scrollController;
  bool lastStatus = true;
  GlobalKey<ScaffoldState>? _scaffoldKey;

  // final String _appStoreId = 'com.citypoints.bounzrewards';

  final MoEngageInbox _moEngageInbox =
      MoEngageInbox("668EZ1ENJ3R8N6YSZNAGIQP0");
  InboxData? notificationCount;

  void fetchMessages() async {
    InboxData? data = await _moEngageInbox.fetchAllMessages();
    notificationCount = data!;
    if (data.messages.isNotEmpty) {
      for (final message in data.messages) {
        _moEngageInbox.trackMessageClicked(message);
      }
    }
    setState(() {});
  }

  void _scrollListener() {
    if (_isShrink != lastStatus) {
      setState(() {
        lastStatus = _isShrink;
      });
    }
  }

  bool get _isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset > (148 - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    fetchMessages();
    presenter.updateView = this;
    _scrollController = ScrollController()..addListener(_scrollListener);
    for (int i = 0;
        i < widget.dashBoardModel.data!.header![0].data!.length;
        i++) {
      if (widget.dashBoardModel.data!.header![0].data![i].key == "font_color") {
        String color = widget.dashBoardModel.data!.header![0].data![i].value!;
        color = color.substring(1);
        color = "0xff" + color;
        headerTextColor = Color(int.parse(color));
      }
    }
    _scaffoldKey = GlobalKey();

    (<T>(T? o) => o!)(WidgetsBinding.instance).addPostFrameCallback((_) async {
      try {
        setState(() {
          // This plugin cannot be tested on Android by installing your app
          // locally. See https://github.com/britannio/in_app_review#testing for
          // more information.
        });
      } catch (_) {}
    });
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    _scaffoldKey?.currentState?.dispose();
    super.dispose();
  }

  Future getProfileData(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.getProfile,
      context: context,
      queryParameters: {
        'membership_no': GlobalSingleton.userInformation.membershipNo,
      },
    );
    if (response != null) {
      storeLoginUserData(
        response['data']['values'][0],
        context,
      );
    }
  }

  void storeLoginUserData(Map<String, dynamic> response, BuildContext context) {
    GlobalSingleton.userInformation = UserInformation.fromJson(response);

    StorageManager.setStringValue(
      key: AppStorageKey.userInformation,
      value: userInformationToJson(GlobalSingleton.userInformation),
    );

    StorageManager.setBoolValue(key: AppStorageKey.isLogIn, value: true);
  }

  @override
  void refreshModel(MyAccountModel myAccountModel) {
    setState(() {
      model = myAccountModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.backgroundColor,
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor:
                  _isShrink ? Colors.transparent : AppColors.backgroundColor,
              expandedHeight: 210,
              collapsedHeight: 70,
              pinned: true,
              centerTitle: false,
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1,
                collapseMode: CollapseMode.pin,
                titlePadding: EdgeInsets.zero,
                background: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.darkOrangeColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppSizes.size30),
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        appbarView(),
                        const SizedBox(
                          height: 26.0,
                        ),
                        totalBounzPointsWidget(),
                      ],
                    ),
                  ),
                ),
                title: _isShrink
                    ? Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        decoration: const BoxDecoration(
                          color: AppColors.darkOrangeColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(AppSizes.size30),
                          ),
                        ),
                        child: SafeArea(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      MoenageManager.logScreenEvent(
                                          name: 'My Profile');
                                      AutoRouter.of(context)
                                          .push(
                                        MyProfileScreenRoute(),
                                      )
                                          .then((value) {
                                        setState(() {});
                                      });
                                    },
                                    child: ClipOval(
                                      child: SizedBox(
                                        height: AppSizes.size44,
                                        width: AppSizes.size44,
                                        //color: AppColors.errorColor,
                                        child: GlobalSingleton.userInformation
                                                        .image ==
                                                    null ||
                                                GlobalSingleton.userInformation
                                                        .image ==
                                                    "null"
                                            ? GlobalSingleton.userInformation
                                                        .gender ==
                                                    "male"
                                                ? SvgPicture.asset(
                                                    AppAssets.men,
                                                  )
                                                : SvgPicture.asset(
                                                    AppAssets.women,
                                                  )
                                            : networkImage(GlobalSingleton
                                                .userInformation.image
                                                .toString()),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: AppSizes.size12,
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        child: Text(
                                          "Hi ",
                                          style:
                                              AppTextStyle.semiBold16.copyWith(
                                            color: headerTextColor,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2.6,
                                        height: 24,
                                        child: Text(
                                          GlobalSingleton
                                              .userInformation.firstName
                                              .toString(),
                                          style:
                                              AppTextStyle.semiBold16.copyWith(
                                            color: headerTextColor,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Row(
                              //   children: [
                              //     Text(
                              //       'Hi ' +
                              //           GlobalSingleton
                              //               .userInformation.firstName
                              //               .toString(),
                              //       style: AppTextStyle.semiBold16,
                              //     ),
                              //     const SizedBox(
                              //       width: AppSizes.size8,
                              //     ),
                              //   ],
                              // ),
                              // const Spacer(),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppConstString.yourBOUNZ,
                                    style: AppTextStyle.regular12,
                                  ),
                                  Text(
                                    GlobalSingleton
                                        .userInformation.pointBalance!.price
                                        .toString(),
                                    style: AppTextStyle.bold20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : null,
              ),
            ),
          ];
        },
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              getProfileData(context);
              fetchMessages();
            });
          },
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: Container(
              color: AppColors.scaffoldColor,
              child: SingleChildScrollView(
                child: Container(
                  color: AppColors.scaffoldColor,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      firstContainer(),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      secondContainer(),
                      // const SizedBox(
                      //   height: AppSizes.size20,
                      // ),
                      // imageContainer(),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      thirdContainer(),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      Text(
                        AppConstString.connectWithText,
                        style: AppTextStyle.semiBold14,
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      socialWidget(),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      versionTextWidget(),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      logoutButton(),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      deleteAccountButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget appbarView() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.size20,
          AppSizes.size20,
          AppSizes.size20,
          0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 40,
                  child: Row(
                    children: [
                      SvgPicture.network(getImgUrl()),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.center,
              // color: Colors.black,
              padding: EdgeInsets.only(
                left: GlobalSingleton.userInformation.firstName
                            .toString()
                            .length <=
                        4
                    ? MediaQuery.of(context).size.width / 13
                    : GlobalSingleton.userInformation.firstName
                                .toString()
                                .length >
                            8
                        ? MediaQuery.of(context).size.width * 0.04
                        : MediaQuery.of(context).size.width * 0.055,
              ),
              width:
                  GlobalSingleton.userInformation.firstName.toString().length <=
                          4
                      ? MediaQuery.of(context).size.width / 2.4
                      : MediaQuery.of(context).size.width / 2.26,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      MoenageManager.logScreenEvent(name: 'My Profile');
                      final properties = MoEProperties();
                      properties
                          .addAttribute(
                              TriggeringCondition.screenName, "My Account")
                          .addAttribute(
                              TriggeringCondition.componentType, "Icons")
                          .addAttribute(TriggeringCondition.filterSelected, "")
                          .addAttribute(
                              TriggeringCondition.componentName, "Header")
                          .addAttribute(
                              TriggeringCondition.clickedOn, "Profile icon")
                          .addAttribute(TriggeringCondition.imageUrl, "")
                          .addAttribute(TriggeringCondition.iconName, "Profile")
                          .setNonInteractiveEvent();
                      MoenageManager.logEvent(
                        MoenageEvent.screenClick,
                        properties: properties,
                      );
                      AutoRouter.of(context)
                          .push(
                        MyProfileScreenRoute(),
                      )
                          .then((value) {
                        setState(() {});
                      });
                    },
                    child: ClipOval(
                      child: SizedBox(
                        height: AppSizes.size40,
                        width: AppSizes.size40,
                        child: GlobalSingleton.userInformation.image == null ||
                                GlobalSingleton.userInformation.image == "null"
                            ? GlobalSingleton.userInformation.gender == "male"
                                ? SvgPicture.asset(
                                    AppAssets.men,
                                  )
                                : SvgPicture.asset(
                                    AppAssets.women,
                                  )
                            : networkImage(GlobalSingleton.userInformation.image
                                .toString()),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: AppSizes.size10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            child: Text(
                              "Hi ",
                              style: AppTextStyle.semiBold16.copyWith(
                                color: headerTextColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            //color: Colors.amber,
                            width: GlobalSingleton.userInformation.firstName
                                        .toString()
                                        .length <=
                                    4
                                ? MediaQuery.of(context).size.width / 6.5
                                : MediaQuery.of(context).size.width / 5,
                            height: 24,
                            child: Text(
                              GlobalSingleton.userInformation.firstName
                                  .toString(),
                              style: AppTextStyle.semiBold16.copyWith(
                                color: headerTextColor,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Text(
                      //   'Hi ' +
                      //       GlobalSingleton.userInformation.firstName
                      //           .toString(),
                      //   style: AppTextStyle.semiBold16,
                      // ),
                      //Don't remove this code : DEVARSH
                      // GestureDetector(
                      //   onTap: () {
                      //     countryPickerBottomsheet(
                      //       buildContext: context,
                      //       location: false,
                      //       text: "Enter Your Country Code",
                      //       passValue: (Country country) {
                      //         GlobalSingleton.userInformation.cityName =
                      //             country.name;
                      //         setState(() {});
                      //       },
                      //     );
                      //   },
                      //   child: Row(
                      //     children: [
                      //       SizedBox(
                      //         width: 43,
                      //         child: Text(
                      //           GlobalSingleton.userLocation?['country'] ??
                      //               'Dubai',
                      //           style: AppTextStyle.semiBold14.copyWith(
                      //               decoration: TextDecoration.underline,
                      //               color: headerTextColor,
                      //               overflow: TextOverflow.ellipsis),
                      //         ),
                      //       ),
                      //       const Icon(
                      //         Icons.keyboard_arrow_down_outlined,
                      //         color: AppColors.whiteColor,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      MoenageManager.logScreenEvent(name: 'Notification');
                      final properties = MoEProperties();
                      properties
                          .addAttribute(
                              TriggeringCondition.screenName, "My Account")
                          .addAttribute(
                              TriggeringCondition.componentType, "Icons")
                          .addAttribute(TriggeringCondition.filterSelected, "")
                          .addAttribute(
                              TriggeringCondition.componentName, "Header")
                          .addAttribute(TriggeringCondition.clickedOn,
                              "Notification icon")
                          .addAttribute(TriggeringCondition.imageUrl, "")
                          .addAttribute(
                              TriggeringCondition.iconName, "Notification")
                          .setNonInteractiveEvent();
                      MoenageManager.logEvent(
                        MoenageEvent.screenClick,
                        properties: properties,
                      );

                      AutoRouter.of(context).push(NotificationScreenRoute());
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 7.0, right: 3),
                      child: notificationCount != null
                          ? notificationCount!.messages.isNotEmpty
                              ? SvgPicture.asset(
                                  AppAssets.withNotification,
                                  height: 22,
                                )
                              : SvgPicture.asset(
                                  AppAssets.withoutNotification,
                                  height: 22,
                                )
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget totalBounzPointsWidget() {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainerColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            color: const Color(0xff8b6969).withOpacity(.8),
            offset: const Offset(10, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: AppSizes.size20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstString.yourBOUNZ,
                    style: AppTextStyle.regular12.copyWith(
                      color: AppColors.btnBlueColor,
                    ),
                  ),
                  Text(
                    GlobalSingleton.userInformation.pointBalance!.price
                        .toString(),
                    style: AppTextStyle.bold20.copyWith(
                      color: AppColors.btnBlueColor,
                    ),
                  ),
                ],
              ),
              Container(
                width: 0.5,
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.size30),
                height: AppSizes.size36,
                color: AppColors.btnBlueColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstString.membershipID,
                        style: AppTextStyle.regular12.copyWith(
                          color: AppColors.btnBlueColor,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            GlobalSingleton.userInformation.membershipNo
                                .toString(),
                            style: AppTextStyle.bold20.copyWith(
                              color: AppColors.btnBlueColor,
                            ),
                          ),
                          const SizedBox(
                            width: AppSizes.size10,
                          ),
                          InkWell(
                            onTap: () {
                              final properties = MoEProperties();
                              properties
                                  .addAttribute(TriggeringCondition.screenName,
                                      "My Account")
                                  .addAttribute(
                                      TriggeringCondition.componentType,
                                      "Icons")
                                  .addAttribute(
                                      TriggeringCondition.filterSelected, "")
                                  .addAttribute(
                                      TriggeringCondition.componentName,
                                      "Header")
                                  .addAttribute(TriggeringCondition.clickedOn,
                                      "Copy icon")
                                  .addAttribute(
                                      TriggeringCondition.imageUrl, "")
                                  .addAttribute(
                                      TriggeringCondition.iconName, "Copy")
                                  .setNonInteractiveEvent();
                              MoenageManager.logEvent(
                                MoenageEvent.screenClick,
                                properties: properties,
                              );
                              NetworkDio.showWarning(
                                context: context,
                                message: 'Saved Membership Id in clipboard',
                              );
                              Clipboard.setData(
                                ClipboardData(
                                  text: GlobalSingleton
                                      .userInformation.membershipNo
                                      .toString(),
                                ),
                              );
                            },
                            child: SvgPicture.asset(
                              AppAssets.copy,
                              height: 22,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: AppSizes.size12,
          ),
        ],
      ),
    );
  }

  Widget firstContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
      padding: const EdgeInsets.only(
        left: AppSizes.size16,
        top: AppSizes.size16,
        right: AppSizes.size16,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryContainerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: itemDecoration(
              imagePath: AppAssets.myProfile,
              scale: 1.23,
              title: AppConstString.myProfile2,
              isSvg: true,
              padding: const EdgeInsets.only(
                right: 12,
              ),
              onTap: () {
                MoenageManager.logScreenEvent(name: 'My Profile');
                AutoRouter.of(context)
                    .push(
                  MyProfileScreenRoute(),
                )
                    .then((value) {
                  setState(() {});
                });
              },
            ),
          ),
          itemDecoration(
            imagePath: AppAssets.myBounz,
            title: AppConstString.myBOUNZ,
            svgHeight: 26,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            isSvg: true,
            onTap: () {
              MoenageManager.logScreenEvent(name: 'My Bounz');

              AutoRouter.of(context).push(
                MyBounzScreenRoute(),
              );
            },
          ),
          itemDecoration(
            imagePath: AppAssets.digitalReceipt,
            title: AppConstString.digitalReceipts,
            svgHeight: 26,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            isSvg: true,
            onTap: () {
              MoenageManager.logScreenEvent(name: 'Receipts List');

              AutoRouter.of(context).push(
                ReceiptsListScreenRoute(),
              );
            },
          ),
          itemDecoration(
            imagePath: AppAssets.myPurchase,
            title: AppConstString.myPurchases,
            svgHeight: 26,
            isSvg: true,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            onTap: () {
              MoenageManager.logScreenEvent(name: 'My Purchases');

              AutoRouter.of(context).push(
                MyPurchasesScreenRoute(),
              );
            },
          ),
          itemDecoration(
            imagePath: AppAssets.myPurchase,
            title: AppConstString.myVouchers,
            svgHeight: 26,
            isSvg: true,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            onTap: () {
              MoenageManager.logScreenEvent(name: 'Vouchers history');
              AutoRouter.of(context).push(
                VoucherWonHistoryScreenRoute(),
              );
            },
          ),
          itemDecoration(
            imagePath: AppAssets.redeemedOffer,
            title: AppConstString.redeemedOffer,
            svgHeight: 26,
            isSvg: true,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            onTap: () {
              MoenageManager.logScreenEvent(name: 'Redeemed Offer');

              AutoRouter.of(context).push(
                RedeemedOfferScreenRoute(
                  redirectToHome: false,
                ),
              );
            },
          ),
          itemDecoration(
            imagePath: AppAssets.claimRewards,
            title: AppConstString.claimRewards,
            svgHeight: 26,
            isSvg: true,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            onTap: () {
              MoenageManager.logScreenEvent(name: 'Claim Rewards');

              AutoRouter.of(context).push(
                ClaimRewardsScreenRoute(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget secondContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
      padding: const EdgeInsets.only(
        left: AppSizes.size16,
        top: AppSizes.size16,
        right: AppSizes.size16,
        bottom: 10,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryContainerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          itemDecoration(
            imagePath: AppAssets.comunicationPreference,
            title: AppConstString.communicationPreferences,
            svgHeight: 26,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            isSvg: true,
            onTap: () {
              MoenageManager.logScreenEvent(
                  name: 'Select Communication Preference');

              AutoRouter.of(context).push(
                SelectCommunicationPreferenceScreenRoute(),
              );
            },
          ),
          itemDecoration(
            imagePath: AppAssets.personalizeYourInterest,
            title: AppConstString.personalizeYourInterest,
            svgHeight: 26,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            isSvg: true,
            onTap: () {
              MoenageManager.logScreenEvent(name: 'My Interest');

              AutoRouter.of(context).push(
                MyInterestScreenRoute(),
              );
            },
          ),
          itemDecoration(
            imagePath: AppAssets.rateUs,
            title: AppConstString.rateUs,
            svgHeight: 26,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            isSvg: true,
            onTap: () {
              MoenageManager.logScreenEvent(name: 'Feedback');
              AutoRouter.of(context).push(
                FeedbackScreenRoute(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget thirdContainer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
      padding: const EdgeInsets.all(AppSizes.size16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainerColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          itemDecoration(
            imagePath: AppAssets.help,
            title: AppConstString.helpandSupport,
            svgHeight: 26,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            isSvg: true,
            onTap: () {
              MoenageManager.logScreenEvent(name: 'Help Support');

              AutoRouter.of(context).push(
                HelpSupportScreenRoute(),
              );
            },
          ),
          itemDecoration(
            imagePath: AppAssets.tnc,
            title: AppConstString.termsandConditions,
            svgHeight: 26,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            isSvg: true,
            onTap: () {
              MoenageManager.logScreenEvent(name: 'Terms Conditions');

              AutoRouter.of(context).push(
                TermsConditionsRoute(),
              );
            },
          ),
          itemDecoration(
            imagePath: AppAssets.privacyPolicy,
            title: AppConstString.privacyPolicy,
            svgHeight: 26,
            padding: const EdgeInsets.only(
              left: 8,
              right: 8,
            ),
            isSvg: true,
            onTap: () {
              MoenageManager.logScreenEvent(name: 'Privacy Policy');

              AutoRouter.of(context).push(
                PrivacyPolicyRoute(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget imageContainer() {
    return InkWell(
      onTap: () {
        MoenageManager.logScreenEvent(name: 'Refer Earn');
        final properties = MoEProperties();
        properties
            .addAttribute(TriggeringCondition.screenName, "My Account")
            .addAttribute(TriggeringCondition.componentType, "image")
            .addAttribute(TriggeringCondition.filterSelected, "")
            .addAttribute(TriggeringCondition.componentName, "")
            .addAttribute(TriggeringCondition.clickedOn, "Refer Earn")
            .addAttribute(TriggeringCondition.imageUrl, AppAssets.referFriend)
            .addAttribute(TriggeringCondition.iconName, "")
            .setNonInteractiveEvent();
        MoenageManager.logEvent(
          MoenageEvent.screenClick,
          properties: properties,
        );

        AutoRouter.of(context).push(
          ReferEarnScreenRoute(),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
        child: SvgPicture.asset(
          AppAssets.referFriend,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }

  Widget socialWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            final properties = MoEProperties();
            properties
                .addAttribute(TriggeringCondition.social, 'Facebook')
                .addAttribute(TriggeringCondition.screenName, 'My Account')
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.connectSocially,
              properties: properties,
            );
            final properties1 = MoEProperties();
            properties1
                .addAttribute(TriggeringCondition.screenName, "My Account")
                .addAttribute(TriggeringCondition.componentType, "Icons")
                .addAttribute(TriggeringCondition.filterSelected, "")
                .addAttribute(TriggeringCondition.componentName, "")
                .addAttribute(TriggeringCondition.clickedOn, "Facebook icon")
                .addAttribute(TriggeringCondition.imageUrl, "")
                .addAttribute(
                    TriggeringCondition.iconName, AppAssets.faceBookNew)
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.screenClick,
              properties: properties1,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BounzFacebook(),
              ),
            );
          },
          child: SvgPicture.asset(
            AppAssets.faceBookNew,
          ),
        ),
        const SizedBox(
          width: AppSizes.size10,
        ),
        InkWell(
          onTap: () {
            final properties = MoEProperties();
            properties
                .addAttribute(TriggeringCondition.social, 'Instagram')
                .addAttribute(TriggeringCondition.screenName, 'My Account')
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.connectSocially,
              properties: properties,
            );

            final properties1 = MoEProperties();
            properties1
                .addAttribute(TriggeringCondition.screenName, "My Account")
                .addAttribute(TriggeringCondition.componentType, "Icons")
                .addAttribute(TriggeringCondition.filterSelected, "")
                .addAttribute(TriggeringCondition.componentName, "")
                .addAttribute(TriggeringCondition.clickedOn, "Instagram icon")
                .addAttribute(TriggeringCondition.imageUrl, "")
                .addAttribute(
                    TriggeringCondition.iconName, AppAssets.instagramNew)
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.screenClick,
              properties: properties1,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BounzInstagram(),
              ),
            );
          },
          child: SvgPicture.asset(
            AppAssets.instagramNew,
          ),
        ),
        const SizedBox(
          width: AppSizes.size10,
        ),
        InkWell(
          onTap: () {
            final properties = MoEProperties();
            properties
                .addAttribute(TriggeringCondition.social, 'Linkedin')
                .addAttribute(TriggeringCondition.screenName, 'My Account')
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.connectSocially,
              properties: properties,
            );
            final properties1 = MoEProperties();
            properties1
                .addAttribute(TriggeringCondition.screenName, "My Account")
                .addAttribute(TriggeringCondition.componentType, "Icons")
                .addAttribute(TriggeringCondition.filterSelected, "")
                .addAttribute(TriggeringCondition.componentName, "")
                .addAttribute(TriggeringCondition.clickedOn, "Linkedin icon")
                .addAttribute(TriggeringCondition.imageUrl, "")
                .addAttribute(
                    TriggeringCondition.iconName, AppAssets.linkedinNew)
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.screenClick,
              properties: properties1,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BounzLinkedIn(),
              ),
            );
          },
          child: SvgPicture.asset(
            AppAssets.linkedinNew,
          ),
        ),
        const SizedBox(
          width: AppSizes.size10,
        ),
        InkWell(
          onTap: () {
            final properties = MoEProperties();
            properties
                .addAttribute(TriggeringCondition.social, 'Twitter')
                .addAttribute(TriggeringCondition.screenName, 'My Account')
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.connectSocially,
              properties: properties,
            );

            final properties1 = MoEProperties();
            properties1
                .addAttribute(TriggeringCondition.screenName, "My Account")
                .addAttribute(TriggeringCondition.componentType, "Icons")
                .addAttribute(TriggeringCondition.filterSelected, "")
                .addAttribute(TriggeringCondition.componentName, "")
                .addAttribute(TriggeringCondition.clickedOn, "Twitter icon")
                .addAttribute(TriggeringCondition.imageUrl, "")
                .addAttribute(
                    TriggeringCondition.iconName, AppAssets.twitterNew)
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.screenClick,
              properties: properties1,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BounzTwitter(),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 0, 0, 5),
            child: SvgPicture.asset(
              AppAssets.twitterNew,
              height: 20,
              width: 20,
            ),
          ),
        ),
        const SizedBox(
          width: AppSizes.size10,
        ),
        InkWell(
          onTap: () {
            final properties = MoEProperties();
            properties
                .addAttribute(TriggeringCondition.social, 'Youtube')
                .addAttribute(TriggeringCondition.screenName, 'My Account')
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.connectSocially,
              properties: properties,
            );

            final properties1 = MoEProperties();
            properties1
                .addAttribute(TriggeringCondition.screenName, "My Account")
                .addAttribute(TriggeringCondition.componentType, "Icons")
                .addAttribute(TriggeringCondition.filterSelected, "")
                .addAttribute(TriggeringCondition.componentName, "")
                .addAttribute(TriggeringCondition.clickedOn, "Youtube icon")
                .addAttribute(TriggeringCondition.imageUrl, "")
                .addAttribute(
                    TriggeringCondition.iconName, AppAssets.youtubeNew)
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.screenClick,
              properties: properties1,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const BounzYoutube(),
              ),
            );
          },
          child: SvgPicture.asset(
            AppAssets.youtubeNew,
          ),
        ),
      ],
    );
  }

  Widget versionTextWidget() {
    return Text(
      'Version ${GlobalSingleton.appVersion}',
      style: AppTextStyle.light14,
    );
  }

  Widget logoutButton() {
    return RoundedBorderButton(
      height: AppSizes.size60,
      onTap: () {
        popupBottomSheet(context, true);
        final properties = MoEProperties();
        properties
            .addAttribute(TriggeringCondition.screenName, 'My Account')
            .addAttribute(TriggeringCondition.componentType, 'Button')
            .addAttribute(TriggeringCondition.filterSelected, '')
            .addAttribute(TriggeringCondition.componentName, '')
            .addAttribute(TriggeringCondition.clickedOn, 'Logout')
            .addAttribute(TriggeringCondition.imageUrl, '')
            .addAttribute(TriggeringCondition.iconName, '')
            .setNonInteractiveEvent();
        MoenageManager.logEvent(
          MoenageEvent.screenClick,
          properties: properties,
        );
      },
      text: AppConstString.logout,
    );
  }

  Widget deleteAccountButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.size20),
      child: Center(
        child: RoundedBorderButton(
          height: AppSizes.size60,
          onTap: () {
            popupBottomSheet(context, false);
            final properties = MoEProperties();
            properties
                .addAttribute(TriggeringCondition.screenName, 'My Account')
                .addAttribute(TriggeringCondition.componentType, 'Button')
                .addAttribute(TriggeringCondition.filterSelected, '')
                .addAttribute(TriggeringCondition.componentName, '')
                .addAttribute(TriggeringCondition.clickedOn, 'Delete button')
                .addAttribute(TriggeringCondition.imageUrl, '')
                .addAttribute(TriggeringCondition.iconName, '')
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.screenClick,
              properties: properties,
            );
          },
          bColor: AppColors.textColorRed,
          tColor: AppColors.textColorRed,
          text: AppConstString.deleteAccountButton,
        ),
      ),
    );
  }

  Widget itemDecoration(
      {required String imagePath,
      required String title,
      required Function() onTap,
      bool isSvg = false,
      double? svgHeight,
      double? svgWidth,
      double? scale,
      double? assetHeight,
      EdgeInsetsGeometry? padding,
      double? width}) {
    return InkWell(
      onTap: () {
        final properties = MoEProperties();
        properties
            .addAttribute(TriggeringCondition.screenName, "My Account")
            .addAttribute(TriggeringCondition.componentType, "")
            .addAttribute(TriggeringCondition.filterSelected, "")
            .addAttribute(TriggeringCondition.componentName, "")
            .addAttribute(TriggeringCondition.clickedOn, title)
            .addAttribute(TriggeringCondition.imageUrl, imagePath)
            .addAttribute(TriggeringCondition.iconName, "")
            .setNonInteractiveEvent();
        MoenageManager.logEvent(
          MoenageEvent.screenClick,
          properties: properties,
        );
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Row(
          children: [
            isSvg
                ? Padding(
                    padding: padding ??
                        const EdgeInsets.only(
                          right: 10,
                        ),
                    child: SvgPicture.asset(
                      imagePath,
                      height: svgHeight ?? 20,
                      width: svgWidth,
                    ),
                  )
                : Image.asset(
                    imagePath,
                    height: assetHeight ?? 40,
                    width: width,
                    scale: scale,
                  ),
            const SizedBox(
              width: 4.0,
            ),
            Text(
              title,
              style: AppTextStyle.semiBold16,
            ),
            const Spacer(
              flex: 2,
            ),
            const Icon(
              Icons.keyboard_arrow_right_rounded,
              color: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }

  Future popupBottomSheet(BuildContext buildContext, bool isLogout) {
    return showModalBottomSheet(
      backgroundColor: AppColors.secondaryContainerColor,
      context: buildContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: AppSizes.size20,
            right: AppSizes.size20,
            left: AppSizes.size20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstString.confirmText,
                  style: AppTextStyle.bold16
                      .copyWith(color: AppColors.darkBlueTextColor),
                ),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                Text(
                  isLogout
                      ? 'Are you sure you want to logout?'
                      : 'Are you sure you want to delete your BOUNZ permanently?😔',
                  style: AppTextStyle.semiBold14
                      .copyWith(color: AppColors.darkBlueTextColor),
                ),
                const SizedBox(
                  height: AppSizes.size30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RoundedBorderButton(
                        height: AppSizes.size60,
                        onTap: isLogout
                            ? () {
                                presenter.logout(context);
                              }
                            : () {
                                presenter.deleteAccount(context);
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
                )
              ],
            ),
          ),
        );
      },
    );
  }

  String getImgUrl() {
    String imgUrl = "";
    for (int i = 0;
        i < widget.dashBoardModel.data!.header![0].data!.length;
        i++) {
      if (widget.dashBoardModel.data!.header![0].data![i].key == "logo") {
        imgUrl = widget.dashBoardModel.data!.assetPath! +
            widget.dashBoardModel.data!.header![0].data![i].value!;
      }
    }
    return imgUrl;
  }
}
