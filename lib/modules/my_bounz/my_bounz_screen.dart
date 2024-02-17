import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/my_bounz/expiry_detail_model.dart';
import 'package:bounz_revamp_app/models/my_bounz/my_bounz_card_model.dart';
import 'package:bounz_revamp_app/modules/my_bounz/my_bounz_model.dart';
import 'package:bounz_revamp_app/modules/my_bounz/my_bounz_presenter.dart';
import 'package:bounz_revamp_app/modules/my_bounz/my_bounz_view.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/fliter_bottom_sheet.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moengage_flutter/properties.dart';

import '../../config/manager/moenage_manager.dart';
import '../../config/routes/router_import.gr.dart';

@RoutePage()
class MyBounzScreen extends StatefulWidget {
  final bool fromSplash;
  const MyBounzScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  State<MyBounzScreen> createState() => _MyBounzScreenState();
}

class _MyBounzScreenState extends State<MyBounzScreen> implements MybounzView {
  late MybounzModel model;
  final MyBounzPresenter presenter = BasicMyBounzPresenter();

  @override
  void refreshModel(MybounzModel mybounzModel) {
    if (mounted) {
      setState(() {
        model = mybounzModel;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    presenter.updateModel = this;
    presenter.transactionList(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: AppBackGroundWidget(
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppSizes.size20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                child: GestureDetector(
                  onTap: () {
                    if (widget.fromSplash) {
                      MoenageManager.logScreenEvent(name: 'Main Home');
                      AutoRouter.of(context).pushAndPopUntil(
                          MainHomeScreenRoute(
                            isFirstLoad: true,
                          ),
                          predicate: (_) => false);
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
              const SizedBox(
                height: AppSizes.size14,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                child: Text(
                  AppConstString.myBounz,
                  style: AppTextStyle.regular36.copyWith(
                    fontFamily: "Bebas",
                  ),
                ),
              ),
              const SizedBox(
                height: AppSizes.size24,
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                padding: const EdgeInsets.all(AppSizes.size12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.size16),
                  color: AppColors.primaryContainerColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        AppAssets.bounzWhiteLogo,
                        height: AppSizes.size50,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(
                      width: AppSizes.size8,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Total BOUNZ (Earned + Redeemed)",
                          style: AppTextStyle.light12,
                        ),
                        const SizedBox(
                          height: AppSizes.size8,
                        ),
                        Text(
                          model.totalRedeemPoint.price,
                          style: AppTextStyle.bold24,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSizes.size6,
              ),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: AppSizes.size46 + 1,
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.whiteColor.withOpacity(0.5),
                          width: AppSizes.size1,
                        ),
                      ),
                    ),
                  ),
                  TabBar(
                    labelStyle: AppTextStyle.bold14,
                    unselectedLabelStyle: AppTextStyle.regular14,
                    labelColor: AppColors.darkBlueTextColor,
                    unselectedLabelColor: AppColors.darkBlueTextColor,
                    indicatorColor: AppColors.blackColor,
                    indicatorWeight: 3,
                    labelPadding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.label,
                    onTap: (int index) {
                      presenter.updateTabIndex(index);
                    },
                    tabs: const [
                      Tab(
                        child: Text(
                          " ${AppConstString.merchant} ",
                        ),
                      ),
                      Tab(
                        child: Text(
                          " ${AppConstString.earned} ",
                        ),
                      ),
                      Tab(
                        child: Text(
                          " ${AppConstString.redeemed} ",
                        ),
                      ),
                      Tab(
                        child: Text(
                          " ${AppConstString.expiring}",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                child: model.currentTabIndex == 3
                    ? expiringButton()
                    : filterButton(),
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    listViewBuilderOne(),
                    listViewBuilderTwo(),
                    listViewBuilderThree(),
                    listViewBuilderFour(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget headerView(int index) {
    int totalPoints = 0;
    for (MyBounzCardModel e in model.merchantList![index].values.toList()[0]) {
      totalPoints += e.points!;
    }
    return InkWell(
      onTap: () {
        model.merchantList![index]['expand'] =
            !model.merchantList![index]['expand'];
        setState(() {});
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              model.merchantList![index].values.toList().first[0].image != null
                  ? Container(
                      height: 30,
                      width: 30,
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: AppColors.backgroundColor,
                      ),
                      child: networkImage(
                        model.merchantList![index].values
                            .toList()
                            .first[0]
                            .image,
                      ),
                    )
                  : CircleAvatar(
                      backgroundColor: AppColors.backgroundColor,
                      radius: 20,
                      child: SvgPicture.asset(
                        AppAssets.bounzWhiteLogo,
                        height: AppSizes.size24,
                        fit: BoxFit.cover,
                      ),
                    ),
              const SizedBox(
                width: AppSizes.size14,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.merchantList![index].values
                                .toList()
                                .first[0]
                                .partnerName
                                .toString() ==
                            "null"
                        ? " "
                        : model.merchantList![index].values
                            .toList()
                            .first[0]
                            .partnerName
                            .toString(),
                    style: AppTextStyle.semiBold16.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size8,
                  ),
                  Text(
                    model.merchantList![index].values
                                .toList()
                                .first[0]
                                .partnerName
                                .toString() ==
                            "null"
                        ? " "
                        : model.merchantList![index].values
                            .toList()
                            .first[0]
                            .partnerName
                            .toString(),
                    style: AppTextStyle.semiBold12.copyWith(
                      color: AppColors.darkBlueTextColor.withOpacity(0.88),
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size12,
                  ),
                  Text(
                    model.merchantList![index].values.toList()[1]
                        ? "Hide Details"
                        : "View Details",
                    style: AppTextStyle.bold12.copyWith(
                      decoration: TextDecoration.underline,
                      decorationThickness: 2,
                      color: AppColors.darkBlueTextColor,
                    ),
                  ),
                  SizedBox(
                    height: model.merchantList![index].values.toList()[1]
                        ? AppSizes.size20
                        : 0,
                  ),
                ],
              ),
            ],
          ),
          Text(
            totalPoints.price,
            style: AppTextStyle.bold16.copyWith(
              color: AppColors.darkBlueTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget filterButton() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            final properties = MoEProperties();
            properties
                .addAttribute(TriggeringCondition.screenName, "My Bounz")
                .addAttribute(TriggeringCondition.componentType, "Dropdown")
                .addAttribute(TriggeringCondition.filterSelected,
                    model.selectedMonth['title'])
                .addAttribute(TriggeringCondition.componentName, "")
                .addAttribute(TriggeringCondition.clickedOn, "Dropdown")
                .addAttribute(TriggeringCondition.imageUrl, "")
                .addAttribute(TriggeringCondition.iconName, "")
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.screenClick,
              properties: properties,
            );
            FilterBottomSheet.filtereBottomSheet(
              context: context,
              currentIndex: model.currentIndex,
              doneOnTap: (index, name) {
                presenter.updateDate(index, name);
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.size14,
              vertical: AppSizes.size6,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.backgroundColor.withOpacity(0.20),
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(AppSizes.size26),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  model.selectedMonth['title'],
                  style: AppTextStyle.semiBold14.copyWith(
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(
                  width: AppSizes.size8,
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: AppSizes.size18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget expiringButton() {
    return Row(
      children: [
        RoundedBorderButton(
          text: 'Expiring',
          height: 30,
          width: 100,
          bColor: AppColors.backgroundColor,
          bgColor: model.isExpiring ? AppColors.backgroundColor : null,
          tColor: model.isExpiring
              ? AppColors.whiteColor
              : AppColors.backgroundColor,
          onTap: () {
            presenter.updateExpiringIndex(true);
          },
        ),
        const SizedBox(
          width: 14,
        ),
        RoundedBorderButton(
          text: 'Expired',
          height: 30,
          width: 100,
          bColor: AppColors.backgroundColor,
          bgColor: !model.isExpiring ? AppColors.backgroundColor : null,
          tColor: !model.isExpiring
              ? AppColors.whiteColor
              : AppColors.backgroundColor,
          onTap: () {
            presenter.updateExpiringIndex(false);
          },
        ),
      ],
    );
  }

  Widget listViewBuilderOne() {
    return model.merchantList == null
        ? const SizedBox()
        : model.merchantList!.isEmpty
            ? Center(
                child: Text(
                  'Merchant list is empty',
                  style: AppTextStyle.semiBold22.copyWith(
                    color: AppColors.brownishColor,
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  bottom: AppSizes.size20,
                  left: AppSizes.size20,
                  right: AppSizes.size20,
                ),
                itemCount: model.merchantList!.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: AppSizes.size20,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.all(AppSizes.size20),
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                          color: const Color(0xff000029).withOpacity(.3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(AppSizes.size16),
                      color: AppColors.secondaryContainerColor,
                    ),
                    child: ExpandablePanel(
                      theme: const ExpandableThemeData(
                        useInkWell: true,
                        hasIcon: false,
                      ),
                      header: headerView(index),
                      controller: ExpandableController(
                        initialExpanded:
                            model.merchantList![index].values.toList()[1],
                      ),
                      collapsed: const SizedBox(),
                      expanded: ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) {
                          return Container(
                            height: AppSizes.size14,
                          );
                        },
                        itemCount: model.merchantList![index].values
                            .toList()[0]
                            .length,
                        itemBuilder: (BuildContext context, int i) {
                          MyBounzCardModel myBounzCardModel =
                              model.merchantList![index].values.toList()[0][i];
                          return Container(
                            padding: const EdgeInsets.only(
                                top: AppSizes.size14,
                                bottom: AppSizes.size6,
                                left: AppSizes.size14,
                                right: AppSizes.size14),
                            decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                    color: Color(0x0000001d), blurRadius: 6)
                              ],
                              borderRadius:
                                  BorderRadius.circular(AppSizes.size10),
                              color: AppColors.lightOrangeColor,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      myBounzCardModel.description.toString(),
                                      style: AppTextStyle.bold14.copyWith(
                                        color: AppColors.darkBlueTextColor,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: AppSizes.size8,
                                    ),
                                    Text(
                                      myBounzCardModel
                                          .transactionDate!.ymddateFormat,
                                      style: AppTextStyle.semiBold12.copyWith(
                                        color: AppColors.darkBlueTextColor
                                            .withOpacity(0.50),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: AppSizes.size8,
                                    ),
                                  ],
                                ),
                                Text(
                                  myBounzCardModel.points!.price,
                                  style: AppTextStyle.bold16.copyWith(
                                    color: AppColors.darkBlueTextColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
  }

  Widget listViewBuilderTwo() {
    return model.earnedList == null
        ? const SizedBox()
        : model.earnedList!.isEmpty
            ? Center(
                child: Text(
                  'Earned list is empty',
                  style: AppTextStyle.semiBold22.copyWith(
                    color: AppColors.brownishColor,
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                itemCount: model.earnedList!.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  bottom: AppSizes.size20,
                  left: AppSizes.size20,
                  right: AppSizes.size20,
                ),
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: AppSizes.size20,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return listViewContent(data: model.earnedList![index]);
                },
              );
  }

  Widget listViewBuilderThree() {
    return model.reedemList == null
        ? const SizedBox()
        : model.reedemList!.isEmpty
            ? Center(
                child: Text(
                  'Redeemed list is empty',
                  style: AppTextStyle.semiBold22.copyWith(
                    color: AppColors.brownishColor,
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                itemCount: model.reedemList!.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  bottom: AppSizes.size20,
                  left: AppSizes.size20,
                  right: AppSizes.size20,
                ),
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: AppSizes.size20,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return listViewContent(data: model.reedemList![index]);
                },
              );
  }

  Widget listViewBuilderFour() {
    List<Expir>? currentList;
    if (model.expiryDetails != null) {
      currentList = (model.isExpiring
              ? model.expiryDetails!.expiry
              : model.expiryDetails!.expired) ??
          [];
    }
    return model.expiryDetails == null
        ? const SizedBox()
        : currentList!.isEmpty
            ? Center(
                child: Text(
                  'No BOUNZ Expired',
                  style: AppTextStyle.semiBold22.copyWith(
                    color: AppColors.brownishColor,
                  ),
                ),
              )
            : ListView.separated(
                shrinkWrap: true,
                itemCount: currentList.length,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(
                  bottom: AppSizes.size20,
                  left: AppSizes.size20,
                  right: AppSizes.size20,
                ),
                separatorBuilder: (BuildContext context, int index) {
                  return Container(
                    height: AppSizes.size20,
                  );
                },
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                    decoration: BoxDecoration(
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          blurRadius: 3,
                          offset: const Offset(0, 3),
                          color: const Color(0xff000029).withOpacity(0.3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(AppSizes.size16),
                      color: AppColors.secondaryContainerColor,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.backgroundColor,
                          radius: 20,
                          child: SvgPicture.asset(
                            AppAssets.bounzWhiteLogo,
                            height: AppSizes.size24,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(
                          width: AppSizes.size16,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'BOUNZ',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: AppTextStyle.semiBold16.copyWith(
                                  color: AppColors.blackColor,
                                ),
                              ),
                              const SizedBox(
                                height: AppSizes.size8,
                              ),
                              Text(
                                currentList![index].title.toString(),
                                style: AppTextStyle.semiBold12.copyWith(
                                  color: AppColors.darkBlueTextColor
                                      .withOpacity(0.88),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          currentList[index].points.toString(),
                          style: AppTextStyle.bold16.copyWith(
                            color: AppColors.darkBlueTextColor,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
  }

  Widget listViewContent({
    required MyBounzCardModel data,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 3,
            offset: const Offset(0, 3),
            color: const Color(0xff000029).withOpacity(0.3),
          ),
        ],
        borderRadius: BorderRadius.circular(AppSizes.size16),
        color: AppColors.secondaryContainerColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          data.image != null
              ? Container(
                  height: 30,
                  width: 30,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.backgroundColor,
                  ),
                  child: networkImage(
                    data.image!,
                  ),
                )
              : CircleAvatar(
                  backgroundColor: AppColors.backgroundColor,
                  radius: 20,
                  child: SvgPicture.asset(
                    AppAssets.bounzWhiteLogo,
                    height: AppSizes.size24,
                    fit: BoxFit.cover,
                  ),
                ),
          const SizedBox(
            width: AppSizes.size16,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.activityName.toString(),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  style: AppTextStyle.semiBold16.copyWith(
                    color: AppColors.blackColor,
                  ),
                ),
                const SizedBox(
                  height: AppSizes.size8,
                ),
                Text(
                  data.transactionDate!.ymddateFormat,
                  style: AppTextStyle.semiBold12.copyWith(
                    color: AppColors.darkBlueTextColor.withOpacity(0.88),
                  ),
                ),
                if (data.partnerName != null)
                  const SizedBox(
                    height: AppSizes.size8,
                  ),
                if (data.partnerName != null)
                  Text(
                    data.partnerName.toString(),
                    style: AppTextStyle.bold12.copyWith(
                      decorationThickness: 2,
                      color: AppColors.darkBlueTextColor,
                    ),
                  ),
                if (data.outletName != null)
                  const SizedBox(
                    height: AppSizes.size8,
                  ),
                if (data.outletName != null)
                  Text(
                    data.outletName.toString(),
                    style: AppTextStyle.bold12.copyWith(
                      decorationThickness: 2,
                      color: AppColors.darkBlueTextColor,
                    ),
                  ),
              ],
            ),
          ),
          // const Spacer(),
          Text(
            data.points!.price,
            style: AppTextStyle.bold16.copyWith(
              color: AppColors.darkBlueTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
