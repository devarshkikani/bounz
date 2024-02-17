import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/select_reward_exchange/reward_ex_selecttion_view.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/select_reward_exchange/reward_ex_selecttion_model.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/select_reward_exchange/reward_ex_selecttion_presenter.dart';
import 'package:moengage_flutter/properties.dart';

@RoutePage()
class RewardsExSelectionScreen extends StatefulWidget {
  const RewardsExSelectionScreen({super.key});

  @override
  State<RewardsExSelectionScreen> createState() =>
      _RewardsExSelectionScreenState();
}

class _RewardsExSelectionScreenState extends State<RewardsExSelectionScreen>
    implements SelectRewardExchangeView {
  late SelectRewardExchangeViewModel model;
  SelectRewardExchangePresenter presenter =
      BasicSelectRewardExchangePresenter();

  @override
  void refreshModel(
      SelectRewardExchangeViewModel selectRewardExchangeViewModel) {
    setState(() {
      model = selectRewardExchangeViewModel;
    });
  }

  @override
  void initState() {
    super.initState();
    presenter.updateView = this;
    model.smileId = StorageManager.getStringValue(AppStorageKey.smileId) ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        padding: EdgeInsets.zero,
        child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.size20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  Text(
                    AppConstString.rewardExchange,
                    style: AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
                  ),
                  const SizedBox(
                    height: AppSizes.size30,
                  ),
                  delinkContainer(),
                  const SizedBox(
                    height: 30,
                  ),
                  SizedBox(
                    height: 260,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        Positioned(
                          top: 0,
                          child: Image.asset(
                            AppAssets
                                .rewardGirl, // change asset here --- status: pending
                            height: 180,
                          ),
                        ),
                        conversionChoiceContainer(isSmilesToBounz: true),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  conversionChoiceContainer(isSmilesToBounz: false),
                ],
              ),
            )),
      ),
    );
  }

  Widget conversionChoiceContainer({required bool isSmilesToBounz}) {
    return GestureDetector(
      onTap: () {
        final properties = MoEProperties();
        properties.addAttribute(TriggeringCondition.screenName,
            isSmilesToBounz ? 'Smiles To Bounz' : 'Bounz To Smiles');
        MoenageManager.logEvent(
          MoenageEvent.screenView,
          properties: properties,
        );
        isSmilesToBounz
            ? AutoRouter.of(context).push(SmilesToBounzScreenRoute())
            : AutoRouter.of(context).push(BounzToSmilesScreenRoute());
      },
      child: Container(
        padding:
            const EdgeInsets.only(right: AppSizes.size20, top: AppSizes.size10),
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.secondaryContainerColor,
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  width: 40,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      isSmilesToBounz ? "Smiles to BOUNZ" : "BOUNZ to Smiles",
                      style: AppTextStyle.bold16.copyWith(
                        color: AppColors.blackColor,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      isSmilesToBounz
                          ? "Transfer your Smiles\nto BOUNZ."
                          : "Transfer your BOUNZ\nto Smiles.",
                      style: AppTextStyle.regular14
                          .copyWith(color: AppColors.blackColor),
                    )
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 38.0),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    size: 18,
                  ),
                ),
              ],
            ),
            isSmilesToBounz
                ? Positioned(
                    left: -28,
                    bottom: AppSizes.size32,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        AppAssets.handCoinReverse,
                        height: 60,
                      ),
                    ),
                  )
                : Positioned(
                    left: -16,
                    bottom: 10,
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Image.asset(
                        AppAssets.handReverse,
                        height: 110,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget delinkContainer() {
    return Container(
        padding:
            const EdgeInsets.only(right: AppSizes.size20, top: AppSizes.size10),
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.secondaryContainerColor,
          borderRadius: BorderRadius.circular(
            15,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              width: 7,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 5.0),
              child: Icon(
                  Icons.link_outlined), // change icon here --- status: pending
            ),
            const SizedBox(
              width: 7,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 5,
                ),
                Text(
                  AppConstString.linkedMsg,
                  style: AppTextStyle.bold16
                      .copyWith(color: AppColors.blackColor, fontSize: 15),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  model.smileId ?? "",
                  style: AppTextStyle.semiBold16
                      .copyWith(color: AppColors.blackColor, fontSize: 15),
                ),
                const SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    final properties = MoEProperties();
                    properties.addAttribute(
                        TriggeringCondition.programAccountId,
                        model.smileId ?? "");
                    MoenageManager.logEvent(
                      MoenageEvent.delinkAccount,
                      properties: properties,
                    );
                    conformDelinkBottomSheet(context);
                  },
                  child: Text(
                    "Delink",
                    style: AppTextStyle.bold16.copyWith(
                        color: AppColors.blueColorLink,
                        fontSize: 15,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ],
            ),
          ],
        ));
  }

  Future conformDelinkBottomSheet(BuildContext buildContext) {
    return showModalBottomSheet(
      backgroundColor: AppColors.secondaryContainerColor,
      context: buildContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: AppSizes.size20,
            right: AppSizes.size20,
            left: AppSizes.size20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SizedBox(
            height: 190,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstString.confirmText,
                          style: AppTextStyle.bold16
                              .copyWith(color: AppColors.darkBlueTextColor),
                        ),
                        const SizedBox(
                          height: AppSizes.size20,
                        ),
                        Text(
                          'Are you sure you want to delink your Smiles\naccount?',
                          style: AppTextStyle.semiBold14
                              .copyWith(color: AppColors.darkBlueTextColor),
                        ),
                        const SizedBox(
                          height: AppSizes.size30,
                        ),
                      ],
                    ),
                    Padding(
                        padding: const EdgeInsets.only(right: 18.0, bottom: 60),
                        child: SvgPicture.asset(
                          AppAssets.delinkAcc,
                          height: 60,
                        )),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: RoundedBorderButton(
                        height: AppSizes.size60,
                        onTap: () async {
                          bool unlinkStatus = await presenter
                              .unLinkSmileAccount(context, model.smileId!);
                          unlinkMsgBottomSheet(unlinkStatus);
                          if (unlinkStatus) {
                            StorageManager.removeValue(AppStorageKey.smileId);
                          }
                        },
                        bColor: AppColors.btnBlueColor,
                        tColor: AppColors.btnBlueColor,
                        text: AppConstString.proceed,
                      ),
                    ),
                    const SizedBox(
                      width: AppSizes.size10,
                    ),
                    Expanded(
                      child: PrimaryButton(
                        height: AppSizes.size60,
                        text: AppConstString.no,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void unlinkMsgBottomSheet(status) {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.secondaryContainerColor,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.size20),
              topRight: Radius.circular(AppSizes.size20)),
        ),
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
              top: AppSizes.size20,
              right: AppSizes.size20,
              left: AppSizes.size20,
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: SizedBox(
              height: 150.0,
              child: Container(
                margin: const EdgeInsets.only(top: 25, left: 15, right: 15),
                height: status == true ? 110 : 140,
                child: Column(
                  children: <Widget>[
                    Text(
                      status == true
                          ? "Account delinked successfully"
                          : "There is issue in account delinking, please contact administrator.",
                      style: AppTextStyle.bold16.copyWith(
                        color: Colors.black,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                            color: AppColors.lightOrangeColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: PrimaryButton(
                            onTap: () {
                              if (status == true) {
                                MoenageManager.logScreenEvent(
                                    name: 'Main Home');

                                AutoRouter.of(context).pushAndPopUntil(
                                    MainHomeScreenRoute(index: 0),
                                    predicate: (_) => false);
                              } else {
                                Navigator.pop(context);
                                MoenageManager.logScreenEvent(
                                    name: 'Help Support');

                                AutoRouter.of(context).push(
                                  HelpSupportScreenRoute(),
                                );
                              }
                            },
                            text: "OK",
                            height: AppSizes.size36,
                            width: 100.0,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
