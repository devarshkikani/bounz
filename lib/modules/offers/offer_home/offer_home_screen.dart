import 'dart:convert';

import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/offer/offer_category_model.dart';
import 'package:bounz_revamp_app/modules/offers/offer_home/shrimmer_offers_home_screen.dart';
import 'package:bounz_revamp_app/widgets/shrimmer_widet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:moengage_flutter/properties.dart';

import 'offer_home_view.dart';
import 'offer_home_model.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/models/offer/offer_model.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/modules/offers/offer_home/offer_home_presenter.dart';

class OfferHomeScreen extends StatefulWidget {
  const OfferHomeScreen({Key? key}) : super(key: key);

  @override
  State<OfferHomeScreen> createState() => _OfferHomeScreenState();
}

bool sideContainerShow = true;
OfferHomePresenter presenterOffer = BasicOfferHomePresenter();
OfferHomeViewModel? modelOffer;
bool isOfferApiCalled = false;
List<String> selectedCategoryCat = [];

class _OfferHomeScreenState extends State<OfferHomeScreen>
    implements OfferHomeView {
  @override
  initState() {
    super.initState();
    if (isOfferApiCalled == false) {
      presenterOffer.updateView = this;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        presenterOffer.getOfferHomeData(context);
      });
    }
    String? data =
        StorageManager.getStringValue(AppStorageKey.storeOfferCatImage);
    if (data != null) {
      final List<dynamic> jsonData = jsonDecode(data);
      modelOffer!.offerCategoryList =
          jsonData.map<OfferCategoryModel>((jsonItem) {
        return OfferCategoryModel.fromJson(jsonItem);
      }).toList();
    }
    selectedCategoryCat = [];
  }

  @override
  void refreshModelOffer(OfferHomeViewModel offerListModel) {
    if(mounted) {
      setState(() {
      modelOffer = offerListModel;
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _scaffoldKey,
      body: AppBackGroundWidget(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: AppSizes.size20,
                top: AppSizes.size20,
                bottom: AppSizes.size20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      MoenageManager.logScreenEvent(name: 'Main Home');
                      AutoRouter.of(context).pushAndPopUntil(
                          MainHomeScreenRoute(),
                          predicate: (_) => false);
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
                    AppConstString.offers.toUpperCase(),
                    style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  optionMenuView(),
                  Column(
                    children: [
                      AnimatedContainer(
                        height: sideContainerShow ? 100 : 0,
                        duration: const Duration(
                          milliseconds: 500,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: AppSizes.size20,
                            right: AppSizes.size20,
                          ),
                          child: modelOffer!.offerList != null
                              ? Align(
                                  alignment: Alignment.topCenter,
                                  child: offerListView(
                                    modelOffer!.offerList!,
                                  ),
                                )
                              : const ShrimmerOffersHomeScreenView(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget noOffersWidget() {
    final properties = MoEProperties();
    properties.addAttribute(TriggeringCondition.screenName, "Offer Home");
    MoenageManager.logEvent(
      MoenageEvent.noOffers,
      properties: properties,
    );
    return Column(
      children: [
        const SizedBox(
          height: AppSizes.size80,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                AppAssets.noOffersImg,
              ),
              const SizedBox(
                height: AppSizes.size12,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  AppConstString.noOffers,
                  style: AppTextStyle.bold16,
                ),
              ),
              const SizedBox(
                height: AppSizes.size4,
              ),
              Text(
                AppConstString.noOffersTxt,
                style: AppTextStyle.bold16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget optionMenuView() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: AppSizes.size12),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(100),
              bottomRight: Radius.circular(100),
            ),
            child: AnimatedContainer(
              width: sideContainerShow
                  ? MediaQuery.of(context).size.width * .85
                  : AppSizes.size16,
              height: 60,
              decoration: const BoxDecoration(
                color: AppColors.btnBlueColor,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(100),
                  bottomRight: Radius.circular(100),
                ),
              ),
              duration: const Duration(milliseconds: 500),
              curve: Curves.decelerate,
              child: sideContainerShow
                  ? expandedOptionMenu()
                  : Align(
                      alignment: Alignment.centerLeft,
                      child: InkWell(
                        onTap: () {
                          sideContainerShow = !sideContainerShow;
                          final properties = MoEProperties();
                          properties
                              .addAttribute(
                                  TriggeringCondition.screenName, "Offers")
                              .addAttribute(TriggeringCondition.componentType,
                                  'Expaneded menu option')
                              .addAttribute(
                                  TriggeringCondition.filterSelected, "")
                              .addAttribute(
                                  TriggeringCondition.componentName, "")
                              .addAttribute(TriggeringCondition.clickedOn,
                                  'forward arrow icon')
                              .addAttribute(TriggeringCondition.imageUrl, "")
                              .addAttribute(
                                  TriggeringCondition.iconName, "forward arrow")
                              .setNonInteractiveEvent();
                          MoenageManager.logEvent(
                            MoenageEvent.screenClick,
                            properties: properties,
                          );
                          setState(() {});
                        },
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: AppSizes.size16,
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget expandedOptionMenu() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: InkWell(
            onTap: () {
              sideContainerShow = !sideContainerShow;
              final properties = MoEProperties();
              properties
                  .addAttribute(TriggeringCondition.screenName, "Offers")
                  .addAttribute(
                      TriggeringCondition.componentType, 'Collapse menu option')
                  .addAttribute(TriggeringCondition.filterSelected, "")
                  .addAttribute(TriggeringCondition.componentName, "")
                  .addAttribute(TriggeringCondition.clickedOn, 'Close icon')
                  .addAttribute(TriggeringCondition.imageUrl, "")
                  .addAttribute(TriggeringCondition.iconName, "Close")
                  .setNonInteractiveEvent();
              MoenageManager.logEvent(
                MoenageEvent.screenClick,
                properties: properties,
              );
              setState(() {});
            },
            child: const Icon(
              Icons.close,
              color: AppColors.whiteColor,
            ),
          ),
        ),
        Expanded(
          flex: 9,
          child: Stack(
            children: [
              showCategory(),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: InkWell(
                  onTap: () {
                    sideContainerShow = !sideContainerShow;
                    setState(() {});
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSizes.size8),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black,
                        ],
                        // stops: [0.0, 1.0],
                        begin: FractionalOffset.centerLeft,
                        end: FractionalOffset.centerRight,
                        tileMode: TileMode.repeated,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: AppSizes.size22,
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget showCategory() {
    return modelOffer?.offerCategoryList == null
        ? ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            padding: const EdgeInsets.only(right: AppSizes.size40),
            itemBuilder: (BuildContext context, int index) {
              return const Padding(
                padding: EdgeInsets.only(left: AppSizes.size10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomShrimmerWidget.circular(
                      height: AppSizes.size30,
                      width: AppSizes.size30,
                    ),
                    SizedBox(
                      height: AppSizes.size8,
                    ),
                    CustomShrimmerWidget.rectangular(
                      height: 4,
                      width: AppSizes.size30,
                    ),
                  ],
                ),
              );
            },
          )
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: modelOffer?.offerCategoryList?.length ?? 0,
            padding: const EdgeInsets.only(right: AppSizes.size40),
            itemBuilder: (BuildContext context, int index) {
              String image =
                  modelOffer!.offerCategoryList![index].catImage ?? '';
              Uint8List? uint8list;
              if ((image.contains('['))) {
                List dynamicList = jsonDecode(image);
                List<int> intList = dynamicList.cast<int>().toList();
                uint8list = Uint8List.fromList(intList);
              }

              return GestureDetector(
                onTap: () {
                  final properties = MoEProperties();
                  properties
                      .addAttribute(TriggeringCondition.screenName, "Offers")
                      .addAttribute(
                          TriggeringCondition.componentType, 'Menu list')
                      .addAttribute(TriggeringCondition.filterSelected, "")
                      .addAttribute(TriggeringCondition.componentName, "")
                      .addAttribute(TriggeringCondition.clickedOn,
                          modelOffer?.offerCategoryList?[index].catName ?? "")
                      .addAttribute(
                          TriggeringCondition.imageUrl,
                          modelOffer!.offerCategoryList![index].catImage
                              .toString())
                      .addAttribute(TriggeringCondition.iconName, "")
                      .setNonInteractiveEvent();
                  MoenageManager.logEvent(
                    MoenageEvent.screenClick,
                    properties: properties,
                  );
                  final String? catCode =
                      modelOffer?.offerCategoryList?[index].catCode;
                  if (index == 0) {
                    selectedCategoryCat = [];
                  } else {
                    if (selectedCategoryCat.contains(catCode)) {
                      selectedCategoryCat.remove(catCode);
                    } else {
                      selectedCategoryCat.add(catCode!);
                    }
                  }
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: AppSizes.size10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      uint8list == null
                          ? SvgPicture.network(
                              height: 20,
                              width: 20,
                              modelOffer?.offerCategoryList?[index].catImage ??
                                  "",
                              placeholderBuilder: (context) {
                                return const CupertinoActivityIndicator();
                              },
                            )
                          : SvgPicture.memory(
                              uint8list,
                              height: 20,
                              width: 20,
                              placeholderBuilder: (context) {
                                return const CupertinoActivityIndicator();
                              },
                            ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      Text(
                        modelOffer?.offerCategoryList?[index].catName ?? "",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.regular12.copyWith(
                          color: selectedCategoryCat.contains(
                                  modelOffer?.offerCategoryList?[index].catCode)
                              ? AppColors.darkOrangeColor
                              : selectedCategoryCat.isEmpty && index == 0
                                  ? AppColors.darkOrangeColor
                                  : AppColors.whiteColor,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
  }

  Widget offerListView(List<OfferModel> _dataList) {
    List<OfferModel> _dataListData = [];
    for (var i = 0; i < _dataList.length; i++) {
      if (selectedCategoryCat.isEmpty) {
        if (GlobalSingleton.osType == "ios") {
          if (_dataList[i]
                  .brandName
                  .toString()
                  .toLowerCase()
                  .contains('havlife') !=
              true) {
            _dataListData.add(_dataList[i]);
          }
        } else {
          _dataListData.add(_dataList[i]);
        }
      } else if (selectedCategoryCat.contains(_dataList[i].categoryCode)) {
        if (GlobalSingleton.osType == "ios") {
          if (_dataList[i]
                  .brandName
                  .toString()
                  .toLowerCase()
                  .contains('havlife') !=
              true) {
            _dataListData.add(_dataList[i]);
          }
        } else {
          _dataListData.add(_dataList[i]);
        }
      }
    }
    return _dataListData.isEmpty
        ? noOffersWidget()
        : RefreshIndicator(
            onRefresh: () async {
              await presenterOffer.getOfferHomeData(context);
            },
            child: ListView.separated(
              itemCount: _dataListData.length,
              padding: const EdgeInsets.only(
                  // top: AppSizes.size10,
                  ),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              separatorBuilder: (context, index) {
                return const SizedBox(
                  height: AppSizes.size20,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    MoenageManager.logScreenEvent(name: 'Offer Detail');
                    final properties = MoEProperties();
                    properties
                        .addAttribute(TriggeringCondition.screenName, "Offers")
                        .addAttribute(TriggeringCondition.componentType, 'list')
                        .addAttribute(TriggeringCondition.filterSelected, "")
                        .addAttribute(TriggeringCondition.componentName, "")
                        .addAttribute(
                            TriggeringCondition.clickedOn, "Offer card image")
                        .addAttribute(TriggeringCondition.imageUrl,
                            _dataListData[index].offerImage ?? "")
                        .addAttribute(TriggeringCondition.iconName, "")
                        .setNonInteractiveEvent();
                    MoenageManager.logEvent(
                      MoenageEvent.screenClick,
                      properties: properties,
                    );

                    final properties1 = MoEProperties();
                    properties1
                        .addAttribute(TriggeringCondition.brandCode,
                            modelOffer!.offerList![index].brandCode.toString())
                        .addAttribute(TriggeringCondition.brandLogo,
                            _dataListData[index].brandLogo ?? "")
                        .addAttribute(TriggeringCondition.brandName,
                            modelOffer!.offerList![index].brandName.toString())
                        .addAttribute(TriggeringCondition.categoryCode,
                            _dataListData[index].categoryCode.toString())
                        .addAttribute(
                            TriggeringCondition.categoryName,
                            modelOffer!.offerList![index].categoryName
                                .toString())
                        .addAttribute(TriggeringCondition.distance,
                            _dataListData[index].distance.toString())
                        .addAttribute(TriggeringCondition.laltitude,
                            modelOffer!.offerList![index].latitude.toString())
                        .addAttribute(TriggeringCondition.longitude,
                            _dataListData[index].longitude.toString())
                        .addAttribute(
                            TriggeringCondition.merchantCode,
                            modelOffer!.offerList![index].merchantCode
                                .toString())
                        .addAttribute(TriggeringCondition.offerImage,
                            _dataListData[index].offerImage ?? "")
                        .addAttribute(TriggeringCondition.offerTitle,
                            modelOffer!.offerList![index].offerTitle.toString())
                        .addAttribute(TriggeringCondition.ofrDesc,
                            _dataListData[index].ofrDesc.toString())
                        .addAttribute(TriggeringCondition.ofrdCode,
                            modelOffer!.offerList![index].ofrdCode.toString())
                        .addAttribute(TriggeringCondition.outletCode,
                            _dataListData[index].outletCode.toString())
                        .setNonInteractiveEvent();
                    MoenageManager.logEvent(
                      MoenageEvent.offersSelected,
                      properties: properties1,
                    );
                    AutoRouter.of(context).pushNamed(
                        '/offer_detail_screen/${_dataListData[index].ofrdCode}/false');
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSizes.size20),
                    child: Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: AppColors.brownishColor.withOpacity(.2),
                        borderRadius: BorderRadius.circular(AppSizes.size20),
                      ),
                      child: networkImage(
                        _dataListData[index].offerImage ?? "",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          );

    /*
      Column(
      children:  List.generate(
        model.offerListModel?.values?.searchOffers?.offerslist?.length ?? 0, (i) {
        return InkWell(
            onTap: () {
              AutoRouter.of(context).push(const OffersInnerScreenRoute());
            },
            child: Container(
              margin: const EdgeInsets.only(top: AppSizes.size24),
              height: 140,
              width: MediaQuery.of(context).size.width / 1.3,
              decoration: BoxDecoration(
                color: Colors.black38,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image:CachedNetworkImageProvider(model.offerListModel?.values?.searchOffers?.offerslist?[i].offerImage ?? "")
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            )
        );
      },
      ),
    );*/
  }
}
