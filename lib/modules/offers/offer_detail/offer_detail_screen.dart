import 'package:bounz_revamp_app/modules/offers/offer_detail/shrimmer_offer_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:bounz_revamp_app/widgets/maputil.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/my_behavior.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/modules/offers/offer_detail/offer_detail_view.dart';
import 'package:bounz_revamp_app/modules/offers/offer_detail/offer_detail_model.dart';
import 'package:bounz_revamp_app/modules/offers/offer_detail/offer_detail_presenter.dart';

// ignore_for_file: deprecated_member_use

@RoutePage()
class OfferDetailScreen extends StatefulWidget {
  final bool fromSplash;
  final String offerCode;
  const OfferDetailScreen({
    Key? key,
    @PathParam('offerCode') required this.offerCode,
    @PathParam('fromSplash') this.fromSplash = false,
  }) : super(key: key);

  @override
  State<OfferDetailScreen> createState() => _OfferDetailScreenState();
}

class _OfferDetailScreenState extends State<OfferDetailScreen>
    implements OfferDetailView {
  late OfferDetailModel model;
  late OfferDetailPresenter presenter;
  MapUtils mapUtils = MapUtils();

  @override
  void refreshModel(OfferDetailModel offerDetailModel) {
    if(mounted) {
      setState(() {
      model = offerDetailModel;
    });
    }
  }

  @override
  void initState() {
    super.initState();
    presenter = BasicOfferDetailPresenter();
    presenter.updateView = this;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      presenter.getOfferDetails(
        offerCode: widget.offerCode,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromSplash) {
          MoenageManager.logScreenEvent(name: 'Main Home');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(isFirstLoad: true, index: 3),
              predicate: (_) => false);
        } else {
          AutoRouter.of(context).canPop();
        }
        return true;
      },
      child: Scaffold(
        body: AppBackGroundWidget(
          padding: EdgeInsets.zero,
          child: model.newOfferDetailModel == null
              ? model.errorMessgae != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppSizes.size20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: AppSizes.size20,
                          ),
                          InkWell(
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
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                model.errorMessgae.toString(),
                                style: AppTextStyle.semiBold22,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : const ShrimmerOfferDetailScreen()
              : Stack(
                  children: [
                    ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 222,
                              alignment: Alignment.topLeft,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(AppSizes.size30),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: CachedNetworkImageProvider(
                                    model
                                            .newOfferDetailModel
                                            ?.allBranches?[
                                                model.selectedOutletIndex]
                                            .outletImage ??
                                        "",
                                  ),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: AppSizes.size20,
                                  top: AppSizes.size20,
                                ),
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
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: const BoxDecoration(
                                color: AppColors.backgroundColor,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(AppSizes.size36),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSizes.size20,
                                  vertical: AppSizes.size20,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          model
                                                  .newOfferDetailModel
                                                  ?.allBranches?[
                                                      model.selectedOutletIndex]
                                                  .outletName ??
                                              "",
                                          style: AppTextStyle.bold16.copyWith(
                                            letterSpacing: 1.6,
                                          ),
                                        ),
                                        const Spacer(),
                                        InkWell(
                                          onTap: () {
                                            mapUtils.openMap(
                                              double.parse(model
                                                  .newOfferDetailModel!
                                                  .allBranches![
                                                      model.selectedOutletIndex]
                                                  .lat!),
                                              double.parse(model
                                                  .newOfferDetailModel!
                                                  .allBranches![
                                                      model.selectedOutletIndex]
                                                  .long!),
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              AppAssets.direction),
                                        ),
                                        const SizedBox(
                                          width: AppSizes.size12,
                                        ),
                                        InkWell(
                                          onTap: () async {
                                            Share.share(
                                              "Hey !! Please check this offer on the BOUNZ app  " +
                                                  model.offerDynamicLin!,
                                            );
                                          },
                                          child: SvgPicture.asset(
                                            AppAssets.share,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      model
                                              .newOfferDetailModel
                                              ?.allBranches?[
                                                  model.selectedOutletIndex]
                                              .outletAddress ??
                                          '',
                                      style: AppTextStyle.regular12.copyWith(
                                        letterSpacing: .5,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    const Divider(
                                      height: 8,
                                      thickness: 0.3,
                                      color: AppColors.whiteColor,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                          AppAssets.locationIcon2,
                                          color: AppColors.whiteColor
                                              .withOpacity(0.85),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                        Text(
                                          '${model.newOfferDetailModel?.allBranches?[model.selectedOutletIndex].distanceInKm} KM Away',
                                          style:
                                              AppTextStyle.regular12.copyWith(
                                            fontSize: 10,
                                            color: AppColors.whiteColor
                                                .withOpacity(0.9),
                                            letterSpacing: .5,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: AppSizes.size20,
                            ),
                            Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppSizes.size20),
                                child: offerSelectedView(context)),
                          ],
                        ),
                      ),
                    ),
                    model.newOfferDetailModel?.type == 'PIN'
                        ? Positioned(
                            bottom: AppSizes.size30,
                            right: 0,
                            left: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PrimaryButton(
                                    showShadow: true,
                                    text: AppConstString.redeemOffer,
                                    onTap: () {
                                      // if (model.newOfferDetailModel?.offers ==
                                      //         null ||
                                      //     model.newOfferDetailModel?.offers
                                      //             ?.isEmpty ==
                                      //         true) {
                                      //   NetworkDio.showError(
                                      //     title: 'Error',
                                      //     context: context,
                                      //     errorMessage:
                                      //         'Offer is not available on this branch',
                                      //   );
                                      // } else {

                                      MoenageManager.logScreenEvent(
                                          name: 'Redeem Bounz');

                                      AutoRouter.of(context).push(
                                        RedeemBounzScreenRoute(
                                          isOffers: true,
                                          selectedIndex:
                                              model.selectedOutletIndex,
                                          offerModel: model.newOfferDetailModel,
                                        ),
                                      );
                                    }
                                    // },
                                    ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget offerSelectedView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstString.offerDetails.toUpperCase(),
          style: AppTextStyle.regular18.copyWith(
            fontFamily: "Bebas",
            letterSpacing: .36,
          ),
        ),
        const SizedBox(
          height: AppSizes.size12,
        ),
        Text(
          model.newOfferDetailModel?.offerDescription ?? "",
          style: AppTextStyle.regular14.copyWith(
            fontSize: 13,
            color: AppColors.whiteColor,
            letterSpacing: .3,
          ),
        ),
        // if (model.newOfferDetailModel?.type == 'PIN')
        branchListView(),
        const SizedBox(
          height: AppSizes.size28,
        ),
        Text(
          AppConstString.termsAndConditionHeader.toUpperCase(),
          style: AppTextStyle.regular18.copyWith(
            fontFamily: "Bebas",
            letterSpacing: .36,
          ),
        ),
        const SizedBox(
          height: AppSizes.size16,
        ),
        Html(
          data: model.newOfferDetailModel?.offerTermsCon,
          style: {
            "body": Style(
              color: AppColors.whiteColor,
              fontSize: FontSize(13.0),
              fontWeight: FontWeight.w400,
              letterSpacing: .3,
            ),
          },
        ),
        const SizedBox(
          height: AppSizes.size100,
        ),
      ],
    );
  }

  Widget branchListView() {
    return model.newOfferDetailModel?.allBranches == null
        ? const SizedBox()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: AppSizes.size36,
              ),
              Text(
                AppConstString.redeemOffersHere.toUpperCase(),
                style: AppTextStyle.regular18.copyWith(
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
                itemCount: model.newOfferDetailModel?.allBranches?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: const EdgeInsets.only(
                        left: AppSizes.size10,
                        right: AppSizes.size10,
                        top: AppSizes.size12,
                        bottom: AppSizes.size10),
                    margin: const EdgeInsets.only(bottom: 10.0),
                    decoration: BoxDecoration(
                      color: model.newOfferDetailModel?.allBranches?[index]
                                  .outletCode ==
                              model
                                  .newOfferDetailModel
                                  ?.allBranches?[model.selectedOutletIndex]
                                  .outletCode
                          ? AppColors.scaffoldColor
                          : AppColors.primaryContainerColor,
                      borderRadius: BorderRadius.circular(AppSizes.size10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              model.selectedOutletIndex = index;
                              setState(() {});
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.newOfferDetailModel?.allBranches?[index]
                                          .outletName ??
                                      "",
                                  style: AppTextStyle.semiBold12,
                                ),
                                const SizedBox(
                                  height: AppSizes.size4,
                                ),
                                Text(
                                  (model
                                              .newOfferDetailModel
                                              ?.allBranches?[index]
                                              .outletAddress ??
                                          "") +
                                      ' • ${model.newOfferDetailModel?.allBranches?[index].distanceInKm} KM Away',
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyle.extraLight12
                                      .copyWith(fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            mapUtils.openMap(
                              double.parse(model.newOfferDetailModel!
                                  .allBranches![index].lat!),
                              double.parse(model.newOfferDetailModel!
                                  .allBranches![index].long!),
                            );
                          },
                          child: SvgPicture.asset(AppAssets.direction),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
  }
}
