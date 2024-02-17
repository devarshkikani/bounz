import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/info_reward_exchange/info_reward_exchange_model.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/info_reward_exchange/info_reward_exchange_presenter.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/info_reward_exchange/info_reward_exchange_view.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/link_acc_reward_exchange/link_acc_reward_exchange.dart';
import 'package:bounz_revamp_app/widgets/animated_reward.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class InfoRewardExchangeScreen extends StatefulWidget {
  final bool fromSplash;

  const InfoRewardExchangeScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  State<InfoRewardExchangeScreen> createState() =>
      _InfoRewardExchangeScreenState();
}

class _InfoRewardExchangeScreenState extends State<InfoRewardExchangeScreen>
    implements InfoRewardExchangeView {
  late InfoRewardExchangeViewModel model;
  BasicInfoRewardExchangePresenter presenter =
      BasicInfoRewardExchangePresenter();

  @override
  void refreshModel(InfoRewardExchangeViewModel infoRewardExchangeViewModel) {
    if (mounted) {
      setState(() {
        model = infoRewardExchangeViewModel;
        if (model.allMemberModel?.linkedPartners?.length != null) {
          // ignore: prefer_is_empty
          model.isLinked =
              model.allMemberModel!.linkedPartners!.isEmpty ? false : true;

          if (model.isLinked!) {
            StorageManager.setStringValue(
                key: AppStorageKey.smileId,
                value: model
                    .allMemberModel!.linkedPartners![0].targetMembershipNo!);
            StorageManager.setStringValue(
                key: AppStorageKey.smileBal,
                value: (double.parse(model
                        .allMemberModel!.linkedPartners![0].points
                        .toString()))
                    .toString());
            AutoRouter.of(context)
                .replace(const RewardsExSelectionScreenRoute());
          }
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    presenter.updateView = this;
    presenter.getAllMemberData(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (widget.fromSplash) {
          MoenageManager.logScreenEvent(name: 'Main Home');
          AutoRouter.of(context).pushAndPopUntil(
              MainHomeScreenRoute(isFirstLoad: true, index: 0),
              predicate: (_) => false);
        } else {
          AutoRouter.of(context).canPop();
        }
        return true;
      },
      child: Scaffold(
        body: AppBackGroundWidget(
          child: SingleChildScrollView(
            child: Column(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppConstString.rewardExchange,
                      style:
                          AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                const AnimatedReward(),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                Text(AppConstString.reasonSmile,
                    style: AppTextStyle.semiBold18
                        .copyWith(fontFamily: 'SourceSansPro')),
                const SizedBox(
                  height: AppSizes.size2,
                ),
                Text(AppConstString.reasonSmile1,
                    style: AppTextStyle.regular16),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        AppAssets.questionMark,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            'What?',
                            style: AppTextStyle.semiBold18
                                .copyWith(fontFamily: 'SourceSansPro'),
                          ),
                        ),
                        Text(
                          AppConstString.whtSmile,
                          style: AppTextStyle.regular16,
                        ),
                        const SizedBox(
                          height: AppSizes.size20,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: AppSizes.size10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: SvgPicture.asset(
                        AppAssets.questionMark,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Text(
                            'How?',
                            style: AppTextStyle.semiBold18
                                .copyWith(fontFamily: 'SourceSansPro'),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width - 100,
                          child: Text(
                            AppConstString.hwSmile,
                            style: AppTextStyle.regular16,
                            softWrap: true,
                            maxLines: 3,
                          ),
                        ),
                        const SizedBox(
                          height: AppSizes.size10,
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                !model.isLinked!
                    ? Center(
                        child: PrimaryButton(
                          showShadow: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const LinkAccRewardExchangeScreen()
                                  // const RewardExchangeScreen(),
                                  ),
                            );
                            //AutoRouter.of(context).push(const BounzToSmilesScreenRoute());
                          },
                          text: 'link BOUNZ with Smiles',
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: AppSizes.size20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
