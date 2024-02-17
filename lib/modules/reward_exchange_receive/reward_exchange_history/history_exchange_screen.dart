import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/models/reward_exchange/history_exchange.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/reward_exchange_history/history_exchange_model.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/reward_exchange_history/history_exchange_view.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/reward_exchange_history/history_exchange_presenter.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';

@RoutePage()
class ExchangeHistoryScreen extends StatefulWidget {
  const ExchangeHistoryScreen({Key? key}) : super(key: key);

  @override
  _ExchangeHistoryScreenState createState() => _ExchangeHistoryScreenState();
}

class _ExchangeHistoryScreenState extends State<ExchangeHistoryScreen>
    implements HistoryExchangeView {
  late HistoryExchangeViewModel model;
  HistoryExchangePresenter presenter = BasicHistoryExchangePresenter();

  @override
  void initState() {
    super.initState();
    presenter.updateView = this;
    presenter.getHistoryList(context);
  }

  @override
  void refreshModel(HistoryExchangeViewModel historyExchangeViewModel) {
    setState(() {
      model = historyExchangeViewModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    AutoRouter.of(context).pop();
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
                  AppConstString.exchangeHistory,
                  style: AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
                ),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                Expanded(
                  child: model.historyList == null
                      ? const SizedBox()
                      : model.historyList!.isEmpty
                          ? Center(
                              child: Text(
                                'List is empty',
                                style: AppTextStyle.bold22.copyWith(
                                  color: AppColors.brownishColor,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: model.historyList!.length,
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(
                                bottom: AppSizes.size80,
                              ),
                              itemBuilder: (BuildContext context, int index) {
                                HistoryDataList historyItem =
                                    model.historyList![index];
                                return Container(
                                  // width: 20.w,
                                  padding:
                                      const EdgeInsets.all(AppSizes.size16),
                                  margin: const EdgeInsets.symmetric(
                                      vertical: AppSizes.size6),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryContainerColor,
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        historyItem.transactionSubType! == "OS"
                                            ? 'Smiles To Bounz'
                                            : 'Bounz To Smiles',
                                        style: AppTextStyle.bold14.copyWith(
                                            color: AppColors.blackColor),
                                      ),
                                      const SizedBox(
                                        height: AppSizes.size6,
                                      ),
                                      const Divider(
                                        color: AppColors.whiteColor,
                                      ),
                                      const SizedBox(
                                        height: AppSizes.size10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${historyItem.transactionSubType! == "OS" ? "Smiles" : "Bounz"} ${AppConstString.pointsConversion}",
                                            style: AppTextStyle.regular12
                                                .copyWith(
                                                    color:
                                                        AppColors.blackColor),
                                          ),
                                          const SizedBox(
                                            width: AppSizes.size1,
                                          ),
                                          Text(
                                            historyItem.pointsSource.toString(),
                                            style: AppTextStyle.bold14.copyWith(
                                                color: AppColors.blackColor),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: AppSizes.size10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "${historyItem.transactionSubType! == "OS" ? "Bounz" : "Smiles"} ${AppConstString.pointsReceived}",
                                            style: AppTextStyle.regular12
                                                .copyWith(
                                                    color:
                                                        AppColors.blackColor),
                                          ),
                                          const SizedBox(
                                            width: AppSizes.size1,
                                          ),
                                          Text(
                                            historyItem.pointsConverted
                                                .toString(),
                                            style: AppTextStyle.bold14.copyWith(
                                                color: AppColors.blackColor),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: AppSizes.size10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            AppConstString.transactionStatus,
                                            style: AppTextStyle.regular12
                                                .copyWith(
                                                    color:
                                                        AppColors.blackColor),
                                          ),
                                          const SizedBox(
                                            width: AppSizes.size1,
                                          ),
                                          Text(
                                            historyItem.status ?? "",
                                            style: AppTextStyle.bold14.copyWith(
                                                color: AppColors.blackColor),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: AppSizes.size10,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            AppConstString.transactionDate,
                                            style: AppTextStyle.regular12
                                                .copyWith(
                                                    color:
                                                        AppColors.blackColor),
                                          ),
                                          const SizedBox(
                                            width: AppSizes.size1,
                                          ),
                                          Text(
                                            DateTime.parse(
                                              historyItem.transactionDate
                                                  .toString(),
                                            ).ymddateFormatWithoutDay,
                                            style: AppTextStyle.bold14.copyWith(
                                                color: AppColors.blackColor),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.size10),
                      child: PrimaryButton(
                        onTap: () {
                          AutoRouter.of(context)
                              .replace(const RewardsExSelectionScreenRoute());
                        },
                        text: 'Convert Your Points',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
