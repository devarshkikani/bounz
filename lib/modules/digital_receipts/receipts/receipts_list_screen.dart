import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/degital_receipts/receipts_model.dart';
import 'package:bounz_revamp_app/modules/digital_receipts/receipt_view/receipts_view_presenter.dart';
import 'package:bounz_revamp_app/modules/digital_receipts/receipts/receipts_list_model.dart';
import 'package:bounz_revamp_app/modules/digital_receipts/receipts/receipts_list_presenter.dart';
import 'package:bounz_revamp_app/modules/digital_receipts/receipts/receipts_list_view.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moengage_flutter/properties.dart';
// ignore_for_file: deprecated_member_use

@RoutePage()
class ReceiptsListScreen extends StatefulWidget {
  final bool fromSplash;
  const ReceiptsListScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  State<ReceiptsListScreen> createState() => _ReceiptsListScreenState();
}

class _ReceiptsListScreenState extends State<ReceiptsListScreen>
    implements ReceiptsListView {
  late ReceiptsListModel model;
  final ReceiptsListModelPresenter presenter =
      BasicReceiptsListModelPresenter();

  @override
  void initState() {
    presenter.updateModel = this;
    model.scrollController = ScrollController();
    model.scrollController!.addListener(_onScroll);
    presenter.transactionList(context: context);
    super.initState();
  }

  void _onScroll() {
    if (model.scrollController!.position.pixels == model.scrollController!.position.maxScrollExtent ) {
      if(model.transactionCount != model.receiptsList!.length){
        presenter.transactionList(context: context);
      }
    }
  }

  @override
  void dispose() {
    model.scrollController!.removeListener(_onScroll);
    model.scrollController!.dispose();
    super.dispose();
  }


  @override
  void refreshModel(ReceiptsListModel transectionListModel) {
    if(mounted) {
      setState(() {
      model = transectionListModel;
    });
    }
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
        backgroundColor: AppColors.backgroundColor,
        body: AppBackGroundWidget(
          padding: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.only(
                left: AppSizes.size20,
                right: AppSizes.size20,
                top: AppSizes.size20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  AppConstString.receipts,
                  style: AppTextStyle.regular36.copyWith(
                    fontFamily: 'Bebas',
                  ),
                ),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                Expanded(
                  child: model.receiptsList == null
                      ? const SizedBox()
                      : model.receiptsList!.isEmpty
                          ? Center(
                              child: Text(
                                'Receipts list is empty',
                                style: AppTextStyle.bold22.copyWith(
                                  color: AppColors.brownishColor,
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: model.scrollController,
                              itemCount: model.receiptsList!.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return receiptListDecoration(
                                  receipts: model.receiptsList![index],
                                );
                              },
                            ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget receiptListDecoration({required Receipts receipts}) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.secondaryContainerColor,
          ),
          padding: const EdgeInsets.all(AppSizes.size20),
          margin: const EdgeInsets.only(bottom: AppSizes.size20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ClipOval(
                    child: SizedBox(
                      height: AppSizes.size40,
                      width: AppSizes.size40,
                      child: networkImage(
                        receipts.image.toString(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                width: AppSizes.size16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receipts.partnerName.toString(),
                    style: AppTextStyle.bold14.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    receipts.outletName.toString(),
                    style: AppTextStyle.regular12
                        .copyWith(color: AppColors.blackColor),
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  Text(
                    receipts.transactionDate.toString(),
                    style: AppTextStyle.regular12
                        .copyWith(color: AppColors.blackColor),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    "AED ${receipts.amount.toString()}",
                    style: AppTextStyle.bold14
                        .copyWith(color: AppColors.blackColor),
                  ),
                  const SizedBox(
                    height: AppSizes.size16,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        AppAssets.viewReceipt,
                        color: AppColors.blackColor,
                      ),
                      GestureDetector(
                        onTap: () {
                          final properties = MoEProperties();
                          properties
                              .addAttribute(TriggeringCondition.billNumber,
                                  receipts.billNumber.toString())
                              .addAttribute(TriggeringCondition.screenName,
                                  "ReceiptsList")
                              .addAttribute(TriggeringCondition.amount,
                                  receipts.amount.toString())
                              .setNonInteractiveEvent();
                          MoenageManager.logEvent(
                            MoenageEvent.receiptsSelected,
                            properties: properties,
                          );
                          MoenageManager.logScreenEvent(name: 'Receipt View');

                          AutoRouter.of(context).push(
                            ReceiptViewScreenRoute(
                              presenter: BasicReceiptViewPresenter(
                                billNumber: receipts.billNumber.toString(),
                                partnerId: receipts.partnerId.toString(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          AppConstString.viewReceipt,
                          style: AppTextStyle.bold14.copyWith(
                            color: AppColors.blackColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
