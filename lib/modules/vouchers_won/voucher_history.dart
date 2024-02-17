import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/models/partner_coupon/partner_coupon.dart';
import 'package:bounz_revamp_app/modules/vouchers_won/voucher_history_model.dart';
import 'package:bounz_revamp_app/modules/vouchers_won/voucher_history_presenter.dart';
import 'package:bounz_revamp_app/modules/vouchers_won/voucher_history_view.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@RoutePage()
class VoucherWonHistoryScreen extends StatefulWidget {
  final bool fromSplash;
  const VoucherWonHistoryScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  _VoucherWonHistoryScreenState createState() =>
      _VoucherWonHistoryScreenState();
}

class _VoucherWonHistoryScreenState extends State<VoucherWonHistoryScreen>
    implements VoucherHistoryView {
  BasicVoucherHistoryPresenter presenter = BasicVoucherHistoryPresenter();
  late VoucherHistoryModel model;
  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    presenter.getVoucherList(context: context);
    presenter.updateView = this;
    controller = ScrollController()..addListener(_scrollListener);
  }

  _scrollListener() {
    if (controller.position.extentAfter <= 0 &&
        !model.isPageLoading &&
        !model.dataUpdated) {
      presenter.getVoucherList(context: context);
    }
  }

  @override
  void dispose() {
    controller.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  void refreshModel(VoucherHistoryModel voucherHistoryModel) {
    model = voucherHistoryModel;
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromSplash) {
          MoenageManager.logScreenEvent(name: 'Main Home');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(isFirstLoad: true, index: 4),
              predicate: (_) => false);
        } else {
          AutoRouter.of(context).canPop();
        }
        return true;
      },
      child: Scaffold(
        body: AppBackGroundWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
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
              const SizedBox(
                height: AppSizes.size30,
              ),
              Text(
                AppConstString.voucherHistory.toUpperCase(),
                style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
              ),
              Expanded(
                child: model.partnerCouponList == null
                    ? const SizedBox()
                    : model.partnerCouponList!.isEmpty
                        ? Center(
                            child: Text(
                              'Voucher list is empty',
                              style: AppTextStyle.bold22.copyWith(
                                color: AppColors.brownishColor,
                              ),
                            ),
                          )
                        : ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: model.partnerCouponList!.length,
                            controller: controller,
                            itemBuilder: (context, index) {
                              PartnerCouponList couponDetail =
                                  model.partnerCouponList![index];
                              return Padding(
                                padding: EdgeInsets.only(
                                    bottom: (model.partnerCouponList!.length ==
                                            index + 1)
                                        ? 20
                                        : 0),
                                child: historyContainer(
                                    context, couponDetail, index),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget historyContainer(
      BuildContext context, PartnerCouponList couponDetail, int index) {
    return Container(
      margin: const EdgeInsets.only(top: AppSizes.size20),
      padding: const EdgeInsets.only(top: AppSizes.size12),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainerColor,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.size12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            couponDetail.partnerName ?? "",
                            style: AppTextStyle.bold18
                                .copyWith(color: AppColors.blackColor),
                          ),
                          Text(
                            couponDetail.couponName ?? "",
                            style: AppTextStyle.semiBold16
                                .copyWith(color: AppColors.blackColor),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        "Issued : ${couponDetail.creationDate?.ymddateFormatWithoutDay ?? ""}",
                        style: AppTextStyle.regular14.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: AppSizes.size12,
          ),
          Container(
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      couponDetail.couponCode ?? "",
                      style: AppTextStyle.bold16.copyWith(
                        color: AppColors.blackColor,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      NetworkDio.showWarning(
                        context: context,
                        message: 'Your voucher code has been copied!',
                      );
                      Clipboard.setData(
                        ClipboardData(
                          text: couponDetail.couponCode.toString(),
                        ),
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: AppColors.blueButtonColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Text(
                        "Copy code",
                        style: AppTextStyle.regular14.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: AppSizes.size12,
          ),
          detailsButton(index),
        ],
      ),
    );
  }

  Widget detailsButton(int index) {
    return InkWell(
      onTap: () {
        AutoRouter.of(context).navigate(VoucherDetailsScreenRoute(
            partnerCoupon: model.partnerCouponList![index]));
        setState(() {});
      },
      child: Center(
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.blueButtonColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppSizes.size12),
              bottomRight: Radius.circular(AppSizes.size12),
            ),
          ),
          child: Text(
            "View Details",
            style:
                AppTextStyle.semiBold14.copyWith(color: AppColors.whiteColor),
          ),
        ),
      ),
    );
  }
}
