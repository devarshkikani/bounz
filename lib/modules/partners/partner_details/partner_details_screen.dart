import 'dart:async';
import 'dart:convert';
import 'package:bounz_revamp_app/widgets/shrimmer_widet.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:auto_route/auto_route.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bounz_revamp_app/widgets/maputil.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/my_behavior.dart';
import 'package:bounz_revamp_app/widgets/blink_widget.dart';
import 'package:bounz_revamp_app/services/dynamiclinks.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/models/partner/new_partner_detail_model.dart';
import 'package:bounz_revamp_app/modules/partners/offers_container_widget.dart';
import 'package:bounz_revamp_app/modules/partners/partner_details/partner_details_view.dart';
import 'package:bounz_revamp_app/modules/partners/partner_details/partner_details_model.dart';
import 'package:bounz_revamp_app/modules/partners/partner_details/partner_details_presenter.dart';

@RoutePage()
class PartnerDetailsScreen extends StatefulWidget {
  final bool fromSplash;
  final String? merchantCode;
  final String? brandCode;
  const PartnerDetailsScreen({
    Key? key,
    @PathParam('brandCode') this.brandCode,
    @PathParam('merchantCode') this.merchantCode,
    @PathParam('fromSplash') this.fromSplash = false,
  }) : super(key: key);

  @override
  State<PartnerDetailsScreen> createState() => _PartnerDetailsScreenState();
}

class _PartnerDetailsScreenState extends State<PartnerDetailsScreen>
    implements PartnerDetailsView {
  late PartnerDetailsModel model;
  late PartnerDetailsPresenter presenter;
  bool isSharing = false;
  bool canShare = true;
  MapUtils mapUtils = MapUtils();

  @override
  void refreshModel(PartnerDetailsModel partnerDetailsModel) {
    if(mounted) {
      setState(() {
      model = partnerDetailsModel;
    });
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.brandCode != null) {
      presenter = BasicPartnerDetailsPresenter(
        brandCode: widget.brandCode!,
        merchantCode: widget.merchantCode!,
      );
    }
    presenter.updateView = this;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      presenter.getPartnerDetails(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromSplash) {
          MoenageManager.logScreenEvent(name: 'Main Home');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(isFirstLoad: true, index: 1),
              predicate: (_) => false);
        } else {
          AutoRouter.of(context).canPop();
        }
        return true;
      },
      child: Scaffold(
        body: AppBackGroundWidget(
          padding: EdgeInsets.zero,
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 250,
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppSizes.size30),
                      ),
                      color: AppColors.whiteColor,
                      image: model.newPartnerDetailModel == null
                          ? null
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: Image(
                                image: CachedNetworkImageProvider(
                                  model
                                          .newPartnerDetailModel!
                                          .allBranches![
                                              model.selectedBranchIndex]
                                          .bannerImage ??
                                      "",
                                ),
                              ).image,
                            ),
                    ),
                    child: model.newPartnerDetailModel == null
                        ? CustomShrimmerWidget.rectangular(
                            height: 250,
                            width: MediaQuery.of(context).size.width,
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: AppSizes.size20,
                                    top: AppSizes.size20),
                                child: InkWell(
                                  onTap: () {
                                    if (widget.fromSplash) {
                                      MoenageManager.logScreenEvent(
                                          name: 'Main Home');
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
                                    color: AppColors.blackColor,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              if (model.newPartnerDetailModel!.partInRedeem ==
                                  true)
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.all(10),
                                  color: AppColors.darkOrangeColor,
                                  alignment: Alignment.center,
                                  child: Text(
                                    model.newPartnerDetailModel!
                                            .brandTermsCondition ??
                                        'You can redeem up to ${GlobalSingleton.userInformation.pointBalance?.price} BOUNZ',
                                    style: AppTextStyle.regular14.copyWith(
                                        color: AppColors.darkBlueTextColor),
                                  ),
                                ),
                            ],
                          ),
                  ),
                  partnerDetailsView(),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: AppSizes.size20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        photosView(),
                        model.newPartnerDetailModel == null
                            ? const SizedBox(
                                height: AppSizes.size20,
                              )
                            : model
                                    .newPartnerDetailModel!
                                    .allBranches![model.selectedBranchIndex]
                                    .allPhotos!
                                    .isNotEmpty
                                ? const SizedBox(
                                    height: AppSizes.size20,
                                  )
                                : const SizedBox(),
                        collectBounzView(),
                        const SizedBox(
                          height: AppSizes.size20,
                        ),
                        model.newPartnerDetailModel == null
                            ? const SizedBox()
                            : offersView(),
                        model.newPartnerDetailModel == null
                            ? const SizedBox()
                            : const SizedBox(
                                height: AppSizes.size20,
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget partnerDetailsView() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppSizes.size36),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: AppSizes.size20,
            ),
            model.newPartnerDetailModel == null
                ? const CustomShrimmerWidget.rectangular(
                    height: 10,
                    width: 200,
                  )
                : Text(
                    model.newPartnerDetailModel!
                            .allBranches?[model.selectedBranchIndex].title ??
                        "",
                    style: AppTextStyle.bold16.copyWith(
                      letterSpacing: 1.6,
                    ),
                  ),
            const SizedBox(
              height: AppSizes.size10,
            ),
            model.newPartnerDetailModel == null
                ? const CustomShrimmerWidget.rectangular(
                    height: 10,
                    width: 80,
                  )
                : Text(
                    model.newPartnerDetailModel!
                            .allBranches?[model.selectedBranchIndex].address ??
                        "",
                    style: AppTextStyle.regular12.copyWith(
                      letterSpacing: .5,
                    ),
                  ),
            const SizedBox(
              height: AppSizes.size10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: model.newPartnerDetailModel == null
                      ? null
                      : () {
                          daywiseTimeBottomSheet(
                            model
                                .newPartnerDetailModel!
                                .allBranches?[model.selectedBranchIndex]
                                .outletWeekDayOpeningTime,
                            model
                                .newPartnerDetailModel!
                                .allBranches?[model.selectedBranchIndex]
                                .outletWeekDayClosingTime,
                            model
                                .newPartnerDetailModel!
                                .allBranches?[model.selectedBranchIndex]
                                .outletWeekEndOpeningTime,
                            model
                                .newPartnerDetailModel!
                                .allBranches?[model.selectedBranchIndex]
                                .outletWeekEndClosingTime,
                          );
                        },
                  child: Row(
                    children: [
                      model.newPartnerDetailModel == null
                          ? const CustomShrimmerWidget.circular(
                              height: 10,
                              width: 10,
                            )
                          : Transform.scale(
                              scale: 1.0,
                              child: model
                                          .newPartnerDetailModel!
                                          .allBranches?[
                                              model.selectedBranchIndex]
                                          .currentStatus ==
                                      CurrentStatus.open
                                  ? const BlinkWidget(
                                      children: <Widget>[
                                        Icon(
                                          Icons.brightness_1,
                                          size: 12.0,
                                          color: AppColors.successColor,
                                        ),
                                        Icon(Icons.brightness_1,
                                            size: 12.0,
                                            color: Colors.transparent),
                                      ],
                                    )
                                  : const Icon(
                                      Icons.brightness_1,
                                      size: 12.0,
                                      color: AppColors.errorColor,
                                    ),
                            ),
                      const SizedBox(
                        width: AppSizes.size6,
                      ),
                      model.newPartnerDetailModel == null
                          ? const CustomShrimmerWidget.rectangular(
                              height: 10,
                              width: 40,
                            )
                          : Text(
                              model
                                          .newPartnerDetailModel!
                                          .allBranches?[
                                              model.selectedBranchIndex]
                                          .currentStatus ==
                                      CurrentStatus.open
                                  ? 'Open'
                                  : 'Closed',
                              style: AppTextStyle.bold12.copyWith(
                                letterSpacing: .6,
                              ),
                            ),
                      model.newPartnerDetailModel == null
                          ? const CustomShrimmerWidget.rectangular(
                              height: 10,
                              width: 10,
                            )
                          : const Icon(
                              Icons.keyboard_arrow_down_outlined,
                              color: AppColors.whiteColor,
                              size: 20.0,
                            )
                    ],
                  ),
                ),
                Row(
                  children: [
                    model.newPartnerDetailModel == null
                        ? const CustomShrimmerWidget.circular(
                            height: 20,
                            width: 20,
                          )
                        : GestureDetector(
                            onTap: () {
                              mapUtils.openMap(
                                  model.branchlat, model.branchlong);
                            },
                            child: SvgPicture.asset(AppAssets.direction)),
                    const SizedBox(
                      width: AppSizes.size12,
                    ),
                    model.newPartnerDetailModel == null
                        ? const CustomShrimmerWidget.circular(
                            height: 20,
                            width: 20,
                          )
                        : GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              if (!canShare) {
                                return;
                              }

                              if (isSharing) {
                                return;
                              }

                              isSharing = true;

                              var data = {
                                "brandCode":
                                    model.newPartnerDetailModel!.brandCode,
                                "merchantCode":
                                    model.newPartnerDetailModel!.merchantCode
                              };

                              var encodeddata = json.encode(data);
                              var url = await FirebaseDynamicLinkService()
                                  .createPartnerDeepLink(encodeddata);

                              await Share.share(
                                  "Hey !! Please check this outlet on the BOUNZ app  " +
                                      url);
                              isSharing = false;

                              canShare = false;
                              Timer(const Duration(seconds: 1), () {
                                canShare = true;
                              });
                            },
                            child: SvgPicture.asset(AppAssets.share),
                          ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: AppSizes.size10,
            ),
            const Divider(
              thickness: 0.3,
              color: AppColors.whiteColor,
            ),
            const SizedBox(
              height: AppSizes.size10,
            ),
            overviewSection(),
            const SizedBox(
              height: AppSizes.size20,
            ),
          ],
        ),
      ),
    );
  }

  Widget timeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () {
            daywiseTimeBottomSheet(
              model
                  .newPartnerDetailModel!
                  .allBranches?[model.selectedBranchIndex]
                  .outletWeekDayOpeningTime,
              model
                  .newPartnerDetailModel!
                  .allBranches?[model.selectedBranchIndex]
                  .outletWeekDayClosingTime,
              model
                  .newPartnerDetailModel!
                  .allBranches?[model.selectedBranchIndex]
                  .outletWeekEndOpeningTime,
              model
                  .newPartnerDetailModel!
                  .allBranches?[model.selectedBranchIndex]
                  .outletWeekEndClosingTime,
            );
          },
          child: Row(
            children: [
              Transform.scale(
                scale: 1.0,
                child: model
                            .newPartnerDetailModel!
                            .allBranches?[model.selectedBranchIndex]
                            .currentStatus ==
                        CurrentStatus.open
                    ? const BlinkWidget(
                        children: <Widget>[
                          Icon(
                            Icons.brightness_1,
                            size: 12.0,
                            color: AppColors.successColor,
                          ),
                          Icon(
                            Icons.brightness_1,
                            size: 12.0,
                            color: Colors.transparent,
                          ),
                        ],
                      )
                    : const Icon(
                        Icons.brightness_1,
                        size: 12.0,
                        color: AppColors.errorColor,
                      ),
              ),
              const SizedBox(
                width: AppSizes.size6,
              ),
              Text(
                model
                            .newPartnerDetailModel!
                            .allBranches?[model.selectedBranchIndex]
                            .currentStatus ==
                        CurrentStatus.open
                    ? 'Open'
                    : 'Closed',
                style: AppTextStyle.bold12.copyWith(
                  letterSpacing: .6,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_outlined,
                color: AppColors.whiteColor,
                size: 20.0,
              )
            ],
          ),
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                mapUtils.openMap(model.branchlat, model.branchlong);
              },
              child: Image.asset(AppAssets.direction),
            ),
            const SizedBox(
              width: AppSizes.size12,
            ),
            InkWell(
              onTap: () async {
                var data = {
                  "all_branches": model.newPartnerDetailModel!.allBranches,
                  "name": model.newPartnerDetailModel!.name,
                  "partInRedeem": model.newPartnerDetailModel!.partInRedeem,
                  "brandTermsCondition":
                      model.newPartnerDetailModel!.brandTermsCondition,
                };

                var encodeddata = json.encode(data);
                var url = await FirebaseDynamicLinkService()
                    .createPartnerDeepLink(encodeddata);

                await Share.share(
                    "Hey !! Please check this outlet on the BOUNZ app  " + url);
              },
              child: SvgPicture.asset(
                AppAssets.share,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget overviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            model.newPartnerDetailModel == null
                ? const CustomShrimmerWidget.rectangular(
                    height: 15,
                    width: 70,
                  )
                : Text(
                    AppConstString.overview.toUpperCase(),
                    style: AppTextStyle.bold18.copyWith(
                      fontFamily: "Bebas",
                      letterSpacing: .36,
                    ),
                  ),
            model.newPartnerDetailModel == null
                ? const CustomShrimmerWidget.rectangular(
                    height: 15,
                    width: 70,
                  )
                : const SizedBox(),
            if (model.newPartnerDetailModel != null)
              if (model.newPartnerDetailModel!.allBranches != null) ...[
                model.newPartnerDetailModel!.allBranches!.length > 1
                    ? GestureDetector(
                        onTap: () {
                          MoenageManager.logScreenEvent(name: 'Branches');
                          AutoRouter.of(context).push(
                            BranchesScreenRoute(
                              allBranches:
                                  model.newPartnerDetailModel!.allBranches!,
                              distance: model.distance,
                              branchName: model.newPartnerDetailModel!.name,
                              selected: model.selectedBranchIndex,
                              onTap: (int index) {
                                presenter.updateData(index);
                                setState(() {});
                              },
                            ),
                          );
                        },
                        child: Text(
                          AppConstString.viewBranches,
                          style: AppTextStyle.bold12.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    : const SizedBox()
              ]
          ],
        ),
        const SizedBox(
          height: AppSizes.size16,
        ),
        model.newPartnerDetailModel == null
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShrimmerWidget.rectangular(
                    height: 6,
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomShrimmerWidget.rectangular(
                    height: 6,
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  CustomShrimmerWidget.rectangular(
                    height: 6,
                    width: MediaQuery.of(context).size.width * .4,
                  )
                ],
              )
            : ReadMoreText(
                (model.newPartnerDetailModel!
                            .allBranches?[model.selectedBranchIndex].desc ??
                        "") +
                    " ",
                trimLines: 3,
                style: AppTextStyle.regular12.copyWith(
                  letterSpacing: .6,
                ),
                colorClickableText: AppColors.whiteColor,
                trimMode: TrimMode.Line,
                trimCollapsedText: AppConstString.viewMore,
                trimExpandedText: AppConstString.viewLess,
                lessStyle: AppTextStyle.regular12.copyWith(
                  decoration: TextDecoration.underline,
                ),
                moreStyle: AppTextStyle.regular12.copyWith(
                  decoration: TextDecoration.underline,
                ),
              ),
      ],
    );
  }

  Widget photosView() {
    return model.newPartnerDetailModel == null
        ? Column(
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomShrimmerWidget.rectangular(
                    height: 15,
                    width: 70,
                  ),
                  CustomShrimmerWidget.rectangular(
                    height: 10,
                    width: 70,
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.size16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CustomShrimmerWidget.rectangular(
                    height: 100.0,
                    width: (MediaQuery.of(context).size.width - 60) * 0.3,
                  ),
                  const SizedBox(
                    width: AppSizes.size10,
                  ),
                  CustomShrimmerWidget.rectangular(
                    height: 100.0,
                    width: (MediaQuery.of(context).size.width - 60) * 0.3,
                  ),
                  const SizedBox(
                    width: AppSizes.size10,
                  ),
                  CustomShrimmerWidget.rectangular(
                    height: 100.0,
                    width: (MediaQuery.of(context).size.width - 60) * 0.3,
                  ),
                ],
              ),
            ],
          )
        : model.newPartnerDetailModel!.allBranches![model.selectedBranchIndex]
                .allPhotos!.isEmpty
            ? const SizedBox()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppConstString.photos.toUpperCase(),
                        style: AppTextStyle.bold18.copyWith(
                          fontFamily: "Bebas",
                          letterSpacing: .36,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          MoenageManager.logScreenEvent(name: 'Partner Photos');

                          AutoRouter.of(context).push(
                            PartnerPhotosScreenRoute(
                              patnername:
                                  model.newPartnerDetailModel!.name.toString(),
                              location: model
                                  .newPartnerDetailModel!
                                  .allBranches![model.selectedBranchIndex]
                                  .address
                                  .toString(),
                              photos: model
                                  .newPartnerDetailModel!
                                  .allBranches![model.selectedBranchIndex]
                                  .allPhotos!,
                            ),
                          );
                        },
                        child: Text(
                          AppConstString.viewAll,
                          style: AppTextStyle.semiBold12.copyWith(
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.size16,
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      model
                                  .newPartnerDetailModel!
                                  .allBranches![model.selectedBranchIndex]
                                  .allPhotos!
                                  .length >
                              1
                          ? networkPhotosContainer(
                              model
                                  .newPartnerDetailModel!
                                  .allBranches![model.selectedBranchIndex]
                                  .allPhotos![0],
                              context)
                          : const SizedBox(),
                      const SizedBox(
                        width: AppSizes.size10,
                      ),
                      model
                                  .newPartnerDetailModel!
                                  .allBranches![model.selectedBranchIndex]
                                  .allPhotos!
                                  .length >
                              2
                          ? networkPhotosContainer(
                              model
                                  .newPartnerDetailModel!
                                  .allBranches![model.selectedBranchIndex]
                                  .allPhotos![1],
                              context)
                          : const SizedBox(),
                      const SizedBox(
                        width: AppSizes.size10,
                      ),
                      model
                                  .newPartnerDetailModel!
                                  .allBranches![model.selectedBranchIndex]
                                  .allPhotos!
                                  .length >
                              3
                          ? networkPhotosContainer(
                              model
                                  .newPartnerDetailModel!
                                  .allBranches![model.selectedBranchIndex]
                                  .allPhotos![2],
                              context)
                          : const SizedBox(),
                    ],
                  ),
                ],
              );
  }

  Widget collectBounzView() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          model.newPartnerDetailModel == null
              ? const CustomShrimmerWidget.rectangular(
                  height: 15,
                  width: 100,
                )
              : Text(
                  AppConstString.collectBounz.toUpperCase(),
                  style: AppTextStyle.bold18.copyWith(
                    fontFamily: "Bebas",
                    letterSpacing: .36,
                  ),
                ),
          const SizedBox(
            height: AppSizes.size16,
          ),
          model.newPartnerDetailModel == null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: CustomShrimmerWidget.rectangular(
                        height: 200,
                        width: MediaQuery.of(context).size.width * .3,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: CustomShrimmerWidget.rectangular(
                        height: 200,
                        width: MediaQuery.of(context).size.width * .3,
                      ),
                    ),
                  ],
                )
              : GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: AppSizes.size20,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: AppSizes.size14,
                  childAspectRatio:
                      GlobalSingleton.osType == "ios" ? 2.7 / 3.5 : 2.5 / 3.5,
                  children: List.generate(
                    model.collectList.length,
                    (index) => _cardEarnBNZ(
                      listData: model.collectList[index],
                      index: index,
                      totallength: model.collectList.length,
                      title: 'Collect',
                    ),
                  ),
                ),
          SizedBox(
            height: model.newPartnerDetailModel == null
                ? 15
                : model.redeemList.isNotEmpty
                    ? 15
                    : 0,
          ),
          model.newPartnerDetailModel == null
              ? const CustomShrimmerWidget.rectangular(
                  height: 15,
                  width: 100,
                )
              : model.redeemList.isNotEmpty
                  ? Text(
                      AppConstString.redeemBounz.toUpperCase(),
                      style: AppTextStyle.bold18.copyWith(
                        fontFamily: "Bebas",
                        letterSpacing: .36,
                      ),
                    )
                  : const SizedBox(),
          SizedBox(
            height: model.newPartnerDetailModel == null
                ? AppSizes.size16
                : model.redeemList.isNotEmpty
                    ? AppSizes.size16
                    : 0,
          ),
          model.newPartnerDetailModel == null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: CustomShrimmerWidget.rectangular(
                        height: 200,
                        width: MediaQuery.of(context).size.width * .3,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      child: CustomShrimmerWidget.rectangular(
                        height: 200,
                        width: MediaQuery.of(context).size.width * .3,
                      ),
                    ),
                  ],
                )
              : model.redeemList.isNotEmpty
                  ? GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 20.0,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: AppSizes.size14,
                      childAspectRatio: GlobalSingleton.osType == "ios"
                          ? 2.7 / 3.5
                          : 2.6 / 3.5,
                      children: List.generate(
                        model.redeemList.length,
                        (index) => _cardEarnBNZ(
                          listData: model.redeemList[index],
                          index: index,
                          totallength: model.redeemList.length,
                          title: 'Redeem',
                        ),
                      ),
                    )
                  : const SizedBox(),
        ],
      ),
    );
  }

  Widget _cardEarnBNZ({
    required AllBranchLobType listData,
    required int index,
    required int totallength,
    required String title,
  }) {
    return OffersContainerWidget(
      headingTxt: listData.title ?? "",
      subTitleTxt: listData.subtitle ?? "",
      iconName: listData.icon ?? '',
      title: title,
      btnBgColor: AppColors.btnBlueColor,
      btnTxtColor: AppColors.whiteColor,
      btnText: getButtonText(listData.type!),
      onTap: () {
        presenter.manageClick(
          brandData: model.newPartnerDetailModel!,
          index: index,
          listData: listData,
          type: listData.type!,
          context: context,
        );
      },
    );
  }

  String getButtonText(Type type) {
    switch (type) {
      case Type.click:
        return "Click";
      case Type.visit:
        return "Visit";
      case Type.spend:
        return "Earn";
      case Type.spdon:
        return "Earn";
      case Type.spdinstr:
        return "Earn";
      case Type.redeem:
        return "Redeem";
      case Type.rdmon:
        return "Redeem Online";
      case Type.afl:
        return "Visit Now";
      case Type.eshop:
        return "Click";
      case Type.posredeem:
        return "Redeem";
    }
  }

  Widget offersView() {
    return model.partneroOutletDetailModel?.offers?.isNotEmpty ?? false
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstString.offers.toUpperCase(),
                style: AppTextStyle.bold18.copyWith(
                  fontFamily: "Bebas",
                  letterSpacing: .36,
                ),
              ),
              const SizedBox(
                height: AppSizes.size16,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: model.partneroOutletDetailModel?.offers?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      MoenageManager.logScreenEvent(name: 'Offer Details');
                      AutoRouter.of(context).pushNamed(
                          '/offer_detail_screen/${model.partneroOutletDetailModel?.offers?[index].offerCode}/false');
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSizes.size16),
                      margin: const EdgeInsets.only(bottom: 15.0),
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: AssetImage(
                            AppAssets.offersBg,
                          ),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(AppSizes.size10),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  AppAssets.offersCopyIcon,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    model.partneroOutletDetailModel
                                            ?.offers?[index].offerTitle ??
                                        '',
                                    style: AppTextStyle.semiBold14
                                        .copyWith(color: AppColors.blackColor),
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios,
                            size: AppSizes.size16,
                            color: AppColors.blackColor,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        : const SizedBox();
  }

  Widget photosContainer(String? image, context) {
    return Expanded(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Image.asset(
          image!,
          height: 100.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget networkPhotosContainer(String? image, context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5.0),
      child: networkImage(
        image!,
        height: 100.0,
        width: (MediaQuery.of(context).size.width - 60) * 0.3,
      ),
    );
  }

  Widget dayWiseTimeWidget(
    String? txt,
    String? openingTime,
    String? closingTime,
    int index,
  ) {
    if (openingTime == "null" || openingTime == null) {
      openingTime = "";
    }
    if (closingTime == "null" || closingTime == null) {
      closingTime = "";
    }
    String todayName = DateFormat('EEEE').format(DateTime.now());
    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSizes.size10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            txt!,
            style: AppTextStyle.regular14.copyWith(
              fontWeight:
                  txt == todayName ? FontWeight.bold : FontWeight.normal,
              color: txt == todayName
                  ? AppColors.darkBlueTextColor
                  : AppColors.darkBlueTextColor.withOpacity(.6),
            ),
          ),
          Text(
            '$openingTime - $closingTime',
            style: AppTextStyle.regular14.copyWith(
              fontWeight:
                  txt == todayName ? FontWeight.bold : FontWeight.normal,
              color: txt == todayName
                  ? AppColors.darkBlueTextColor
                  : AppColors.darkBlueTextColor.withOpacity(.6),
            ),
          )
        ],
      ),
    );
  }

  List<String> generateWeekDays() {
    final now = DateTime.now();
    var daysOfWeek = now.day;

    final weekdays = <String>[];

    for (int i = 0; i < 7; i++) {
      final day = now.add(Duration(days: i - now.weekday + daysOfWeek));
      final weekdayName = DateFormat('EEEE').format(day);
      weekdays.add(weekdayName);
    }

    return weekdays;
  }

  void daywiseTimeBottomSheet(
      String? outletWeekDayOpeningTime,
      String? outletWeekDayClosingTime,
      String? outletWeekEndOpeningTime,
      String? outletWeekEndClosingTime) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.secondaryContainerColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      builder: (context) {
        final weekDays = generateWeekDays();
        return SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Store Timing",
                  style:
                      AppTextStyle.bold16.copyWith(color: AppColors.blackColor),
                ),
                const SizedBox(height: AppSizes.size10),
                Column(
                  children: List.generate(
                    weekDays.length,
                    (index) {
                      return dayWiseTimeWidget(
                          weekDays[index],
                          weekDays[index] == 'Saturday' ||
                                  weekDays[index] == 'Sunday'
                              ? outletWeekEndOpeningTime
                              : outletWeekDayOpeningTime,
                          weekDays[index] == 'Saturday' ||
                                  weekDays[index] == 'Sunday'
                              ? outletWeekEndClosingTime
                              : outletWeekDayClosingTime,
                          index);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
