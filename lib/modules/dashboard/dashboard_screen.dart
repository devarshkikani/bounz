import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:auto_route/auto_route.dart';
import 'package:barcode_widget/barcode_widget.dart';
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
import 'package:bounz_revamp_app/models/dashboard/get_otp_model.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/modules/dashboard/dashboard_presenter.dart';
import 'package:bounz_revamp_app/modules/main_home/main_home_presenter.dart';
import 'package:bounz_revamp_app/modules/main_home/main_home_view.dart';

import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/widgets/my_behavior.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:moengage_inbox/inbox_data.dart';
import 'package:moengage_inbox/moengage_inbox.dart';
import '../main_home/main_home_model.dart';
// ignore_for_file: must_be_immutable

class DashBoardScreen extends StatefulWidget {
  DashBoardModel dashBoardModel;
  final bool? isHeaderExpanded;

  DashBoardScreen({
    Key? key,
    required this.dashBoardModel,
    this.isHeaderExpanded,
  }) : super(key: key);

  @override
  DashBoardScreenState createState() => DashBoardScreenState();
}

bool isTapped = false;

class DashBoardScreenState extends State<DashBoardScreen>
    with TickerProviderStateMixin
    implements MainHomeView {
  MainHomePresenter presenter = BasicMainHomePresenter();
  bool containerVisible = false;
  int bannerSlideIndex = 0;
  int offerOfTheWeekIndex = 0;
  int selectedFeaturedOfferIndex = 0;
  int featuredSlideIndex = 0;
  int trendingSlideIndex = 0;
  int expandedHeight = 210;
  GlobalKey<ScaffoldState>? _scaffoldKey;

  final CarouselController bannerSliderController = CarouselController();
  final CarouselController featuredController = CarouselController();
  final CarouselController trendingImagesController = CarouselController();
  final CarouselController offerOfTheWeekController = CarouselController();
  final CarouselController topStoriesController = CarouselController();
  final CarouselController moreWithBounzController = CarouselController();
  final CarouselController affiliatePartnerController = CarouselController();
  final CarouselController dynamicController = CarouselController();

  List<Datum> bannerSlider = [];

  List<Datum> featuredOfferBannerList = [];

  final List<String> trendingOfferBannerList = [];
  ScrollController? _scrollController;
  bool lastStatus = true;
  Color dashboardBgColor = AppColors.darkOrangeColor;
  Color headerTextColor = AppColors.whiteColor;
  String headerImage = "";
  String assetPath = '';
  String themeOnCollapse = "true";
  double screenWidth = 140;
  double screenHeight = 500;
  AnimationController? _controller;
  int levelClock = 300;
  bool _otpBtnHide = false;

  DashBoardPresenter dashboardPresentor = BasicDashboardPresenter();
  final MoEngageInbox _moEngageInbox =
      MoEngageInbox(GlobalSingleton.moEngageAppId);
  InboxData? notificationCount;

  String getImgOrIconUrl({
    required String imgType,
    required int index,
    required List<Datum> imageData,
    required List<SectionIconData> iconData,
  }) {
    return assetPath +
        (imgType == AppConstString.image
            ? imageData[index].imgUrl ?? ''
            : iconData[index].iconUrl ?? '');
  }

  Future<void> fetchMessages() async {
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

  Future getProfileData() async {
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.getProfile,
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

  bool get _isShrink {
    return _scrollController != null &&
        _scrollController!.hasClients &&
        _scrollController!.offset >
            (containerVisible ? 220 : 148 - kToolbarHeight);
  }

  late AnimationController _animationController;
  late Animation<double> _animation;

  void animation() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 550));
    _animation = CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutQuart);

    _animationController.forward();
  }

  @override
  void initState() {
    super.initState();
    assetPath = widget.dashBoardModel.data?.assetPath ?? '';
    fetchMessages();
    _scrollController = ScrollController()..addListener(_scrollListener);
    containerVisible = widget.isHeaderExpanded ?? false;
    setAsPerRank();
    _scaffoldKey = GlobalKey();
    isTapped = StorageManager.getBoolValue('isBarcodeTapped') ?? false;
    presenter.updateView = this;
    presenter.getProfileData();
    animation();
    getDashboardHeaderData();
  }

  void expandCollapsButtonTap() {
    containerVisible = !containerVisible;
    if (containerVisible) {
      expandedHeight = 330;
    }
    setState(() {});
    homeScreenClickTrack(
      screenName: 'Home',
      componentType: 'Header',
      componentName: 'Header',
      clickedOn: containerVisible ? 'Header Collapse' : 'Header expand',
      imageUrl: '',
      iconName: containerVisible ? 'Arrow up' : 'Arrow down',
    );
  }

  void profileImageTap() {
    homeScreenClickTrack(
      screenName: 'Home',
      componentType: 'Icons',
      componentName: 'Header',
      clickedOn: 'ProfileIcon',
      imageUrl: '',
      iconName: 'Profile',
    );
    MoenageManager.logScreenEvent(name: 'My Profile');
    AutoRouter.of(context).push(MyProfileScreenRoute()).then((value) {
      setState(() {});
    });
  }

  void homeScreenClickTrack({
    required String screenName,
    required String componentType,
    required String componentName,
    required String clickedOn,
    required String imageUrl,
    required String iconName,
  }) {
    final properties = MoEProperties();
    properties
        .addAttribute(TriggeringCondition.screenName, screenName)
        .addAttribute(TriggeringCondition.componentType, componentType)
        .addAttribute(TriggeringCondition.componentName, componentName)
        .addAttribute(TriggeringCondition.clickedOn, clickedOn)
        .addAttribute(TriggeringCondition.imageUrl, imageUrl)
        .addAttribute(TriggeringCondition.iconName, iconName)
        .setNonInteractiveEvent();
    MoenageManager.logEvent(
      MoenageEvent.homeScreenClick,
      properties: properties,
    );
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    _scaffoldKey?.currentState?.dispose();
    _controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        if (isTapped) {
          setState(() {
            isTapped = false;
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.backgroundColor,
        body: Stack(
          children: [
            NestedScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              headerSliverBuilder: (context, innerBoxIsScrolled) {
                return <Widget>[
                  SliverAppBar(
                    stretch: _isShrink,
                    automaticallyImplyLeading: false,
                    pinned: true,
                    backgroundColor: _isShrink
                        ? Colors.transparent
                        : AppColors.backgroundColor,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    elevation: 0,
                    expandedHeight: expandedHeight.toDouble(),
                    excludeHeaderSemantics: true,
                    collapsedHeight: 70,
                    flexibleSpace: FlexibleSpaceBar(
                      expandedTitleScale: 1,
                      collapseMode: CollapseMode.pin,
                      titlePadding: EdgeInsets.zero,
                      background: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          AnimatedContainer(
                            height: (containerVisible ? 550 : 210) +
                                MediaQuery.of(context).viewPadding.top,
                            clipBehavior: Clip.hardEdge,
                            duration: const Duration(milliseconds: 500),
                            decoration: BoxDecoration(
                              color: dashboardBgColor,
                              image: headerImage != ""
                                  ? DecorationImage(
                                      image: NetworkImage(headerImage),
                                      fit: BoxFit.cover,
                                    )
                                  : null, //Don't remove HIMANI
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(AppSizes.size30),
                              ),
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                ScrollConfiguration(
                                  behavior: MyBehavior(),
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
                                Positioned(
                                  bottom: -40,
                                  child: ClipOval(
                                    child: Container(
                                      height: 80,
                                      width: 80,
                                      color: AppColors.backgroundColor,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: AppSizes.size10),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: GestureDetector(
                                            onTap: () {
                                              expandCollapsButtonTap();
                                            },
                                            child: Icon(
                                              containerVisible
                                                  ? Icons
                                                      .keyboard_arrow_up_rounded
                                                  : Icons
                                                      .keyboard_arrow_down_rounded,
                                              size: AppSizes.size30,
                                              color: AppColors.whiteColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      title: _isShrink
                          ? Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              decoration: BoxDecoration(
                                color: dashboardBgColor,
                                image: headerImage != ""
                                    ? themeOnCollapse == "true"
                                        ? DecorationImage(
                                            image: NetworkImage(headerImage),
                                            fit: BoxFit.cover,
                                          )
                                        : null
                                    : null, //Don't remove HIMANI
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(AppSizes.size30),
                                ),
                              ),
                              child: SafeArea(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            profileImageTap();
                                          },
                                          child: ClipOval(
                                            child: SizedBox(
                                              height: AppSizes.size44,
                                              width: AppSizes.size44,
                                              child: GlobalSingleton
                                                              .userInformation
                                                              .image ==
                                                          null ||
                                                      GlobalSingleton
                                                              .userInformation
                                                              .image ==
                                                          "null"
                                                  ? GlobalSingleton
                                                              .userInformation
                                                              .gender ==
                                                          "male"
                                                      ? SvgPicture.asset(
                                                          AppAssets.men,
                                                        )
                                                      : SvgPicture.asset(
                                                          AppAssets.women,
                                                        )
                                                  : networkImage(GlobalSingleton
                                                          .userInformation
                                                          .image ??
                                                      ''),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: AppSizes.size12,
                                        ),
                                        SizedBox(
                                          //  color: Colors.amber,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              2.7,
                                          height: 24,
                                          child: Text(
                                            GlobalSingleton.userInformation
                                                    .firstName ??
                                                '',
                                            style: AppTextStyle.semiBold16
                                                .copyWith(
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppConstString.yourBOUNZ,
                                              style: AppTextStyle.regular12,
                                            ),
                                            Text(
                                              GlobalSingleton.userInformation
                                                      .pointBalance?.price ??
                                                  '',
                                              style: AppTextStyle.bold20,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.045,
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
                  await getProfileData();
                  await presenter.getHomePageData(context);
                  await fetchMessages();
                  setState(() {});
                },
                child: ScrollConfiguration(
                  behavior: MyBehavior(),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      color: AppColors.backgroundColor,
                      child: ListView.builder(
                        itemCount: widget.dashBoardModel.data!.body!.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          if (widget.dashBoardModel.data!.body![index]
                                  .sectionCode ==
                              AppConstString.bannerSlidder) {
                            return bannerSliderWidget();
                          } else if (widget.dashBoardModel.data!.body![index]
                                  .sectionCode ==
                              AppConstString.featuredOffers) {
                            return featuredOfferWidget();
                          } else if (widget.dashBoardModel.data!.body![index]
                                  .sectionCode ==
                              AppConstString.offerOfTheWeek) {
                            return offerOfTheWeekWidget();
                          } else if (widget.dashBoardModel.data!.body![index]
                                  .sectionCode ==
                              AppConstString.moreWithBounz) {
                            return moreWithBounzWidget();
                          } else if (widget.dashBoardModel.data!.body![index]
                                  .sectionCode ==
                              AppConstString.trendingPartners) {
                            return trendingPartnerWidget();
                          } else if (widget.dashBoardModel.data!.body![index]
                                  .sectionCode ==
                              AppConstString.affiliatePartners) {
                            return affiliatePartnerBannerWidget();
                          } else if (widget.dashBoardModel.data!.body![index]
                                  .sectionCode ==
                              AppConstString.topStories) {
                            return topStoriesWidget();
                          } else if (widget.dashBoardModel.data!.body![index]
                                  .sectionCode ==
                              AppConstString.referAFriend) {
                            return referFriendWidget();
                          } else if (widget.dashBoardModel.data!.body![index]
                                  .sectionCode ==
                              AppConstString.growNow) {
                            return growNowWidget();
                          } else if (widget
                                  .dashBoardModel.data!.body![index].status ==
                              true) {
                            return dynamicWidgetFromCMS(
                                widget.dashBoardModel.data!.body![index]);
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (isTapped)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isTapped = !isTapped;
                  });
                  StorageManager.setBoolValue(
                      key: 'isBarcodeTapped', value: false);
                },
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.3),
                    child: ScaleTransition(
                      scale: _animation,
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height / 3),
                        height: 210,
                        width: 330,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: AppColors.blackColor.withOpacity(0.7),
                                  blurRadius: 7)
                            ],
                            color: AppColors.secondaryContainerColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                    top: 10,
                                  ),
                                  child: Text(
                                    AppConstString.scanBarcodePopup,
                                    textAlign: TextAlign.left,
                                    style: AppTextStyle.bold20
                                        .copyWith(color: AppColors.blackColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: AppSizes.size8,
                            ),
                            const SizedBox(height: AppSizes.size14),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                GlobalSingleton.userInformation.membershipNo ??
                                    "",
                                style: AppTextStyle.bold26.copyWith(
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.09,
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: BarcodeWidget(
                                  barcode: Barcode.code128(),
                                  drawText: false,
                                  data: GlobalSingleton
                                          .userInformation.membershipNo ??
                                      "",
                                  style: AppTextStyle.bold20
                                      .copyWith(color: AppColors.btnBlueColor),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ],
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
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    height: AppSizes.size40,
                    width: AppSizes.size40,
                    child: SvgPicture.network(getImgUrl()),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width / 11,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                left: (GlobalSingleton.userInformation.firstName ?? '')
                            .length <=
                        4
                    ? MediaQuery.of(context).size.width / 23
                    : (GlobalSingleton.userInformation.firstName ?? '').length >
                            8
                        ? MediaQuery.of(context).size.width / 180
                        : MediaQuery.of(context).size.width / 42,
              ),
              width:
                  (GlobalSingleton.userInformation.firstName ?? '').length <= 4
                      ? MediaQuery.of(context).size.width / 2.4
                      : MediaQuery.of(context).size.width / 2.26,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      MoenageManager.logScreenEvent(name: 'My Profile');
                      AutoRouter.of(context)
                          .push(MyProfileScreenRoute())
                          .then((_) {
                        setState(() {});
                      });
                    },
                    child: ClipOval(
                      child: SizedBox(
                          height: AppSizes.size40,
                          width: AppSizes.size40,
                          child: GlobalSingleton.userInformation.image ==
                                      null ||
                                  GlobalSingleton.userInformation.image ==
                                      "null"
                              ? GlobalSingleton.userInformation.gender == "male"
                                  ? SvgPicture.asset(
                                      AppAssets.men,
                                    )
                                  : SvgPicture.asset(
                                      AppAssets.women,
                                    )
                              : networkImage(
                                  GlobalSingleton.userInformation.image ?? '')),
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
                            width: (GlobalSingleton.userInformation.firstName ??
                                            '')
                                        .length <=
                                    4
                                ? MediaQuery.of(context).size.width / 6.5
                                : MediaQuery.of(context).size.width / 5,
                            height: 24,
                            child: Text(
                              GlobalSingleton.userInformation.firstName ?? '',
                              style: AppTextStyle.semiBold16.copyWith(
                                color: headerTextColor,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 7.0, right: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        dashboardPresentor.redirectToSpinWheel(context);
                        homeScreenClickTrack(
                          screenName: 'Home',
                          componentType: 'Icon',
                          componentName: 'Spin the wheel icon',
                          clickedOn: 'Spin the wheel icon',
                          imageUrl: '',
                          iconName: 'Spin the wheel',
                        );
                      },
                      child: !GlobalSingleton.isWheelSpined
                          ? Lottie.asset(
                              AppAssets.spinIcon2,
                              height: 27,
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 6, right: 3),
                              child: SvgPicture.asset(
                                AppAssets.spinWheel,
                                height: 21,
                              ),
                            ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width / 42),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: InkWell(
                        onTap: () {
                          homeScreenClickTrack(
                            screenName: 'Home',
                            componentType: 'Icon',
                            componentName: 'Notification icon',
                            clickedOn: 'Notification icon',
                            imageUrl: '',
                            iconName: 'Notification',
                          );
                          dashboardPresentor
                              .redirectToNotificationScreen(context);
                        },
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
            ),
          ],
        ),
      ),
    );
  }

  Widget totalBounzPointsWidget() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      height: containerVisible ? 210 : 95,
      onEnd: () {
        if (!containerVisible) {
          expandedHeight = 210;
        }
        setState(() {});
      },
      width: MediaQuery.of(context).size.width,
      clipBehavior: Clip.hardEdge,
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
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
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
                      GlobalSingleton.userInformation.pointBalance?.price ?? '',
                      style: AppTextStyle.bold20.copyWith(
                        color: AppColors.btnBlueColor,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 0.5,
                  margin:
                      const EdgeInsets.symmetric(horizontal: AppSizes.size30),
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
                              GlobalSingleton.userInformation.membershipNo ??
                                  '',
                              style: AppTextStyle.bold20.copyWith(
                                color: AppColors.btnBlueColor,
                              ),
                            ),
                            const SizedBox(
                              width: AppSizes.size10,
                            ),
                            InkWell(
                              onTap: () {
                                homeScreenClickTrack(
                                  screenName: 'Home',
                                  componentType: 'Icon',
                                  componentName: 'Header',
                                  clickedOn: 'Copy Icon',
                                  imageUrl: '',
                                  iconName: 'Copy',
                                );
                                NetworkDio.showWarning(
                                  context: context,
                                  message: 'Saved Membership Id in clipboard',
                                );
                                Clipboard.setData(
                                  ClipboardData(
                                    text: GlobalSingleton
                                            .userInformation.membershipNo ??
                                        '',
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
            if (GlobalSingleton.userInformation.expiryMessage != null &&
                GlobalSingleton.userInformation.expiryMessage != "") ...[
              const SizedBox(
                height: AppSizes.size4,
              ),
              Text(
                GlobalSingleton.userInformation.expiryMessage ?? "",
                style: AppTextStyle.bold12.copyWith(
                    color: AppColors.blackColor.withOpacity(0.5), fontSize: 11),
              ),
            ],
            const SizedBox(
              height: AppSizes.size6,
            ),
            Visibility(
              visible: containerVisible,
              child: ScrollConfiguration(
                behavior: MyBehavior(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 0.5,
                        color: AppColors.btnBlueColor.withOpacity(0.2),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            AppConstString.redeemBounzText,
                            style: AppTextStyle.semiBold16.copyWith(
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: AppSizes.size20),
                        child: Text(
                          AppConstString.scanBarcodeText,
                          style: AppTextStyle.regular12.copyWith(
                            color: AppColors.blackColor.withOpacity(0.8),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.size10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTapDown: (value) {
                                  animation();
                                  isTapped = !isTapped;
                                  setState(() {});
                                },
                                child: BarcodeWidget(
                                  barcode: Barcode.code128(),
                                  height: AppSizes.size28,
                                  width: 110,
                                  drawText: false,
                                  data: GlobalSingleton
                                          .userInformation.membershipNo ??
                                      "",
                                ),
                              )
                            ],
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: AppSizes.size8),
                              child: Text(
                                AppConstString.or,
                                style: AppTextStyle.regular12.copyWith(
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ),
                          ),
                          otpButtonWidget(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget otpButtonWidget() {
    String otpValue = "";
    return Padding(
      padding: const EdgeInsets.only(top: AppSizes.size8),
      child: PrimaryButton(
        text: "Get OTP",
        width: 90.0,
        onTap: () async {
          homeScreenClickTrack(
            screenName: 'Home',
            componentType: 'Button',
            componentName: 'Get OTP',
            clickedOn: 'Get OTP',
            imageUrl: '',
            iconName: '',
          );
          otpValue = await generateOtp(context);
          showModalBottomSheet(
              backgroundColor: AppColors.secondaryContainerColor,
              context: context,
              isScrollControlled: false,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0)),
              ),
              builder: (context) {
                return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                  return SizedBox(
                    height: screenHeight / 2.8,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Redeem Instore",
                                      style: AppTextStyle.bold16.copyWith(
                                          color: AppColors.blackColor),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: screenWidth - 50,
                                      child: Text(
                                        "Please share this 4 digit code with the cashier to complete your redemption",
                                        style: AppTextStyle.semiBold14.copyWith(
                                            color: AppColors.blackColor),
                                        maxLines: 3,
                                      ),
                                    ),
                                  ]),
                            ],
                          ),
                          const SizedBox(height: 20),
                          FittedBox(
                            child: Container(
                              margin: const EdgeInsets.only(left: 25),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  for (int i = 0; i < otpValue.length; i++)
                                    Text(
                                      otpValue[i] + "         ",
                                      style: AppTextStyle.bold24.copyWith(
                                          color: AppColors.blackColor),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _otpBtnHide
                              ? Container(
                                  alignment: Alignment.center,
                                  height: AppSizes.size60,
                                  width: MediaQuery.of(context).size.width * .5,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: AppColors.blackColor),
                                    borderRadius:
                                        BorderRadius.circular(AppSizes.size30),
                                  ),
                                  child: FittedBox(
                                    child: Countdown(
                                      animation: StepTween(
                                        begin: levelClock,
                                        end: 0,
                                      ).animate(_controller!)
                                        ..addStatusListener((status) {
                                          if (status ==
                                              AnimationStatus.completed) {
                                            setState(() {
                                              _otpBtnHide = false;
                                            });
                                          }
                                        }),
                                    ),
                                  ))
                              : GestureDetector(
                                  onTap: () async {
                                    otpValue = await generateOtp(context);
                                    setState(() {});
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: AppSizes.size60,
                                    width:
                                        MediaQuery.of(context).size.width * .5,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1,
                                          color: AppColors.blackColor),
                                      borderRadius: BorderRadius.circular(
                                          AppSizes.size30),
                                    ),
                                    child: const Text(
                                      'GENERATE NEW OTP',
                                      style: TextStyle(
                                          color: AppColors.blackColor),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  );
                });
              });
        },
        bColor: AppColors.secondaryBackgroundColor,
        height: AppSizes.size34,
      ),
    );
  }

  Widget bannerSliderWidget() {
    var showTitle = false;
    var titleSection = '';
    var showWidget = true;
    for (var i in widget.dashBoardModel.data!.body!) {
      if (i.sectionCode == AppConstString.bannerSlidder) {
        List<Datum> sectionData = [];
        for (var i in i.sectionData[0]['data']) {
          sectionData.add(Datum.fromJson(i));
        }
        showTitle = i.showTitle ?? false;
        titleSection = i.sectionTitle ?? AppConstString.trending;
        showWidget = i.status ?? true;
        bannerSlider.clear();
        for (int i = 0; i < sectionData.length; i++) {
          bannerSlider.add(sectionData[i]);
        }
      }
    }
    return showWidget
        ? Column(
            children: [
              showTitle
                  ? Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.size20),
                      child: Text(
                        titleSection,
                        style: AppTextStyle.regular18
                            .copyWith(fontFamily: 'Bebas'),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(height: 10),
              CarouselSlider(
                carouselController: bannerSliderController,
                options: CarouselOptions(
                    enlargeCenterPage: true,
                    enableInfiniteScroll: true,
                    aspectRatio: 3.0,
                    autoPlay: true,
                    viewportFraction: 0.85,
                    onPageChanged: (index, reason) {
                      setState(() {
                        bannerSlideIndex = index;
                      });
                    }),
                items: List.generate(
                  bannerSlider.length,
                  (index) => GestureDetector(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: CachedNetworkImage(
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                        fit: BoxFit.cover,
                        height: screenHeight,
                        width: screenWidth * 1.2,
                        imageUrl:
                            assetPath + (bannerSlider[index].imgUrl ?? ''),
                      ),
                    ),
                    onTap: () async {
                      homeScreenClickTrack(
                        screenName: 'Home',
                        componentType: 'Banner',
                        componentName: 'Banner',
                        clickedOn: (bannerSlider[index].navigationLink ?? '')
                            .replaceAll(RegExp(r'[/_]|screen'), ''),
                        imageUrl:
                            assetPath + (bannerSlider[index].imgUrl ?? ''),
                        iconName: '',
                      );
                      if (bannerSlider[index].navigationType! ==
                          AppConstString.external) {
                        String link = getExternalLink(
                            bannerSlider[index].navigationLink ?? '');
                        dashboardPresentor.openExternalLink(
                          context,
                          'banner',
                          link,
                        );
                      } else if (bannerSlider[index].navigationLink ==
                          '/spin_the_wheel_screen') {
                        dashboardPresentor.deepLinkNavigationWithEvent(
                            context,
                            'banner',
                            (bannerSlider[index].navigationLink ?? '') +
                                '/false');
                      } else if (bannerSlider[index].navigationType ==
                          AppConstString.website) {
                        dashboardPresentor.openWebLink(
                          'banner',
                          bannerSlider[index].navigationLink ?? '',
                        );
                      } else {
                        dashboardPresentor.deepLinkNavigationWithEvent(
                            context,
                            'banner',
                            (bannerSlider[index].navigationLink ?? '') +
                                '/false');
                      }
                    },
                  ),
                ),
              ),
            ],
          )
        : const SizedBox();
  }

  String getExternalLink(String externalLink) {
    String link = externalLink;
    if (link.contains('{{membership_id}}')) {
      link = link.replaceAll(
          '{{membership_id}}', GlobalSingleton.userInformation.membershipNo!);
    }
    if (link.contains('{{os}}')) {
      link = link.replaceAll('{{os}}', Platform.isAndroid ? 'Android' : 'IOS');
    }
    if (link.contains('{{app_version}}')) {
      link = link.replaceAll('{{app_version}}', GlobalSingleton.appVersion);
    }
    if (GlobalSingleton.currentPosition != null) {
      if (link.contains('{{latitude}}')) {
        link = link.replaceAll('{{latitude}}',
            GlobalSingleton.currentPosition!.latitude.toString());
      }
      if (link.contains('{{longitude}}')) {
        link = link.replaceAll('{{longitude}}',
            GlobalSingleton.currentPosition!.longitude.toString());
      }
    }
    return link;
  }

  Widget featuredOfferWidget() {
    var showTitle = false;
    var showWidget = true;
    var sectionTitle = "";
    var viewType = "";
    var imgType = "";
    var showTab = false;
    List<Datum> sectionItemData = [];
    List<SectionIconData> sectionItemDataIcon = [];
    List<FeaturedOfferSectionData> featuredOfferSectionData = [];

    for (var i in widget.dashBoardModel.data!.body!) {
      if (i.sectionCode == AppConstString.featuredOffers) {
        for (var j in i.sectionData) {
          featuredOfferSectionData.add(FeaturedOfferSectionData.fromJson(j));
        }
        showTab = i.status ?? false;
        showTitle = i.showTitle ?? false;
        showWidget = i.status ?? true;
        sectionTitle = i.sectionTitle ?? AppConstString.featuredText;
        sectionItemData.clear();
        sectionItemDataIcon.clear();
        imgType =
            featuredOfferSectionData[0].data?[0].type ?? AppConstString.image;
        for (var i in i.sectionData[selectedFeaturedOfferIndex]['data']) {
          //featuredOfferSectionData subData
          if (featuredOfferSectionData[0].data?[0].type == 'icon') {
            sectionItemDataIcon.add(SectionIconData.fromJson(i));
          } else if (featuredOfferSectionData[0].data?[0].type ==
              AppConstString.image) {
            sectionItemData.add(Datum.fromJson(i));
          }
        }

        if (featuredOfferSectionData[0]
            .componentType!
            .contains(AppConstString.slider)) {
          viewType = AppConstString.slider;
        } else if (featuredOfferSectionData[0]
            .componentType!
            .contains(AppConstString.grid)) {
          viewType = AppConstString.grid;
        }
      }
    }

    return showWidget
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppSizes.size10,
              ),
              showTitle
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.size20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            sectionTitle,
                            style: AppTextStyle.regular18
                                .copyWith(fontFamily: 'Bebas'),
                          ),
                          InkWell(
                            onTap: () {
                              homeScreenClickTrack(
                                screenName: 'Home',
                                componentType: 'Icon',
                                componentName: 'Featured offer',
                                clickedOn: 'View all',
                                imageUrl: '',
                                iconName: 'View All',
                              );
                              dashboardPresentor.redirectToHome(context, 3);
                            },
                            child: Text(
                              AppConstString.viewAll,
                              style: AppTextStyle.bold14.copyWith(
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              showTab
                  ? SizedBox(
                      height: AppSizes.size50,
                      child: ListView.builder(
                        itemCount: featuredOfferSectionData.length,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.only(
                              left: index == 0 ? AppSizes.size20 : 0,
                              top: 8,
                              bottom: 8,
                              right: 8,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                homeScreenClickTrack(
                                  screenName: 'Home',
                                  componentType: 'Tab',
                                  componentName: 'Featured offer',
                                  clickedOn:
                                      featuredOfferSectionData[index].heading ??
                                          '',
                                  imageUrl: '',
                                  iconName: 'Featured offer tab',
                                );

                                setState(() {
                                  selectedFeaturedOfferIndex = index;
                                  sectionItemData.clear();
                                  sectionItemData = featuredOfferSectionData[
                                              selectedFeaturedOfferIndex]
                                          .data ??
                                      [];
                                  featuredSlideIndex = 0;
                                });
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.size10),
                                decoration: BoxDecoration(
                                  color: index == selectedFeaturedOfferIndex
                                      ? AppColors.whiteColor
                                      : Colors.transparent,
                                  border: Border.all(
                                      width: 1,
                                      color: index == selectedFeaturedOfferIndex
                                          ? AppColors.whiteColor
                                          : AppColors.greyColor),
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Text(
                                  featuredOfferSectionData[index].heading ?? "",
                                  style: AppTextStyle.regular14.copyWith(
                                    color: index == selectedFeaturedOfferIndex
                                        ? AppColors.scaffoldColor
                                        : AppColors.greyColor,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: AppSizes.size10,
              ),
              viewType.contains(AppConstString.slider)
                  ? CarouselSlider(
                      carouselController: featuredController,
                      options: CarouselOptions(
                        aspectRatio: 2,
                        viewportFraction: .4,
                        enableInfiniteScroll: false,
                        disableCenter: false,
                        padEnds: false,
                        onPageChanged: (index, reason) {
                          setState(() {
                            featuredSlideIndex = index;
                          });
                        },
                      ),
                      items: List.generate(
                        sectionItemData.length,
                        (index) => Padding(
                          padding: const EdgeInsets.only(
                              left: AppSizes.size10, right: AppSizes.size20
                              /*(index + 1 == featuredOfferSectionData.length)
                                      ? 20
                                      : 0*/
                              ),
                          child: GestureDetector(
                            onTap: () {
                              homeScreenClickTrack(
                                screenName: 'Home',
                                componentType: 'Slider',
                                componentName: 'Featured offer',
                                clickedOn: 'Slider',
                                imageUrl: getImgOrIconUrl(
                                  imgType: imgType,
                                  index: index,
                                  imageData: sectionItemData,
                                  iconData: sectionItemDataIcon,
                                ),
                                iconName: imgType == AppConstString.image
                                    ? ''
                                    : sectionItemDataIcon[index].iconLabel ??
                                        '',
                              );
                              if (sectionItemData[index].navigationType! ==
                                  AppConstString.external) {
                                dashboardPresentor.openExternalLink(
                                    context,
                                    AppConstString.offersDetails,
                                    sectionItemData[index].navigationLink ??
                                        '');
                              } else if (sectionItemData[index]
                                      .navigationType ==
                                  AppConstString.website) {
                                dashboardPresentor.openWebLink(
                                  AppConstString.offersDetails,
                                  sectionItemData[index].navigationLink ?? '',
                                );
                              } else {
                                dashboardPresentor.deepLinkNavigationWithEvent(
                                    context,
                                    AppConstString.offersDetails,
                                    (sectionItemData[index].navigationLink ??
                                            '') +
                                        '/false');
                              }
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: SizedBox(
                                width: 135.5,
                                child: CachedNetworkImage(
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  imageUrl: getImgOrIconUrl(
                                    imgType: imgType,
                                    index: index,
                                    imageData: sectionItemData,
                                    iconData: sectionItemDataIcon,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : GridView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                      ),
                      children: List.generate(
                        sectionItemData.length,
                        (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              homeScreenClickTrack(
                                screenName: 'Home',
                                componentType: 'Grid',
                                componentName: 'Featured offer',
                                clickedOn: 'Grid',
                                imageUrl: getImgOrIconUrl(
                                  imgType: imgType,
                                  index: index,
                                  imageData: sectionItemData,
                                  iconData: sectionItemDataIcon,
                                ),
                                iconName: imgType == AppConstString.image
                                    ? ''
                                    : sectionItemDataIcon[index].iconLabel ??
                                        '',
                              );

                              if (sectionItemData[index].navigationType! ==
                                  AppConstString.external) {
                                dashboardPresentor.openExternalLink(
                                    context,
                                    AppConstString.offersDetails,
                                    sectionItemData[index].navigationLink ??
                                        '');
                              } else if (sectionItemData[index]
                                      .navigationType ==
                                  AppConstString.website) {
                                dashboardPresentor.openWebLink(
                                  AppConstString.offersDetails,
                                  sectionItemData[index].navigationLink ?? '',
                                );
                              } else {
                                dashboardPresentor.deepLinkNavigationWithEvent(
                                    context,
                                    AppConstString.offersDetails,
                                    (sectionItemData[index].navigationLink ??
                                            '') +
                                        '/false');
                              }
                            },
                            child: CachedNetworkImage(
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.contain,
                              imageUrl: getImgOrIconUrl(
                                imgType: imgType,
                                index: index,
                                imageData: sectionItemData,
                                iconData: sectionItemDataIcon,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
              const SizedBox(
                height: AppSizes.size10,
              ),
              /* viewType.contains(AppConstString.slider)
                  ? sliderCountView(
                      dataList: sectionItemData,
                      controller: featuredController,
                      currentCount: featuredSlideIndex,
                    )
                  : const SizedBox(
                      height: AppSizes.size10,
                    )*/ /// DON'T REMOVE - uncomment this if client again want pagination
            ],
          )
        : const SizedBox(
            height: AppSizes.size10,
          );
  }

  Widget offerOfTheWeekWidget() {
    var showTitle = false;
    var showWidget = true;
    var sectionTitle = "";
    var viewType = "";
    var imgType = "";
    List<Datum> sectionItemData = [];
    List<SectionIconData> sectionItemDataIcon = [];
    List<FeaturedOfferSectionData> offerOfTheWeekSectionData = [];

    for (var i in widget.dashBoardModel.data!.body!) {
      if (i.sectionCode == AppConstString.offerOfTheWeek) {
        for (var j in i.sectionData) {
          offerOfTheWeekSectionData.add(FeaturedOfferSectionData.fromJson(j));
        }
        showTitle = i.showTitle ?? false;
        showWidget = i.status ?? false;
        sectionTitle = i.sectionTitle ?? AppConstString.offerOfWeek;
        sectionItemData.clear();
        sectionItemDataIcon.clear();
        imgType =
            offerOfTheWeekSectionData[0].data?[0].type ?? AppConstString.image;
        for (var i in i.sectionData[0]['data']) {
          if (imgType == 'icon') {
            sectionItemDataIcon.add(SectionIconData.fromJson(i));
          } else if (imgType == AppConstString.image) {
            sectionItemData.add(Datum.fromJson(i));
          }
        }
      }
    }

    if (offerOfTheWeekSectionData[0]
        .componentType!
        .contains(AppConstString.slider)) {
      viewType = AppConstString.slider;
    } else if (offerOfTheWeekSectionData[0]
        .componentType!
        .contains(AppConstString.grid)) {
      viewType = AppConstString.grid;
    }

    return showWidget
        ? Container(
            color: AppColors.moreWithBounzContainerColor,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.backgroundColor,
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: AppSizes.size16,
                  ),
                  showTitle
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppSizes.size20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                sectionTitle,
                                style: AppTextStyle.regular18
                                    .copyWith(fontFamily: 'Bebas'),
                              ),
                              InkWell(
                                onTap: () {
                                  homeScreenClickTrack(
                                    screenName: 'Home',
                                    componentType: 'Icon',
                                    componentName: 'Offer of the week',
                                    clickedOn: 'View all',
                                    imageUrl: '',
                                    iconName: 'View All',
                                  );
                                  dashboardPresentor.redirectToHome(context, 3);
                                },
                                child: Text(
                                  AppConstString.viewAll,
                                  style: AppTextStyle.bold14.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: AppSizes.size10,
                  ),
                  viewType.contains(AppConstString.slider)
                      ? CarouselSlider(
                          carouselController: offerOfTheWeekController,
                          options: CarouselOptions(
                              enlargeCenterPage: true,
                              viewportFraction: imgType == AppConstString.image
                                  ? sectionItemData.length == 1
                                      ? 1
                                      : 0.9
                                  : sectionItemDataIcon.length == 1
                                      ? 1
                                      : 0.9,
                              enableInfiniteScroll: false,
                              disableCenter: true,
                              padEnds: false,
                              height: 190,
                              autoPlay: false,
                              aspectRatio: 1.9,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  offerOfTheWeekIndex = index;
                                });
                              }),
                          items: List.generate(
                            imgType == AppConstString.image
                                ? sectionItemData.length
                                : sectionItemDataIcon.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                  left: (index + 1) ==
                                          (imgType == AppConstString.image
                                              ? sectionItemData.length
                                              : sectionItemDataIcon.length)
                                      ? 0
                                      : index == offerOfTheWeekIndex
                                          ? AppSizes.size20
                                          : 0,
                                  right: (index + 1) ==
                                          (imgType == AppConstString.image
                                              ? sectionItemData.length
                                              : sectionItemDataIcon.length)
                                      ? AppSizes.size20
                                      : 0),
                              child: GestureDetector(
                                onTap: () {
                                  homeScreenClickTrack(
                                    screenName: 'Home',
                                    componentType: 'Slider',
                                    componentName: 'Offer of the week',
                                    clickedOn: 'Slider',
                                    imageUrl: getImgOrIconUrl(
                                      imgType: imgType,
                                      index: index,
                                      imageData: sectionItemData,
                                      iconData: sectionItemDataIcon,
                                    ),
                                    iconName: '',
                                  );
                                  if (imgType == AppConstString.image
                                      ? sectionItemData[index]
                                              .navigationType! ==
                                          AppConstString.external
                                      : sectionItemDataIcon[index]
                                              .navigationType! ==
                                          AppConstString.external) {
                                    dashboardPresentor.openExternalLink(
                                        context,
                                        AppConstString.offersDetails,
                                        imgType == AppConstString.image
                                            ? sectionItemData[index]
                                                    .navigationLink ??
                                                ''
                                            : sectionItemDataIcon[index]
                                                    .navigationLink ??
                                                '');
                                  } else if (imgType == AppConstString.image
                                      ? sectionItemData[index].navigationType ==
                                          AppConstString.website
                                      : sectionItemDataIcon[index]
                                              .navigationType ==
                                          AppConstString.website) {
                                    dashboardPresentor.openWebLink(
                                      AppConstString.offersDetails,
                                      imgType == AppConstString.image
                                          ? sectionItemData[index]
                                                  .navigationLink ??
                                              ''
                                          : sectionItemDataIcon[index]
                                                  .navigationLink ??
                                              '',
                                    );
                                  } else {
                                    imgType == AppConstString.image
                                        ? dashboardPresentor
                                            .deepLinkNavigationWithEvent(
                                                context,
                                                AppConstString.offersDetails,
                                                (sectionItemData[index]
                                                            .navigationLink ??
                                                        '') +
                                                    '/false')
                                        : dashboardPresentor
                                            .deepLinkNavigationWithEvent(
                                                context,
                                                AppConstString.offersDetails,
                                                (sectionItemDataIcon[index]
                                                            .navigationLink ??
                                                        '') +
                                                    '/false');
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                    imageUrl: getImgOrIconUrl(
                                      imgType: imgType,
                                      index: index,
                                      imageData: sectionItemData,
                                      iconData: sectionItemDataIcon,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : GridView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                          ),
                          children: List.generate(
                            imgType == AppConstString.image
                                ? sectionItemData.length
                                : sectionItemDataIcon.length,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  homeScreenClickTrack(
                                    screenName: 'Home',
                                    componentType: 'Grid',
                                    componentName: 'Offer of the week',
                                    clickedOn: 'Slider',
                                    imageUrl: getImgOrIconUrl(
                                      imgType: imgType,
                                      index: index,
                                      imageData: sectionItemData,
                                      iconData: sectionItemDataIcon,
                                    ),
                                    iconName: '',
                                  );
                                  if (imgType == AppConstString.image
                                      ? sectionItemData[index]
                                              .navigationType! ==
                                          AppConstString.external
                                      : sectionItemDataIcon[index]
                                              .navigationType! ==
                                          AppConstString.external) {
                                    dashboardPresentor.openExternalLink(
                                        context,
                                        AppConstString.offersDetails,
                                        imgType == AppConstString.image
                                            ? sectionItemData[index]
                                                    .navigationLink ??
                                                ''
                                            : sectionItemDataIcon[index]
                                                    .navigationLink ??
                                                '');
                                  } else if (imgType == AppConstString.image
                                      ? sectionItemData[index].navigationType ==
                                          AppConstString.website
                                      : sectionItemData[index].navigationType ==
                                          AppConstString.website) {
                                    dashboardPresentor.openWebLink(
                                      AppConstString.offersDetails,
                                      imgType == AppConstString.image
                                          ? sectionItemData[index]
                                                  .navigationLink ??
                                              ''
                                          : sectionItemDataIcon[index]
                                                  .navigationLink ??
                                              '',
                                    );
                                  } else {
                                    imgType == AppConstString.image
                                        ? dashboardPresentor
                                            .deepLinkNavigationWithEvent(
                                                context,
                                                AppConstString.offersDetails,
                                                (sectionItemData[index]
                                                            .navigationLink ??
                                                        '') +
                                                    '/false')
                                        : dashboardPresentor
                                            .deepLinkNavigationWithEvent(
                                                context,
                                                AppConstString.offersDetails,
                                                (sectionItemDataIcon[index]
                                                            .navigationLink ??
                                                        '') +
                                                    '/false');
                                  }
                                },
                                child: CachedNetworkImage(
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.contain,
                                  imageUrl: getImgOrIconUrl(
                                    imgType: imgType,
                                    index: index,
                                    imageData: sectionItemData,
                                    iconData: sectionItemDataIcon,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  Widget moreWithBounzWidget() {
    var showTitle = false;
    var showWidget = true;
    var sectionTitle = "";
    var viewType = "";
    var imgType = "";
    List<SectionIconData> sectionItemDataIcon = [];
    List<FeaturedOfferSectionData> moreWidBounzSectionData = [];
    List<Datum> sectionItemData = [];
    for (var i in widget.dashBoardModel.data!.body!) {
      if (i.sectionCode == AppConstString.moreWithBounz) {
        for (var j in i.sectionData) {
          moreWidBounzSectionData.add(FeaturedOfferSectionData.fromJson(j));
        }
        showTitle = i.showTitle ?? false;
        showWidget = i.status ?? false;
        sectionTitle = i.sectionTitle ?? AppConstString.moreBounz;
        sectionItemDataIcon.clear();
        imgType =
            moreWidBounzSectionData[0].data?[0].type ?? AppConstString.image;
        for (var i in i.sectionData[0]['data']) {
          if (moreWidBounzSectionData[0].data?[0].type == 'icon') {
            sectionItemDataIcon.add(SectionIconData.fromJson(i));
          } else if (moreWidBounzSectionData[0].data?[0].type ==
              AppConstString.image) {
            sectionItemData.add(Datum.fromJson(i));
          }
        }
      }
    }

    if (moreWidBounzSectionData[0]
        .componentType!
        .contains(AppConstString.slider)) {
      viewType = AppConstString.slider;
    } else if (moreWidBounzSectionData[0]
        .componentType!
        .contains(AppConstString.grid)) {
      viewType = AppConstString.grid;
    }

    return showWidget
        ? Container(
            decoration: const BoxDecoration(
              color: AppColors.moreWithBounzContainerColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppSizes.size40),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 30,
                  color: AppColors.moreWithBounzContainerColor,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(AppSizes.size40),
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.moreWithBounzContainerColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppSizes.size40),
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                showTitle
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.size20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              sectionTitle,
                              style: AppTextStyle.regular18
                                  .copyWith(fontFamily: 'Bebas'),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                // const SizedBox(
                //   height: AppSizes.size10,
                // ),
                viewType.contains(AppConstString.slider)
                    ? CarouselSlider(
                        carouselController: moreWithBounzController,
                        options: CarouselOptions(
                            aspectRatio: 1.9,
                            viewportFraction: .45,
                            enableInfiniteScroll: false,
                            disableCenter: false,
                            onPageChanged: (index, reason) {}),
                        items: List.generate(
                          sectionItemDataIcon.length,
                          (index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                String iconLabel =
                                    sectionItemDataIcon[index].iconLabel ?? "";
                                homeScreenClickTrack(
                                  screenName: 'Home',
                                  componentType: 'Slider',
                                  componentName: 'More with bounz',
                                  clickedOn: '$iconLabel icon',
                                  imageUrl: '',
                                  iconName: iconLabel,
                                );
                                if (sectionItemDataIcon[index].navigationType ==
                                    AppConstString.external) {
                                  dashboardPresentor.openExternalLink(
                                      context,
                                      'More with bounz',
                                      sectionItemDataIcon[index]
                                              .navigationLink ??
                                          '');
                                } else {
                                  if ((sectionItemDataIcon[index].iconLabel ??
                                          "") ==
                                      AppConstString.travel) {
                                    MoenageManager.logScreenEvent(
                                        name: 'My Travel');
                                    AutoRouter.of(context).push(
                                      MyTravelScreenRoute(
                                        apiPath: ApiPath.travelMoreWidBounz,
                                      ),
                                    );
                                  } else if ((sectionItemDataIcon[index]
                                              .iconLabel ??
                                          "") ==
                                      AppConstString.giftCards) {
                                    MoenageManager.logScreenEvent(
                                        name: 'Buy Gift Cards');
                                    AutoRouter.of(context).push(
                                      BuyGiftCardsScreenRoute(),
                                    );
                                  } else if ((sectionItemDataIcon[index]
                                              .iconLabel ??
                                          "") ==
                                      AppConstString.rechargeMobileN) {
                                    dashboardPresentor
                                        .deepLinkNavigationWithEvent(
                                            context,
                                            'Pay Bill Details',
                                            '/pay_bill_screen/1/Mobile/false');
                                  } else if ((sectionItemDataIcon[index]
                                              .iconLabel ??
                                          "") ==
                                      AppConstString.electricityBillN) {
                                    dashboardPresentor.deepLinkNavigationWithEvent(
                                        context,
                                        'Pay Bill Details',
                                        '/pay_bill_screen/3/Electricity/false');
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.dashboardBgColor,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: CachedNetworkImage(
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.contain,
                                  imageUrl: getImgOrIconUrl(
                                    imgType: imgType,
                                    index: index,
                                    imageData: sectionItemData,
                                    iconData: sectionItemDataIcon,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : GridView(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                        ),
                        padding: EdgeInsets.zero,
                        children: List.generate(
                          sectionItemDataIcon.length,
                          (index) => moreBounzDecoration(
                            imagePath: imgType == AppConstString.image
                                ? (sectionItemData[index].imgUrl ?? "")
                                        .contains('[')
                                    ? sectionItemData[index].imgUrl ?? ""
                                    : assetPath +
                                        (sectionItemData[index].imgUrl ?? "")
                                : (sectionItemDataIcon[index].iconUrl ?? '')
                                        .contains('[')
                                    ? sectionItemDataIcon[index].iconUrl ?? ""
                                    : assetPath +
                                        (sectionItemDataIcon[index].iconUrl ??
                                            ""),
                            title: (sectionItemDataIcon[index].iconLabel ?? ""),
                            onTap: () {
                              String iconLabel =
                                  sectionItemDataIcon[index].iconLabel ?? "";
                              homeScreenClickTrack(
                                screenName: 'Home',
                                componentType: 'Grid',
                                componentName: 'More with bounz',
                                clickedOn: '$iconLabel icon',
                                imageUrl: '',
                                iconName: iconLabel,
                              );
                              if (sectionItemDataIcon[index].navigationType ==
                                  AppConstString.external) {
                                dashboardPresentor.openExternalLink(
                                    context,
                                    'More with bounz',
                                    sectionItemDataIcon[index].navigationLink ??
                                        '');
                              } else {
                                if ((sectionItemDataIcon[index].iconLabel ??
                                        "") ==
                                    AppConstString.travel) {
                                  MoenageManager.logScreenEvent(
                                      name: 'My Travel');
                                  AutoRouter.of(context).push(
                                    MyTravelScreenRoute(
                                      apiPath: ApiPath.travelMoreWidBounz,
                                    ),
                                  );
                                } else if ((sectionItemDataIcon[index]
                                            .iconLabel ??
                                        "") ==
                                    AppConstString.giftCards) {
                                  MoenageManager.logScreenEvent(
                                      name: 'Buy Gift Cards');
                                  AutoRouter.of(context).push(
                                    BuyGiftCardsScreenRoute(),
                                  );
                                } else if ((sectionItemDataIcon[index]
                                            .iconLabel ??
                                        "") ==
                                    AppConstString.rechargeMobileN) {
                                  MoenageManager.logScreenEvent(
                                      name: 'Pay Bill Details');
                                  AutoRouter.of(context).pushNamed(
                                      '/pay_bill_screen/1/Mobile/false');
                                } else if ((sectionItemDataIcon[index]
                                            .iconLabel ??
                                        "") ==
                                    AppConstString.electricityBillN) {
                                  MoenageManager.logScreenEvent(
                                      name: 'Pay Bill Details');
                                  AutoRouter.of(context).pushNamed(
                                      '/pay_bill_screen/3/Electricity/false');
                                }
                              }
                            },
                          ),
                        )),
                const SizedBox(
                  height: AppSizes.size10,
                ),
                viewType.contains(AppConstString.slider)
                    ? sliderCountView(
                        dataList: sectionItemDataIcon,
                        controller: featuredController,
                        currentCount: featuredSlideIndex,
                      )
                    : const SizedBox(
                        height: AppSizes.size10,
                      ),
              ],
            ),
          )
        : const SizedBox();
  }

  Widget trendingPartnerWidget() {
    var showTitle = false;
    var showWidget = true;
    var sectionTitle = "";
    var viewType = "";
    var imgType = "";
    List<Datum> sectionItemData = [];
    List<SectionIconData> sectionItemDataIcon = [];
    List<SectionData> trendingPartners = [];

    for (var i in widget.dashBoardModel.data!.body!) {
      if (i.sectionCode == AppConstString.trendingPartners) {
        for (var j in i.sectionData) {
          trendingPartners.add(SectionData.fromJson(j));
        }
        showTitle = i.showTitle ?? false;
        showWidget = i.status ?? false;
        sectionTitle = i.sectionTitle ?? AppConstString.moreBounz;
        sectionItemData.clear();
        sectionItemDataIcon.clear();
        imgType = trendingPartners[0].data?[0].type ?? AppConstString.image;
        for (var i in i.sectionData[0]['data']) {
          if (trendingPartners[0].data?[0].type == 'icon') {
            sectionItemDataIcon.add(SectionIconData.fromJson(i));
          } else if (trendingPartners[0].data?[0].type ==
              AppConstString.image) {
            sectionItemData.add(Datum.fromJson(i));
          }
        }
      }
    }

    if (trendingPartners[0].componentType!.contains(AppConstString.slider)) {
      viewType = AppConstString.slider;
    } else if (trendingPartners[0]
        .componentType!
        .contains(AppConstString.grid)) {
      viewType = AppConstString.grid;
    }

    return showWidget
        ? Container(
            color: AppColors.primaryContainerColor,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.backgroundColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppSizes.size40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  showTitle
                      ? Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.size20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                sectionTitle,
                                style: AppTextStyle.regular18
                                    .copyWith(fontFamily: 'Bebas'),
                              ),
                              InkWell(
                                onTap: () {
                                  homeScreenClickTrack(
                                    screenName: 'Home',
                                    componentType: 'Icon',
                                    componentName: 'Trending partners',
                                    clickedOn: 'View all',
                                    imageUrl: '',
                                    iconName: 'View all',
                                  );
                                  dashboardPresentor.redirectToHome(context, 1);
                                },
                                child: Text(
                                  AppConstString.viewAll,
                                  style: AppTextStyle.bold14.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: AppSizes.size10,
                  ),
                  Column(
                    children: [
                      viewType.contains(AppConstString.slider)
                          ? Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: CarouselSlider(
                                carouselController: trendingImagesController,
                                options: CarouselOptions(
                                    height: 190,
                                    autoPlay: false,
                                    aspectRatio: 1.9,
                                    viewportFraction: .45,
                                    enableInfiniteScroll: false,
                                    disableCenter: false,
                                    padEnds: false,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        trendingSlideIndex = index;
                                      });
                                    }),
                                items: imgType == AppConstString.image
                                    ? sectionItemData
                                        .map(
                                          (item) => InkWell(
                                            onTap: () {
                                              homeScreenClickTrack(
                                                screenName: 'Home',
                                                componentType: 'Slider',
                                                componentName:
                                                    'Trending partners',
                                                clickedOn: 'Image',
                                                imageUrl: assetPath +
                                                    (item.imgUrl ?? ""),
                                                iconName: '',
                                              );
                                              if (item.navigationType! ==
                                                  AppConstString.external) {
                                                dashboardPresentor
                                                    .openExternalLink(
                                                        context,
                                                        AppConstString
                                                            .partnerDetails,
                                                        item.navigationLink ??
                                                            '');
                                              } else if (item.navigationType ==
                                                  AppConstString.website) {
                                                dashboardPresentor.openWebLink(
                                                  AppConstString.partnerDetails,
                                                  item.navigationLink ?? '',
                                                );
                                              } else {
                                                dashboardPresentor
                                                    .deepLinkNavigationWithEvent(
                                                  context,
                                                  AppConstString.partnerDetails,
                                                  '${item.navigationLink}/false',
                                                );
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: AppSizes.size16,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                  imageUrl: assetPath +
                                                      (item.imgUrl ?? ""),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList()
                                    : sectionItemDataIcon
                                        .map(
                                          (item) => InkWell(
                                            onTap: () {
                                              homeScreenClickTrack(
                                                screenName: 'Home',
                                                componentType: 'Slider',
                                                componentName:
                                                    'Trending partners',
                                                clickedOn: 'Icon',
                                                imageUrl: assetPath +
                                                    (item.iconUrl ?? ""),
                                                iconName: item.iconLabel ?? '',
                                              );

                                              if (item.navigationType! ==
                                                  AppConstString.external) {
                                                dashboardPresentor
                                                    .openExternalLink(
                                                        context,
                                                        AppConstString
                                                            .partnerDetails,
                                                        item.navigationLink ??
                                                            '');
                                              } else if (item.navigationType ==
                                                  AppConstString.website) {
                                                dashboardPresentor.openWebLink(
                                                  AppConstString.partnerDetails,
                                                  item.navigationLink ?? '',
                                                );
                                              } else {
                                                dashboardPresentor
                                                    .deepLinkNavigationWithEvent(
                                                  context,
                                                  AppConstString.partnerDetails,
                                                  '${item.navigationLink}/false',
                                                );
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: AppSizes.size16,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: CachedNetworkImage(
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                  imageUrl: assetPath +
                                                      (item.iconUrl ?? ""),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            )
                          : GridView(
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 4),
                              children: List.generate(
                                imgType == AppConstString.image
                                    ? sectionItemData.length
                                    : sectionItemDataIcon.length,
                                (index) => topStoriesItems(
                                  imagePath: getImgOrIconUrl(
                                    imgType: imgType,
                                    index: index,
                                    imageData: sectionItemData,
                                    iconData: sectionItemDataIcon,
                                  ),
                                  title: (sectionItemData[index].imgDesc ?? ""),
                                  onTap: () async {
                                    homeScreenClickTrack(
                                      screenName: 'Home',
                                      componentType: 'Grid',
                                      componentName: 'Trending partners',
                                      clickedOn: 'Trending partners Image',
                                      imageUrl: getImgOrIconUrl(
                                        imgType: imgType,
                                        index: index,
                                        imageData: sectionItemData,
                                        iconData: sectionItemDataIcon,
                                      ),
                                      iconName: '',
                                    );
                                    if (imgType != AppConstString.image) {
                                      if (sectionItemDataIcon[index]
                                              .navigationType ==
                                          AppConstString.external) {
                                        dashboardPresentor.openExternalLink(
                                            context,
                                            AppConstString.partnerDetails,
                                            sectionItemDataIcon[index]
                                                    .navigationLink ??
                                                '');
                                      } else if (sectionItemDataIcon[index]
                                              .navigationType ==
                                          AppConstString.website) {
                                        dashboardPresentor.openWebLink(
                                          AppConstString.partnerDetails,
                                          sectionItemDataIcon[index]
                                                  .navigationLink ??
                                              '',
                                        );
                                      } else {
                                        dashboardPresentor
                                            .deepLinkNavigationWithEvent(
                                          context,
                                          AppConstString.partnerDetails,
                                          '${sectionItemDataIcon[index].navigationLink}/false',
                                        );
                                      }
                                    } else {
                                      if (sectionItemData[index]
                                              .navigationType ==
                                          AppConstString.external) {
                                        dashboardPresentor.openExternalLink(
                                            context,
                                            AppConstString.partnerDetails,
                                            sectionItemData[index]
                                                    .navigationLink ??
                                                '');
                                      } else if (sectionItemData[index]
                                              .navigationType ==
                                          AppConstString.website) {
                                        dashboardPresentor.openWebLink(
                                          AppConstString.partnerDetails,
                                          sectionItemData[index]
                                                  .navigationLink ??
                                              '',
                                        );
                                      } else {
                                        dashboardPresentor
                                            .deepLinkNavigationWithEvent(
                                          context,
                                          AppConstString.partnerDetails,
                                          '${sectionItemData[index].navigationLink}/false',
                                        );
                                      }
                                    }
                                  },
                                ),
                              )),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      /*  sliderCountView(
                        dataList: sectionItemData,
                        controller: trendingImagesController,
                        currentCount: trendingSlideIndex,
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),*/ /// DON'T REMOVE - uncomment this if client again want pagination
                    ],
                  )
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  Widget dynamicWidgetFromCMS(Body body) {
    var showTitle = false;
    var showWidget = true;
    var sectionTitle = "";
    var viewType = "";
    var imgType = "";
    List<Datum> sectionItemData = [];
    List<SectionIconData> sectionItemDataIcon = [];
    List<SectionData> dynamicSectionData = [];

    if (!body.sectionCode!.contains('video_sec') &&
        !body.sectionCode!.contains('counter_sec')) {
      for (var j in body.sectionData) {
        dynamicSectionData.add(SectionData.fromJson(j));
      }
      showTitle = body.showTitle ?? false;
      showWidget = body.status ?? false;
      sectionTitle = body.sectionTitle ?? AppConstString.moreBounz;
      sectionItemData.clear();
      sectionItemDataIcon.clear();
      imgType = dynamicSectionData[0].data?[0].type ?? AppConstString.image;

      for (var i in body.sectionData[0]['data']) {
        if (dynamicSectionData[0].data?[0].type == 'icon') {
          sectionItemDataIcon.add(SectionIconData.fromJson(i));
        } else if (dynamicSectionData[0].data?[0].type ==
            AppConstString.image) {
          sectionItemData.add(Datum.fromJson(i));
        }
      }
      if (body.componentType == AppConstString.slider) {
        viewType = AppConstString.slider;
      } else if (body.componentType == AppConstString.grid) {
        viewType = AppConstString.grid;
      }
    } else {
      showWidget = false;
    }

    return showWidget
        ? SizedBox(
            height: 260,
            child: Column(
              children: [
                const SizedBox(
                  height: AppSizes.size20,
                ),
                showTitle
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.size20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              sectionTitle,
                              style: AppTextStyle.regular18
                                  .copyWith(fontFamily: 'Bebas'),
                            ),
                            InkWell(
                              onTap: () {
                                if (body.extraData?.viewAll != null) {
                                  homeScreenClickTrack(
                                    screenName: 'Home',
                                    componentType: 'Icon',
                                    componentName: sectionTitle,
                                    clickedOn: 'View all',
                                    imageUrl: '',
                                    iconName: 'View All',
                                  );
                                  dashboardPresentor
                                      .deepLinkNavigationWithEvent(
                                    context,
                                    sectionTitle,
                                    '${body.extraData!.viewAll}/false',
                                  );
                                }
                              },
                              child: Text(
                                AppConstString.viewAll,
                                style: AppTextStyle.bold14.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: AppSizes.size10,
                ),
                SizedBox(
                  height: 180,
                  child: viewType.contains(AppConstString.slider)
                      ? CarouselSlider(
                          carouselController: dynamicController,
                          options: CarouselOptions(
                              height: 190,
                              enlargeCenterPage: false,
                              viewportFraction: 0.9,
                              enableInfiniteScroll: false,
                              disableCenter: true,
                              padEnds: false,
                              autoPlay: false,
                              aspectRatio: 1.9,
                              onPageChanged: (i, reason) {}),
                          items: List.generate(
                            imgType == AppConstString.image
                                ? sectionItemData.length
                                : sectionItemDataIcon.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                  left: index == 0
                                      ? AppSizes.size20
                                      : AppSizes.size20,
                                  right: (index + 1) ==
                                          (imgType == AppConstString.image
                                              ? sectionItemData.length
                                              : sectionItemDataIcon.length)
                                      ? AppSizes.size20
                                      : 0),
                              child: InkWell(
                                onTap: () async {
                                  String? url =
                                      sectionItemData[index].navigationLink;
                                  if (url != null) {
                                    Uri uri = Uri.parse(url);
                                    final properties1 = MoEProperties();
                                    properties1
                                        .addAttribute(
                                          TriggeringCondition.utmMedium,
                                          uri.queryParameters['utm_medium'] ??
                                              '',
                                        )
                                        .addAttribute(
                                          TriggeringCondition.utmSource,
                                          uri.queryParameters['utm_source'] ??
                                              '',
                                        )
                                        .addAttribute(
                                          TriggeringCondition.utmCampaign,
                                          uri.queryParameters['utm_campaign'] ??
                                              '',
                                        )
                                        .setNonInteractiveEvent();
                                    MoenageManager.logEvent(
                                      MoenageEvent.affiliateSelected,
                                      properties: properties1,
                                    );
                                    homeScreenClickTrack(
                                      screenName: 'Home',
                                      componentType: 'Slider',
                                      componentName: sectionTitle,
                                      clickedOn: 'Image',
                                      imageUrl: assetPath +
                                          (sectionItemData[index].imgUrl ?? ""),
                                      iconName: '',
                                    );
                                    if (imgType == AppConstString.image
                                        ? sectionItemData[index]
                                                .navigationType! ==
                                            AppConstString.external
                                        : sectionItemDataIcon[index]
                                                .navigationType! ==
                                            AppConstString.external) {
                                      dashboardPresentor.openExternalLink(
                                          context,
                                          sectionTitle,
                                          imgType == AppConstString.image
                                              ? sectionItemData[index]
                                                      .navigationLink ??
                                                  ''
                                              : sectionItemDataIcon[index]
                                                      .navigationLink ??
                                                  '');
                                    } else if (imgType == AppConstString.image
                                        ? sectionItemData[index]
                                                .navigationType ==
                                            AppConstString.website
                                        : sectionItemDataIcon[index]
                                                .navigationType ==
                                            AppConstString.website) {
                                      dashboardPresentor.openWebLink(
                                        AppConstString.partnerDetails,
                                        imgType == AppConstString.image
                                            ? sectionItemData[index]
                                                    .navigationLink ??
                                                ''
                                            : sectionItemDataIcon[index]
                                                    .navigationLink ??
                                                '',
                                      );
                                    } else {
                                      imgType == AppConstString.image
                                          ? dashboardPresentor
                                              .deepLinkNavigationWithEvent(
                                              context,
                                              sectionTitle,
                                              '${sectionItemData[index].navigationLink}/false',
                                            )
                                          : dashboardPresentor
                                              .deepLinkNavigationWithEvent(
                                              context,
                                              sectionTitle,
                                              '${sectionItemDataIcon[index].navigationLink}/false',
                                            );
                                    }
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.fill,
                                    width: MediaQuery.of(context).size.width *
                                        0.86,
                                    imageUrl: assetPath +
                                        (sectionItemData[index].imgUrl ?? ""),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : GridView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          children: List.generate(
                            sectionItemData.length,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  String? url =
                                      sectionItemData[index].navigationLink;
                                  if (url != null) {
                                    Uri uri = Uri.parse(url);

                                    final properties1 = MoEProperties();
                                    properties1
                                        .addAttribute(
                                            TriggeringCondition.utmMedium,
                                            uri.queryParameters['utm_medium'] ??
                                                '')
                                        .addAttribute(
                                            TriggeringCondition.utmSource,
                                            uri.queryParameters['utm_source'] ??
                                                '')
                                        .addAttribute(
                                            TriggeringCondition.utmCampaign,
                                            uri.queryParameters[
                                                    'utm_campaign'] ??
                                                '')
                                        .setNonInteractiveEvent();
                                    MoenageManager.logEvent(
                                      MoenageEvent.affiliateSelected,
                                      properties: properties1,
                                    );
                                    homeScreenClickTrack(
                                      screenName: 'Home',
                                      componentType: 'Grid',
                                      componentName: sectionTitle,
                                      clickedOn: 'Image',
                                      imageUrl: getImgOrIconUrl(
                                        imgType: imgType,
                                        index: index,
                                        imageData: sectionItemData,
                                        iconData: sectionItemDataIcon,
                                      ),
                                      iconName: imgType == AppConstString.image
                                          ? ''
                                          : sectionItemDataIcon[index]
                                                  .iconLabel ??
                                              '',
                                    );
                                    if (imgType == AppConstString.image
                                        ? sectionItemData[index]
                                                .navigationType! ==
                                            AppConstString.external
                                        : sectionItemDataIcon[index]
                                                .navigationType! ==
                                            AppConstString.external) {
                                      dashboardPresentor.openExternalLink(
                                          context,
                                          sectionTitle,
                                          imgType == AppConstString.image
                                              ? sectionItemData[index]
                                                      .navigationLink ??
                                                  ''
                                              : sectionItemDataIcon[index]
                                                      .navigationLink ??
                                                  '');
                                    } else if (imgType == AppConstString.image
                                        ? sectionItemData[index]
                                                .navigationType ==
                                            AppConstString.website
                                        : sectionItemDataIcon[index]
                                                .navigationType ==
                                            AppConstString.website) {
                                      dashboardPresentor.openWebLink(
                                        sectionTitle,
                                        imgType == AppConstString.image
                                            ? sectionItemData[index]
                                                    .navigationLink ??
                                                ''
                                            : sectionItemDataIcon[index]
                                                    .navigationLink ??
                                                '',
                                      );
                                    } else {
                                      MoenageManager.logScreenEvent(
                                          name: AppConstString.partnerDetails);
                                      imgType == AppConstString.image
                                          ? AutoRouter.of(context).pushNamed(
                                              "${sectionItemData[index].navigationLink}/false",
                                            )
                                          : AutoRouter.of(context).pushNamed(
                                              '${sectionItemDataIcon[index].navigationLink}/false',
                                            );
                                    }
                                  }
                                },
                                child: CachedNetworkImage(
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.contain,
                                  height: 50,
                                  imageUrl: getImgOrIconUrl(
                                    imgType: imgType,
                                    index: index,
                                    imageData: sectionItemData,
                                    iconData: sectionItemDataIcon,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  Widget affiliatePartnerBannerWidget() {
    var showTitle = false;
    var showWidget = true;
    var sectionTitle = "";
    var viewType = "";
    var imgType = "";
    List<Datum> sectionItemData = [];
    List<SectionIconData> sectionItemDataIcon = [];
    List<SectionData> trendingPartners = [];

    for (var i in widget.dashBoardModel.data!.body!) {
      if (i.sectionCode == AppConstString.affiliatePartners) {
        for (var j in i.sectionData) {
          trendingPartners.add(SectionData.fromJson(j));
        }
        showTitle = i.showTitle ?? false;
        showWidget = i.status ?? false;
        sectionTitle = i.sectionTitle ?? AppConstString.moreBounz;
        sectionItemData.clear();
        sectionItemDataIcon.clear();
        imgType = trendingPartners[0].data?[0].type ?? AppConstString.image;
        for (var i in i.sectionData[0]['data']) {
          if (trendingPartners[0].data?[0].type == 'icon') {
            sectionItemDataIcon.add(SectionIconData.fromJson(i));
          } else if (trendingPartners[0].data?[0].type ==
              AppConstString.image) {
            sectionItemData.add(Datum.fromJson(i));
          }
        }
      }
      if (i.componentType == AppConstString.slider) {
        viewType = AppConstString.slider;
      } else if (i.componentType == AppConstString.grid) {
        viewType = AppConstString.grid;
      }
    }

    return showWidget
        ? Container(
            height: 260,
            decoration: const BoxDecoration(
              color: AppColors.primaryContainerColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppSizes.size40),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: AppSizes.size20,
                ),
                showTitle
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.size20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              sectionTitle,
                              style: AppTextStyle.regular18
                                  .copyWith(fontFamily: 'Bebas'),
                            ),
                            InkWell(
                              onTap: () {
                                homeScreenClickTrack(
                                  screenName: 'Home',
                                  componentType: 'Icon',
                                  componentName: 'Affiliate Partners',
                                  clickedOn: 'View all',
                                  imageUrl: '',
                                  iconName: 'View all',
                                );
                                dashboardPresentor.redirectToHome(context, 1);
                              },
                              child: Text(
                                AppConstString.viewAll,
                                style: AppTextStyle.bold14.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: AppSizes.size10,
                ),
                SizedBox(
                  height: 180,
                  child: viewType.contains(AppConstString.slider)
                      ? CarouselSlider(
                          carouselController: affiliatePartnerController,
                          options: CarouselOptions(
                              height: 190,
                              enlargeCenterPage: false,
                              viewportFraction: 0.9,
                              enableInfiniteScroll: false,
                              disableCenter: true,
                              padEnds: false,
                              autoPlay: false,
                              aspectRatio: 1.9,
                              onPageChanged: (i, reason) {}),
                          items: List.generate(
                            imgType == AppConstString.image
                                ? sectionItemData.length
                                : sectionItemDataIcon.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                  left: index == 0
                                      ? AppSizes.size20
                                      : AppSizes.size20,
                                  right: (index + 1) ==
                                          (imgType == AppConstString.image
                                              ? sectionItemData.length
                                              : sectionItemDataIcon.length)
                                      ? AppSizes.size20
                                      : 0),
                              child: InkWell(
                                onTap: () async {
                                  String? url =
                                      sectionItemData[index].navigationLink;
                                  if (url != null) {
                                    Uri uri = Uri.parse(url);
                                    final properties1 = MoEProperties();
                                    properties1
                                        .addAttribute(
                                          TriggeringCondition.utmMedium,
                                          uri.queryParameters['utm_medium'] ??
                                              '',
                                        )
                                        .addAttribute(
                                          TriggeringCondition.utmSource,
                                          uri.queryParameters['utm_source'] ??
                                              '',
                                        )
                                        .addAttribute(
                                          TriggeringCondition.utmCampaign,
                                          uri.queryParameters['utm_campaign'] ??
                                              '',
                                        )
                                        .setNonInteractiveEvent();
                                    MoenageManager.logEvent(
                                      MoenageEvent.affiliateSelected,
                                      properties: properties1,
                                    );

                                    homeScreenClickTrack(
                                      screenName: 'Home',
                                      componentType: 'SLider',
                                      componentName: 'Affiliate Partners',
                                      clickedOn: 'Image',
                                      imageUrl: assetPath +
                                          (sectionItemData[index].imgUrl ?? ""),
                                      iconName: '',
                                    );
                                    if (sectionItemData[index]
                                            .navigationType! ==
                                        AppConstString.external) {
                                      dashboardPresentor.openExternalLink(
                                          context,
                                          AppConstString.partnerDetails,
                                          imgType == AppConstString.image
                                              ? sectionItemData[index]
                                                      .navigationLink ??
                                                  ''
                                              : sectionItemDataIcon[index]
                                                      .navigationLink ??
                                                  '');
                                    } else if (sectionItemData[index]
                                            .navigationType ==
                                        AppConstString.website) {
                                      dashboardPresentor.openWebLink(
                                        AppConstString.partnerDetails,
                                        imgType == AppConstString.image
                                            ? sectionItemData[index]
                                                    .navigationLink ??
                                                ''
                                            : sectionItemDataIcon[index]
                                                    .navigationLink ??
                                                '',
                                      );
                                    } else {
                                      imgType == AppConstString.image
                                          ? dashboardPresentor
                                              .deepLinkNavigationWithEvent(
                                              context,
                                              AppConstString.partnerDetails,
                                              '${sectionItemData[index].navigationLink}/false',
                                            )
                                          : dashboardPresentor
                                              .deepLinkNavigationWithEvent(
                                              context,
                                              AppConstString.partnerDetails,
                                              '${sectionItemDataIcon[index].navigationLink}/false',
                                            );
                                    }
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.fill,
                                    width: MediaQuery.of(context).size.width *
                                        0.86,
                                    imageUrl: assetPath +
                                        (sectionItemData[index].imgUrl ?? ""),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : GridView(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3),
                          children: List.generate(
                            sectionItemData.length,
                            (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  String? url =
                                      sectionItemData[index].navigationLink;
                                  if (url != null) {
                                    Uri uri = Uri.parse(url);
                                    final properties1 = MoEProperties();
                                    properties1
                                        .addAttribute(
                                          TriggeringCondition.utmMedium,
                                          uri.queryParameters['utm_medium'] ??
                                              '',
                                        )
                                        .addAttribute(
                                          TriggeringCondition.utmSource,
                                          uri.queryParameters['utm_source'] ??
                                              '',
                                        )
                                        .addAttribute(
                                          TriggeringCondition.utmCampaign,
                                          uri.queryParameters['utm_campaign'] ??
                                              '',
                                        )
                                        .setNonInteractiveEvent();
                                    MoenageManager.logEvent(
                                      MoenageEvent.affiliateSelected,
                                      properties: properties1,
                                    );
                                    homeScreenClickTrack(
                                      screenName: 'Home',
                                      componentType: 'Grid',
                                      componentName: 'Affiliate Partners',
                                      clickedOn: 'Image',
                                      imageUrl: getImgOrIconUrl(
                                        imgType: imgType,
                                        index: index,
                                        imageData: sectionItemData,
                                        iconData: sectionItemDataIcon,
                                      ),
                                      iconName: imgType == AppConstString.image
                                          ? ""
                                          : sectionItemDataIcon[index]
                                                  .iconLabel ??
                                              "",
                                    );
                                    if (sectionItemData[index]
                                            .navigationType! ==
                                        AppConstString.external) {
                                      dashboardPresentor.openExternalLink(
                                          context,
                                          AppConstString.partnerDetails,
                                          imgType == AppConstString.image
                                              ? sectionItemData[index]
                                                      .navigationLink ??
                                                  ''
                                              : sectionItemDataIcon[index]
                                                      .navigationLink ??
                                                  '');
                                    } else if (sectionItemData[index]
                                            .navigationType ==
                                        AppConstString.website) {
                                      dashboardPresentor.openWebLink(
                                        AppConstString.partnerDetails,
                                        imgType == AppConstString.image
                                            ? sectionItemData[index]
                                                    .navigationLink ??
                                                ''
                                            : sectionItemDataIcon[index]
                                                    .navigationLink ??
                                                '',
                                      );
                                    } else {
                                      MoenageManager.logScreenEvent(
                                          name: AppConstString.partnerDetails);
                                      imgType == AppConstString.image
                                          ? AutoRouter.of(context).pushNamed(
                                              "${sectionItemData[index].navigationLink}/false",
                                            )
                                          : AutoRouter.of(context).pushNamed(
                                              '${sectionItemDataIcon[index].navigationLink}/false',
                                            );
                                    }
                                  }
                                },
                                child: CachedNetworkImage(
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.contain,
                                  height: 50,
                                  imageUrl: getImgOrIconUrl(
                                    imgType: imgType,
                                    index: index,
                                    imageData: sectionItemData,
                                    iconData: sectionItemDataIcon,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  Widget topStoriesWidget() {
    var showTitle = false;
    var showWidget = true;
    var sectionTitle = "";
    var viewType = "";
    int gridCount = 0;
    List<Datum> sectionItemData = [];
    List<SectionData> trendingPartners = [];

    for (var i in widget.dashBoardModel.data!.body!) {
      if (i.sectionCode == AppConstString.topStories) {
        for (var j in i.sectionData) {
          trendingPartners.add(SectionData.fromJson(j));
        }
        showTitle = i.showTitle ?? false;
        showWidget = i.status ?? false;
        sectionTitle = i.sectionTitle ?? AppConstString.topStory;
        gridCount = int.parse(i.extraData!.gridColumns ?? "4");
        sectionItemData.clear();
        for (var i in i.sectionData[0]['data']) {
          //featuredOfferSectionData subData
          sectionItemData.add(Datum.fromJson(i));
        }
      }
      if (i.componentType == AppConstString.slider) {
        viewType = AppConstString.slider;
      } else if (i.componentType == AppConstString.grid) {
        viewType = AppConstString.grid;
      }
    }

    return showWidget
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppSizes.size10,
              ),
              showTitle
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.size20),
                      child: Text(
                        sectionTitle,
                        style: AppTextStyle.regular18
                            .copyWith(fontFamily: 'Bebas'),
                      ),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: AppSizes.size10,
              ),
              viewType == AppConstString.grid
                  ? GridView(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: gridCount),
                      children: List.generate(
                        sectionItemData.length,
                        (index) => topStoriesItems(
                          imagePath:
                              assetPath + (sectionItemData[index].imgUrl ?? ""),
                          title: (sectionItemData[index].imgDesc ?? ""),
                          onTap: () async {
                            homeScreenClickTrack(
                              screenName: 'Home',
                              componentType: 'Grid',
                              componentName: 'Top Stories',
                              clickedOn: 'Image',
                              imageUrl: assetPath +
                                  (sectionItemData[index].imgUrl ?? ""),
                              iconName: '',
                            );
                            dashboardPresentor.redirectTopStories(
                                context,
                                sectionItemData[index].navigationType ?? "",
                                sectionItemData[index].navigationLink ?? "");
                          },
                        ),
                      ))
                  : CarouselSlider(
                      carouselController: topStoriesController,
                      options: CarouselOptions(
                          autoPlay: false,
                          aspectRatio: 1.9,
                          viewportFraction: .50,
                          enableInfiniteScroll: false,
                          disableCenter: false,
                          padEnds: false,
                          onPageChanged: (index, reason) {}),
                      items: sectionItemData
                          .map(
                            (item) => InkWell(
                              onTap: () async {
                                homeScreenClickTrack(
                                  screenName: 'Home',
                                  componentType: 'Slider',
                                  componentName: 'Top Stories',
                                  clickedOn: 'Image',
                                  imageUrl: assetPath + (item.imgUrl ?? ""),
                                  iconName: '',
                                );
                                String? imgDec = item.imgDesc;
                                String? navigationLink =
                                    item.navigationLink?.split('=').last;

                                dashboardPresentor.deepLinkNavigationWithEvent(
                                    context,
                                    'rss feed screen',
                                    '/rss_feed_demo/$navigationLink/$imgDec/false');
                                // dashboardPresentor.redirectTopStories(
                                //     context,
                                //     item.navigationType ?? "",
                                //     item.navigationLink ?? "");
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: AppSizes.size16,
                                    bottom: AppSizes.size16),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: CachedNetworkImage(
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.fill,
                                    imageUrl: assetPath + (item.imgUrl ?? ""),
                                  ),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ],
          )
        : const SizedBox();
  }

  Widget growNowWidget() {
    var showTitle = false;
    var showWidget = true;
    var sectionTitle = "";
    List<Datum> sectionItemData = [];
    List<SectionData> growNow = [];

    for (var i in widget.dashBoardModel.data!.body!) {
      if (i.sectionCode == AppConstString.growNow) {
        for (var j in i.sectionData) {
          growNow.add(SectionData.fromJson(j));
        }
        showTitle = i.showTitle ?? false;
        showWidget = i.status ?? false;
        sectionTitle = i.sectionTitle ?? AppConstString.moreBounz;
        sectionItemData.clear();
        for (var i in i.sectionData[0]['data']) {
          //featuredOfferSectionData subData
          sectionItemData.add(Datum.fromJson(i));
        }
      }
    }

    return showWidget
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
            child: Column(
              children: [
                const SizedBox(
                  height: AppSizes.size20,
                ),
                showTitle
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              sectionTitle,
                              style: AppTextStyle.regular18
                                  .copyWith(fontFamily: 'Bebas'),
                            ),
                            InkWell(
                              onTap: () {
                                homeScreenClickTrack(
                                  screenName: 'Home',
                                  componentType: 'Icon',
                                  componentName: 'Grow Now',
                                  clickedOn: 'View all',
                                  imageUrl: '',
                                  iconName: 'View all',
                                );
                                dashboardPresentor.redirectToHome(context, 2);
                              },
                              child: Text(
                                AppConstString.viewAll,
                                style: AppTextStyle.regular14.copyWith(
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: AppSizes.size10,
                ),
                GestureDetector(
                  onTap: () {
                    homeScreenClickTrack(
                      screenName: 'Home',
                      componentType: 'Slider',
                      componentName: 'Grow Now',
                      clickedOn: 'Image',
                      imageUrl: assetPath + (sectionItemData[0].imgUrl ?? ""),
                      iconName: '',
                    );
                    dashboardPresentor.deepLinkNavigationWithEvent(
                        context,
                        'grow now',
                        (sectionItemData[0].navigationLink ?? '') + '/false');
                  },
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                        ),
                    child: CachedNetworkImage(
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: screenWidth,
                      imageUrl: assetPath + (sectionItemData[0].imgUrl ?? ""),
                    ),
                  ),
                ),
                const SizedBox(
                  height: AppSizes.size20,
                ),
              ],
            ),
          )
        : const SizedBox();
  }

  Widget referFriendWidget() {
    var showTitle = false;
    var sectionTitle = "";
    var showWidget = true;
    List<Datum> sectionItemData = [];
    List<SectionData> growNow = [];

    for (var i in widget.dashBoardModel.data!.body!) {
      if (i.sectionCode == AppConstString.referAFriend) {
        for (var j in i.sectionData) {
          growNow.add(SectionData.fromJson(j));
        }
        showTitle = i.showTitle ?? false;
        showWidget = i.status ?? false;
        sectionTitle = i.sectionTitle ?? AppConstString.moreBounz;
        sectionItemData.clear();
        for (var i in i.sectionData[0]['data']) {
          //featuredOfferSectionData subData
          sectionItemData.add(Datum.fromJson(i));
        }
      }
    }

    return showWidget
        ? GestureDetector(
            onTap: () {
              if (sectionItemData[0].navigationLink ==
                  "/buy_giftcards_screen") {
                homeScreenClickTrack(
                  screenName: 'Home',
                  componentType: '',
                  componentName: '',
                  clickedOn: (sectionItemData[0].navigationLink ?? '')
                      .replaceAll(RegExp(r'[/_]|screen'), ''),
                  imageUrl: assetPath + (sectionItemData[0].imgUrl ?? ""),
                  iconName: '',
                );
              }
              dashboardPresentor.deepLinkNavigationWithEvent(
                  context,
                  'Refer Earn',
                  (sectionItemData[0].navigationLink ?? "") + '/false');
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: AppSizes.size20,
                  left: AppSizes.size20,
                  right: AppSizes.size20),
              child: Column(
                children: [
                  showTitle
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                sectionTitle,
                                style: AppTextStyle.regular18
                                    .copyWith(fontFamily: 'Bebas'),
                              ),
                              InkWell(
                                onTap: () {
                                  homeScreenClickTrack(
                                    screenName: 'Home',
                                    componentType: 'View all',
                                    componentName: sectionTitle,
                                    clickedOn: 'View all',
                                    imageUrl: '',
                                    iconName: 'View all',
                                  );
                                  dashboardPresentor.redirectToHome(context, 2);
                                },
                                child: Text(
                                  AppConstString.viewAll,
                                  style: AppTextStyle.regular14.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: AppSizes.size10,
                              ),
                            ],
                          ),
                        )
                      : const SizedBox(
                          height: AppSizes.size10,
                        ),
                  const SizedBox(
                    height: AppSizes.size10,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: CachedNetworkImage(
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: screenWidth,
                      imageUrl: assetPath + (sectionItemData[0].imgUrl ?? ""),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox();
  }

  Widget sliderCountView({
    required List dataList,
    required CarouselController controller,
    required int currentCount,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: dataList.asMap().entries.map((entry) {
        return GestureDetector(
          onTap: () => controller.animateToPage(entry.key),
          child: currentCount == entry.key
              ? Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 2.0,
                    horizontal: 8.0,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "${entry.key + 1}/${dataList.length}",
                    style: AppTextStyle.regular12.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                )
              : Container(
                  width: AppSizes.size6,
                  height: AppSizes.size6,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 4.0,
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (AppColors.greyColor).withOpacity(0.1),
                  ),
                ),
        );
      }).toList(),
    );
  }

  Widget moreBounzDecoration({
    required String imagePath,
    required String title,
    required Function() onTap,
  }) {
    String? iconUrl;
    Uint8List? uint8list;
    if ((imagePath.contains('['))) {
      List dynamicList = jsonDecode(imagePath);
      List<int> intList = dynamicList.cast<int>().toList();
      uint8list = Uint8List.fromList(intList);
    } else {
      iconUrl = imagePath;
    }
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            child: iconUrl == null
                ? SvgPicture.memory(
                    uint8list!,
                  )
                : SvgPicture.network(
                    iconUrl,
                  ),
          ),
          Text(
            title,
            textScaleFactor: 1,
            style: AppTextStyle.regular12,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget topStoriesItems({
    required String imagePath,
    required String title,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.purpleColor.withOpacity(.20),
            ),
            child: CachedNetworkImage(
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
              height: 50,
              imageUrl: imagePath,
            ),
          ),
          Text(
            title,
            style: AppTextStyle.light12,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String getImgUrl() {
    String imgUrl = "";
    for (int i = 0;
        i < widget.dashBoardModel.data!.header![0].data!.length;
        i++) {
      if (widget.dashBoardModel.data!.header![0].data![i].key == "logo") {
        imgUrl =
            assetPath + widget.dashBoardModel.data!.header![0].data![i].value!;
      }
    }
    return imgUrl;
  }

  void getDashboardHeaderData() {
    for (int i = 0;
        i < widget.dashBoardModel.data!.header![0].data!.length;
        i++) {
      if (widget.dashBoardModel.data!.header![0].data![i].key ==
          AppConstString.backgroundColor) {
        String color = widget.dashBoardModel.data!.header![0].data![i].value!;
        color = color.substring(1);
        color = "0xff" + color;
        dashboardBgColor = Color(int.parse(color));
      } else if (widget.dashBoardModel.data!.header![0].data![i].key ==
          AppConstString.fontColor) {
        String color = widget.dashBoardModel.data!.header![0].data![i].value!;
        color = color.substring(1);
        color = "0xff" + color;
        headerTextColor = Color(int.parse(color));
      } else if (widget.dashBoardModel.data!.header![0].data![i].key ==
          AppConstString.backgroundImage) {
        headerImage =
            assetPath + widget.dashBoardModel.data!.header![0].data![i].value!;
      } else if (widget.dashBoardModel.data!.header![0].data![i].key ==
          AppConstString.themeOnCollapse) {
        themeOnCollapse =
            widget.dashBoardModel.data!.header![0].data![i].value!;
      }
    }
    setState(() {});
  }

  GetOtpModel _getOtpModel = GetOtpModel();

  Future<String> generateOtp(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethodSSO(
        context: context,
        url: ApiPath.apiEndPoint + ApiPath.generateOtp,
        data: {
          'mobile_number': GlobalSingleton.userInformation.mobileNumber,
          'country_code': GlobalSingleton.userInformation.countryCode,
          'email': GlobalSingleton.userInformation.email,
          'channel': "POS", //static
          'type': 'lock', //static
        });
    if (response != null) {
      _getOtpModel = GetOtpModel.fromJson(response);
      _otpBtnHide = !_otpBtnHide;
      _controller = AnimationController(
          vsync: this, duration: Duration(seconds: levelClock));
      _controller?.forward();
      return _getOtpModel.data?.values?.otp ?? "";
    }
    return "";
  }

  @override
  void refreshModel(MainHomeModel mainHomeModel) {
    if (mainHomeModel.dashBoardModel != null) {
      if (mounted) {
        setState(() {
          widget.dashBoardModel = mainHomeModel.dashBoardModel!;
        });
      }
    }
  }

  void setAsPerRank() {
    widget.dashBoardModel.data!.body!
        .sort((a, b) => a.rank!.compareTo(b.rank!));
  }
}

class Countdown extends AnimatedWidget {
  Countdown({Key? key, this.animation})
      : super(key: key, listenable: animation!);
  final Animation<int>? animation;

  @override
  build(BuildContext context) {
    Duration clockTimer = Duration(seconds: animation!.value);

    String timerText =
        '${clockTimer.inMinutes.remainder(60).toString().padLeft(2, '0')}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    return Text(
      'GENERATE NEW OTP IN ' + timerText,
      style: const TextStyle(color: AppColors.blackColor),
    );
  }
}
