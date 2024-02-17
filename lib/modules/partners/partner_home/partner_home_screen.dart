import 'dart:convert';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/widgets/shrimmer_widet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/models/partner/partner_list_model.dart';
import 'package:bounz_revamp_app/modules/partners/partner_home/partner_home_view.dart';
import 'package:bounz_revamp_app/modules/partners/partner_home/partner_home_model.dart';
import 'package:bounz_revamp_app/modules/partners/partner_home/partner_home_presentor.dart';
import 'package:bounz_revamp_app/modules/partners/partner_home/shrimmer_partner_home_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moengage_flutter/properties.dart';

class PartnerHomeScreen extends StatefulWidget {
  const PartnerHomeScreen({Key? key}) : super(key: key);

  @override
  State<PartnerHomeScreen> createState() => _PartnerHomeScreenState();
}

PartnerHomeViewPresenter partnerHomeViewPresenter =
    BasicPartnerHomeViewPresenter();
PartnerHomeViewModel? model;
bool sideContainerShow = true;
bool isPartnerApiCalled = false;
List<String> selectedCategoryCat = [];

class _PartnerHomeScreenState extends State<PartnerHomeScreen>
    implements PartnerHomeView {
  @override
  initState() {
    super.initState();
    partnerHomeViewPresenter.updateView = this;
    if (isPartnerApiCalled == false) {
      partnerHomeViewPresenter.getPartnerHomeData();
    }
    selectedCategoryCat = [];
  }

  @override
  void refreshModel(PartnerHomeViewModel partnerListModel) {
    if(mounted) {
      setState(() {
      model = partnerListModel;
    });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        padding: EdgeInsets.zero,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
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
                      AppConstString.partners.toUpperCase(),
                      style:
                          AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
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
                            child: model!.partnerListModel != null
                                ? partnerListView(
                                    model!.partnerListModel!.dataList!)
                                : const ShrimmerPartnerHomeScreenView(),
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
      ),
    );
  }

  Widget optionMenuView() {
    return Row(
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
                                  TriggeringCondition.screenName, "Partner")
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
                  .addAttribute(TriggeringCondition.screenName, "Partner")
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
              Icons.close_rounded,
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
    return model!.partnerListModel?.catValues == null
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
            itemCount: model!.partnerListModel?.catValues?.length ?? 0,
            padding: const EdgeInsets.only(right: AppSizes.size40),
            itemBuilder: (BuildContext context, int index) {
              CatValue? catValue = model!.partnerListModel?.catValues?[index];
              Uint8List? uint8list;
              if ((catValue!.catImage.toString().contains('['))) {
                List dynamicList = jsonDecode(catValue.catImage!);
                List<int> intList = dynamicList.cast<int>().toList();
                uint8list = Uint8List.fromList(intList);
              }
              return GestureDetector(
                onTap: () {
                  final properties = MoEProperties();
                  properties
                      .addAttribute(TriggeringCondition.screenName, "Partner")
                      .addAttribute(
                          TriggeringCondition.componentType, 'Menu list')
                      .addAttribute(TriggeringCondition.filterSelected, "")
                      .addAttribute(TriggeringCondition.componentName, "")
                      .addAttribute(
                          TriggeringCondition.clickedOn, catValue.catName ?? "")
                      .addAttribute(TriggeringCondition.iconName, "")
                      .setNonInteractiveEvent();
                  MoenageManager.logEvent(
                    MoenageEvent.screenClick,
                    properties: properties,
                  );
                  final String? catCode = catValue.catCode;
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
                              catValue.catImage ?? "",
                              height: 20,
                              width: 20,
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
                        catValue.catName ?? "",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.regular12.copyWith(
                          color: selectedCategoryCat.contains(catValue.catCode)
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

  Widget partnerListView(List<DataList> _dataList) {
    List<DataList> _dataListData = [];
    for (var i = 0; i < _dataList.length; i++) {
      if (selectedCategoryCat.isEmpty) {
        if (GlobalSingleton.osType == "ios") {
          if (_dataList[i].name.toString().toLowerCase().contains('havlife') !=
              true) {
            _dataListData.add(_dataList[i]);
          }
        } else {
          _dataListData.add(_dataList[i]);
        }
      } else if (selectedCategoryCat.contains(_dataList[i].catCode)) {
        if (GlobalSingleton.osType == "ios") {
          if (_dataList[i].name.toString().toLowerCase().contains('havlife') !=
              true) {
            _dataListData.add(_dataList[i]);
          }
        } else {
          _dataListData.add(_dataList[i]);
        }
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      alignment: Alignment.topCenter,
      child: _dataListData.isNotEmpty
          ? RefreshIndicator(
              onRefresh: () async {
                await partnerHomeViewPresenter.getPartnerHomeData();
              },
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: AppSizes.size12,
                crossAxisSpacing: AppSizes.size12,
                childAspectRatio:
                    GlobalSingleton.osType == "ios" ? 2.7 / 3.5 : 2.6 / 3.7,
                physics: const BouncingScrollPhysics(),
                children: List.generate(
                  _dataListData.length,
                  (index) {
                    return imageContentView(_dataListData[index], index);
                  },
                ),
              ),
            )
          : Center(
              child: Text(
                AppConstString.noDataFound,
                style: AppTextStyle.bold22.copyWith(
                  color: AppColors.brownishColor,
                ),
              ),
            ),
    );
  }

  Widget imageContentView(DataList dataList, int index) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.size20),
      child: InkWell(
        onTap: () {
          MoenageManager.logScreenEvent(name: 'Partner Details');
          final properties = MoEProperties();
          properties
              .addAttribute(TriggeringCondition.screenName, "Partner")
              .addAttribute(TriggeringCondition.componentType, 'grid')
              .addAttribute(TriggeringCondition.filterSelected, "")
              .addAttribute(TriggeringCondition.componentName, "")
              .addAttribute(TriggeringCondition.clickedOn, "Partner gird image")
              .addAttribute(
                  TriggeringCondition.imageUrl, dataList.newImage ?? "")
              .addAttribute(TriggeringCondition.iconName, "")
              .setNonInteractiveEvent();
          MoenageManager.logEvent(
            MoenageEvent.screenClick,
            properties: properties,
          );
          AutoRouter.of(context).pushNamed(
            '/partner_details_screen/${dataList.merchantCode}/${dataList.brandCode}/false',
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.size20),
            color: AppColors.whiteColor,
          ),
          child: networkImage(
            dataList.newImage ?? "",
            fit: BoxFit.fitWidth,
            height: 150,
            width: MediaQuery.of(context).size.width * .39,
          ),
        ),
      ),
    );
  }
}
