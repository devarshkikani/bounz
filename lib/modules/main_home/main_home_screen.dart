import 'dart:convert';
// import 'dart:io';

import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/models/dashboard/dashboard_model.dart';
import 'package:bounz_revamp_app/services/print_logger.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/modules/account/my_account_screen.dart';
import 'package:bounz_revamp_app/modules/dashboard/dashboard_screen.dart';
import 'package:bounz_revamp_app/modules/main_home/main_home_model.dart';
import 'package:bounz_revamp_app/modules/main_home/main_home_presenter.dart';
import 'package:bounz_revamp_app/modules/main_home/main_home_view.dart';
import 'package:bounz_revamp_app/modules/main_home/shrimmer_main_home_screen.dart';
import 'package:bounz_revamp_app/modules/offers/offer_home/offer_home_screen.dart';
import 'package:bounz_revamp_app/modules/partners/partner_home/partner_home_screen.dart';
import 'package:bounz_revamp_app/modules/pay_bills/pay_bill_home/pay_bills_home_screen.dart';
import 'package:bounz_revamp_app/widgets/exit_bottomsheet.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:spike_flutter_sdk/spike_flutter_sdk.dart';

// ignore_for_file: deprecated_member_use
GlobalKey oneGlobalKey = GlobalKey();
GlobalKey twoGlobalKey = GlobalKey();
GlobalKey threeGlobalKey = GlobalKey();

@RoutePage()
class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({
    Key? key,
    @PathParam('index') this.index,
    @PathParam('isFirstLoad') this.isFirstLoad,
    this.isHeaderExpanded,
    this.isShowDialog,
  }) : super(key: key);
  final int? index;
  final bool? isFirstLoad;
  final bool? isHeaderExpanded;
  final bool? isShowDialog;
  @override
  State<MainHomeScreen> createState() => MainHomeScreenState();
}

class MainHomeScreenState extends State<MainHomeScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver
    implements MainHomeView {
  int selectedIndex = 0;
  bool isHowToUseSeen = false;
  late MainHomeModel model;
  late TabController _tabController;
  MainHomePresenter presenter = BasicMainHomePresenter();
  PageController controllerHowToUse = PageController();
  int indexHowToUse = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    GlobalSingleton.fromSplash = true;
    selectedIndex = widget.index ?? 0;
    _tabController =
        TabController(vsync: this, initialIndex: widget.index ?? 0, length: 5);
    presenter.updateView = this;
    String? encodedData =
        StorageManager.getStringValue(AppConstString.dashboardDataPrefKey);
    if (encodedData != null) {
      model.dashBoardModel = dashBoardModelFromJson(encodedData);
      presenter.getFooterData();
    }
    if (widget.isFirstLoad == true) {
      presenter.getHomePageData(context);
      serviceListPresenter.serviceList(context: context);
      partnerHomeViewPresenter.getPartnerHomeData();
      presenter.spinTheWheelListDesign(null);
    } else if (GlobalSingleton.isSpinTheWheelCalled) {
      presenter.spinTheWheelListDesign(context);
      GlobalSingleton.isSpinTheWheelCalled = false;
    }
    if (widget.isShowDialog == true) {
      Future.delayed(const Duration(seconds: 0), () {
        NetworkDio.showWarning(
          message: AppConstString.locationWarningMessage,
          context: context,
        );
      });
    }
    isHowToUseSeen =
        StorageManager.getBoolValue(AppStorageKey.isHowToUseSeen) ?? false;
    checkHealthBitConnection();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        checkHealthBitConnection();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.paused:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> checkHealthBitConnection() async {
    try {
      final bool getConnection =
          StorageManager.getBoolValue(AppStorageKey.healthConnected) ?? false;
      if (getConnection) {
        final connection = await SpikeSDK.createConnection(
          authToken: GlobalSingleton.authToken,
          appId: GlobalSingleton.appId,
          customerEndUserId:
              GlobalSingleton.userInformation.membershipNo.toString(),
          postbackURL: GlobalSingleton.postbackURL + 'webhook',
          logger: const PrintLogger(),
        );
        String? encryptDate =
            StorageManager.getStringValue(AppStorageKey.lastSyncData);
        DateTime lastDate = DateTime.now();
        if (encryptDate != null) {
          lastDate = DateTime.parse(encryptDate);
        }
        int diffrence = lastDate.difference(DateTime.now()).inDays.abs();
        int days = diffrence == 0 ? 1 : diffrence;
        for (var i = 0; i < days; i++) {
          final fromDate = DateTime.now().subtract(Duration(days: i));
          await connection.extractAndPostData(
            SpikeDataType.activitiesStream,
            from: fromDate,
            to: fromDate,
          );
          await connection.extractAndPostData(
            SpikeDataType.activitiesSummary,
            from: fromDate,
            to: fromDate,
          );
          await connection.extractAndPostData(
            SpikeDataType.steps,
            from: fromDate,
            to: fromDate,
          );
          StorageManager.setStringValue(
            key: AppStorageKey.lastSyncData,
            value: DateTime.now().toString(),
          );
        }
      }
    } on SpikeException catch (e) {
      GlobalSingleton.spikeErrorMessage = e.message;
    }
  }

  @override
  void refreshModel(MainHomeModel mainHomeModel) {
    model = mainHomeModel;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> howToUseWidget = <Widget>[
      Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                AppAssets.wcScreenOne,
                fit: BoxFit.fill,
              )),
          Positioned(
              right: 10,
              bottom: MediaQuery.of(context).size.height * 0.3, //270,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    indexHowToUse++;
                    controllerHowToUse.animateToPage(indexHowToUse,
                        duration: const Duration(seconds: 1),
                        curve: Curves.ease);
                  });
                },
                child: Container(
                  height: 60,
                  width: 120,
                  color: Colors.transparent,
                ),
              ))
        ],
      ),
      Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                AppAssets.wcScreenTwo,
                fit: BoxFit.fill,
              )),
          Positioned(
              right: 10,
              bottom: 20,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    indexHowToUse++;
                    controllerHowToUse.animateToPage(indexHowToUse,
                        duration: const Duration(seconds: 1),
                        curve: Curves.ease);
                  });
                },
                child: Container(
                  height: 40,
                  width: 100,
                  color: Colors.transparent,
                ),
              )),
          Positioned(
              left: 10,
              bottom: 20,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    indexHowToUse--;
                    controllerHowToUse.animateToPage(indexHowToUse,
                        duration: const Duration(seconds: 1),
                        curve: Curves.ease);
                  });
                },
                child: Container(
                  height: 40,
                  width: 100,
                  color: Colors.transparent,
                ),
              ))
        ],
      ),
      Stack(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                AppAssets.wcScreenThree,
                fit: BoxFit.fill,
              )),
          Positioned(
              right: MediaQuery.of(context).size.width * 0.03,
              bottom: MediaQuery.of(context).size.height * 0.01,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isHowToUseSeen = true;
                    StorageManager.setBoolValue(
                        key: AppStorageKey.isHowToUseSeen, value: true);
                  });
                },
                child: Container(
                  height: 60,
                  width: 130,
                  color: Colors.transparent,
                ),
              )),
          Positioned(
              left: MediaQuery.of(context).size.width * 0.01,
              bottom: MediaQuery.of(context).size.height * 0.01, // 20,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    indexHowToUse--;
                    controllerHowToUse.animateToPage(indexHowToUse,
                        duration: const Duration(seconds: 1),
                        curve: Curves.ease);
                  });
                },
                child: Container(
                  height: 60,
                  width: 80,
                  color: Colors.transparent,
                ),
              )),
        ],
      )
    ];

    if (model.dashBoardModel != null) {
      return Stack(
        children: [
          WillPopScope(
            onWillPop: _onWillPop,
            child: Scaffold(
              body: Center(
                child: [
                  DashBoardScreen(
                      dashBoardModel: model.dashBoardModel!,
                      isHeaderExpanded: widget.isHeaderExpanded ?? false),
                  const PartnerHomeScreen(),
                  const PayBillHome(),
                  const OfferHomeScreen(),
                  MyAccountScreen(dashBoardModel: model.dashBoardModel!)
                ].elementAt(selectedIndex),
              ),
              bottomNavigationBar: Container(
                height: 80,
                color: model.footerBgColor,
                child: TabBar(
                    onTap: (x) {
                      selectedIndex = x;
                      String sName;
                      if (x == 1) {
                        sName = "Partner";
                      } else if (x == 2) {
                        sName = "PayBills";
                      } else if (x == 3) {
                        sName = "Offers";
                      } else if (x == 4) {
                        sName = "My Account";
                      } else if (x == 5) {
                        sName = "Partner";
                      } else {
                        sName = "Home";
                      }
                      final properties = MoEProperties();
                      properties
                          .addAttribute(TriggeringCondition.screenName, "Home")
                          .addAttribute(
                              TriggeringCondition.componentType, "footer")
                          .addAttribute(
                              TriggeringCondition.componentName, sName)
                          .addAttribute(
                              TriggeringCondition.clickedOn, "$sName icon")
                          .addAttribute(TriggeringCondition.imageUrl, "")
                          .addAttribute(
                              TriggeringCondition.iconName, "$sName icon")
                          .setNonInteractiveEvent();
                      MoenageManager.logEvent(
                        MoenageEvent.homeScreenClick,
                        properties: properties,
                      );
                      if (mounted) {
                        setState(() {
                          isTapped = false;
                          StorageManager.setBoolValue(
                              key: 'isBarcodeTapped', value: false);
                        });
                      }
                    },
                    padding: EdgeInsets.zero,
                    labelPadding: EdgeInsets.zero,
                    indicatorPadding: EdgeInsets.zero,
                    indicatorWeight: 0,
                    labelColor: model.footerHoverColor,
                    unselectedLabelColor: model.footerTextColor,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide.none,
                    ),
                    tabs: List.generate(
                      model.dashBoardModel!.data!.footer![0].tabs!.length,
                      (index) {
                        return _tabItem(
                          index,
                          isSelected: index == selectedIndex,
                        );
                      },
                    ),
                    controller: _tabController),
              ),
            ),
          ),
          if (isHowToUseSeen == false) ...[
            // app tour screen
            SizedBox(
              // height: 300.0,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: PageView.builder(
                itemCount: howToUseWidget.length,
                itemBuilder: (context, index) {
                  return howToUseWidget[index];
                },
                controller: controllerHowToUse,
                onPageChanged: (index) {
                  setState(() {
                    indexHowToUse = index;
                  });
                },
              ),
            ),
          ],
        ],
      );
    } else {
      return const ShrimmerMainHome();
    }
  }

  Future<bool> _onWillPop() async {
    {
      selectedIndex == 1 ||
              selectedIndex == 2 ||
              selectedIndex == 3 ||
              selectedIndex == 4
          ? AutoRouter.of(context)
              .pushAndPopUntil(MainHomeScreenRoute(), predicate: (_) => false)
          : null;
      if (isTapped == true) {
        setState(() {
          isTapped = false;
        });
        return false;
      }
      StorageManager.setBoolValue(key: 'isBarcodeTapped', value: false);
      return await exitBottomSheet(context) ?? false;
    }
  }

  Widget _tabItem(int i, {bool isSelected = false}) {
    String? iconUrl;
    Uint8List? uint8list;
    if ((model.dashBoardModel!.data!.footer![0].tabs![i].iconUrl!
        .toString()
        .contains('['))) {
      List dynamicList = jsonDecode(
          model.dashBoardModel!.data!.footer![0].tabs![i].iconUrl!.toString());
      List<int> intList = dynamicList.cast<int>().toList();
      uint8list = Uint8List.fromList(intList);
    } else {
      iconUrl = model.dashBoardModel!.data!.assetPath! +
          model.dashBoardModel!.data!.footer![0].tabs![i].iconUrl!;
    }
    return Container(
      width: 70,
      margin: const EdgeInsets.only(top: 8.0),
      decoration: !isSelected
          ? null
          : BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
              color: model.footerHoverBgColor,
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconUrl == null
              ? SvgPicture.memory(
                  uint8list!,
                  color: selectedIndex == i
                      ? model.footerHoverColor
                      : model.footerTextColor,
                )
              : SvgPicture.network(
                  iconUrl,
                  color: selectedIndex == i
                      ? model.footerHoverColor
                      : model.footerTextColor,
                  placeholderBuilder: (context) {
                    return const CupertinoActivityIndicator();
                  },
                ),
          const SizedBox(
            height: 4.0,
          ),
          Text(model.dashBoardModel!.data!.footer![0].tabs![i].iconLabel ?? ""),
        ],
      ),
    );
  }
}
