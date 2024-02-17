// ignore_for_file: must_be_immutable

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/modules/redeemed_offer/redeem_offer_home/redeem_offer_model.dart';
import 'package:bounz_revamp_app/modules/redeemed_offer/redeem_offer_home/redeem_offer_presenter.dart';
import 'package:bounz_revamp_app/modules/redeemed_offer/redeem_offer_home/redeem_offer_view.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

@RoutePage()
class RedeemedOfferScreen extends StatefulWidget {
  bool? redirectToHome;
  RedeemedOfferScreen({super.key, required this.redirectToHome});

  @override
  State<RedeemedOfferScreen> createState() => _RedeemedOfferScreenState();
}

class _RedeemedOfferScreenState extends State<RedeemedOfferScreen>
    implements RedeemOfferView {
  RedeemOfferPresenter presenter = BasicRedeemOfferViewPresenter();
  late RedeemOfferViewModel model;

  @override
  initState() {
    super.initState();
    presenter.updateView = this;
    presenter.getRedeemOfferData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                if (widget.redirectToHome == true) {
                  AutoRouter.of(context).pushAndPopUntil(
                    MainHomeScreenRoute(index: 4),
                    predicate: (_) => false,
                  );
                } else {
                  Navigator.of(context).pop();
                }
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
              'Redeemed Offers',
              style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
            ),
            Expanded(
                child: model.redeemOfferList == null
                    ? const SizedBox()
                    : model.redeemOfferList!.isEmpty
                        ? Center(
                            child: Text(
                              'Transactions Not Found',
                              style: AppTextStyle.bold20.copyWith(
                                color: AppColors.blueButtonColor,
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: model.redeemOfferList!.length,
                            padding:
                                const EdgeInsets.only(bottom: AppSizes.size20),
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) =>
                                historyContainer(context, index),
                          )),
            const SizedBox(
              height: AppSizes.size10,
            ),
            offerButtonContainer(context),
          ],
        ),
      ),
    );
  }

  Widget historyContainer(
    BuildContext context,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.only(top: AppSizes.size10),
      padding: const EdgeInsets.all(AppSizes.size12),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainerColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            model.redeemOfferList![index].transactionDate ?? "",
            style: AppTextStyle.regular14.copyWith(
              color: AppColors.blackColor,
            ),
          ),
          const SizedBox(
            height: AppSizes.size12,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 70,
                width: 100,
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: networkImage(
                      model.redeemOfferList![index].brandImage ?? ""),
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
                      model.redeemOfferList![index].outletName ?? "",
                      style: AppTextStyle.semiBold16
                          .copyWith(color: AppColors.blackColor),
                    ),
                    Text(
                      "Category - " +
                          (model.redeemOfferList![index].categoryName ?? ""),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: AppTextStyle.regular14
                          .copyWith(color: AppColors.blackColor),
                    ),
                    // const SizedBox(
                    //   height: 6.0,
                    // ),
                    // Text(
                    //   "AED ${model.redeemOfferList![index].pointsRedeemed ?? ""}",
                    //   style: AppTextStyle.bold16
                    //       .copyWith(color: AppColors.blackColor),
                    // )
                  ],
                ),
              )
            ],
          ),
          const SizedBox(
            height: AppSizes.size16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              PrimaryButton(
                text: "View Details",
                height: AppSizes.size40,
                width: MediaQuery.of(context).size.width * .4,
                onTap: () {
                  MoenageManager.logScreenEvent(name: 'Redeemed Offer Details');

                  StorageManager.setStringValue(
                    key: AppStorageKey.outletNameOfferRedeem,
                    value: model.redeemOfferList![index].outletName ?? "",
                  );
                  StorageManager.setStringValue(
                    key: AppStorageKey.outletImgOfferRedeem,
                    value: model.redeemOfferList![index].outletImage ?? "",
                  );
                  StorageManager.setStringValue(
                    key: AppStorageKey.outletDecOfferRedeem,
                    value: model.redeemOfferList![index].offerDescription ?? "",
                  );

                  AutoRouter.of(context).push(
                    const RedeemedOfferDetailsScreenRoute(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget offerButtonContainer(context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: AppSizes.size30),
      child: PrimaryButton(
        bColor: AppColors.btnBlueColor,
        text: AppConstString.viewOffers,
        onTap: () {
          MoenageManager.logScreenEvent(name: 'Offer List');

          AutoRouter.of(context).pushAndPopUntil(MainHomeScreenRoute(index: 3),
              predicate: (_) => false);
        },
      ),
    );
  }

  @override
  void refreshModel(RedeemOfferViewModel redeemOfferViewModel) {
    if(mounted) {
      setState(() {
      model = redeemOfferViewModel;
    });
    }
  }
}
