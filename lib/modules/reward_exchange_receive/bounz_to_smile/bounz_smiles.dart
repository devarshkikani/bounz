import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/bounz_to_smile/bounz_to_smile_model.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/bounz_to_smile/bounz_to_smile_presenter.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/bounz_to_smile/bounz_to_smile_view.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:moengage_flutter/properties.dart';

@RoutePage()
class BounzToSmilesScreen extends StatefulWidget {
  final bool fromSplash;
  const BounzToSmilesScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  _BounzToSmilesScreenState createState() => _BounzToSmilesScreenState();
}

class _BounzToSmilesScreenState extends State<BounzToSmilesScreen>
    implements BounzToSmileView {
  late BounzToSmileViewModel model;
  BasicBounzToSmilePresenter presenter = BasicBounzToSmilePresenter();

  TextEditingController bounzController = TextEditingController();
  TextEditingController smilesController = TextEditingController();
  int firstAdd = 0;

  @override
  void initState() {
    super.initState();
    GlobalSingleton.isBack = false;
    presenter.updateView = this;
    model.smileId = StorageManager.getStringValue(AppStorageKey.smileId)!;
    model.smilesPointsBal =
        double.parse(StorageManager.getStringValue(AppStorageKey.smileBal)!);
    presenter.getLatestPartnerPointsRefresh(AppStorageKey.smileId);
    model.userBounzPoints =
        GlobalSingleton.userInformation.pointBalance!.toString();
    model.range = double.parse(model.userBounzPoints ?? "");
    bounzController.text = "2000";
    smilesController.text = pointsFormatter(1000);
    model.value = double.parse(bounzController.text);
    model.conversionRateB = 2.0;
    model.conversionRateS = 1.0;
    model.multiple = 2000;
    model.minConversion = 2000;
  }

  @override
  void refreshModel(BounzToSmileViewModel bounzToSmileViewModel) {
    if (mounted) {
      setState(() {
        model = bounzToSmileViewModel;
      });
    }
    if (model.minConversion != null &&
        firstAdd == 0 &&
        model.conversionRate != null) {
      calculatePoints();
    }
  }

  @override
  void dispose() {
    super.dispose();
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
          GlobalSingleton.isBack = true;
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
                    GlobalSingleton.isBack = true;
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
                    model.smilesPointsBal != null
                        ? GestureDetector(
                            onTap: () {
                              final properties = MoEProperties();
                              properties.setNonInteractiveEvent();
                              properties.addAttribute(
                                  TriggeringCondition.screenName,
                                  'Reward Exchange');
                              MoenageManager.logEvent(
                                MoenageEvent.exchangeHistory,
                                properties: properties,
                              );

                              AutoRouter.of(context)
                                  .push(const ExchangeHistoryScreenRoute());
                            },
                            child: SvgPicture.asset(
                              AppAssets.exchange,
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.size30,
                ),
                bounzContainerWidget(),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                Text(
                  "${model.conversionRateB!.round()} BOUNZ = ${model.conversionRateS!.round()} Smiles",
                  style: AppTextStyle.black14,
                ),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                smilesContainerWidget(),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                Text(
                  "Min ${(model.minConversion != null ? model.minConversion!.round() : "")} BOUNZ points can be transferred in multiples of ${model.multiple == 10 ? "" : model.multiple}",
                  style: AppTextStyle.black14,
                ),
                const SizedBox(
                  height: AppSizes.size40,
                ),
                exchangeButtonWidget(),
                const SizedBox(
                  height: AppSizes.size16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bounzContainerWidget() {
    return Container(
      padding:
          const EdgeInsets.only(left: AppSizes.size20, top: AppSizes.size10),
      height: 155,
      decoration: BoxDecoration(
        color: AppColors.rewardExchange1,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          AppConstString.transfer,
                          style: AppTextStyle.semiBold14.copyWith(
                            color: AppColors.blackColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                              onTap: () {
                                if (model.conversionRate == null) {
                                  NetworkDio.showError(
                                    title: 'Please wait',
                                    errorMessage:
                                        'Please wait while we get your fresh balances',
                                    context: context,
                                  );
                                  return;
                                }
                                if (int.parse(bounzController.text) >
                                        model.multiple! &&
                                    (int.parse(bounzController.text) %
                                            model.multiple!) !=
                                        0) {
                                  var temp = model.multiple!;
                                  while (
                                      int.parse(bounzController.text) > temp) {
                                    temp = (temp + model.multiple!);
                                  }
                                  bounzController.text =
                                      (temp - model.multiple!).toString();
                                  updateToReceivePoints();
                                  return;
                                }

                                if ((int.parse(bounzController.text) %
                                        model.multiple!) ==
                                    0) {
                                  if (int.parse(bounzController.text) !=
                                      int.parse(model.multiple.toString())) {
                                    bounzController.text =
                                        (double.parse(bounzController.text) -
                                                model.multiple!.toInt())
                                            .toInt()
                                            .toString();
                                    updateToReceivePoints();
                                  } else {
                                    showMinAmountMsg();
                                  }
                                } else {
                                  model.isConversionDone = false;
                                  setState(() {});
                                }
                              },
                              child: SvgPicture.asset(
                                AppAssets.minus,
                              )),
                          SizedBox(
                            width: 100.0,
                            child: TextFormField(
                              onChanged: (value) {
                                if (value != "") {
                                  if (int.parse(value) >=
                                      model.minConversion!) {
                                    if (int.parse(model.userBounzPoints!) <
                                        int.parse(value)) {
                                      insufficientBal();
                                      model.isConversionDone = false;
                                      setState(() {});
                                      return;
                                    }
                                    if ((int.parse(value) % model.multiple!) ==
                                        0) {
                                      model.value =
                                          double.parse(bounzController.text);
                                      if (model.value?.toInt() == 1) {
                                        model.equivalentPoint =
                                            model.conversionRate!;
                                      } else {
                                        model.equivalentPoint =
                                            (model.conversionRate! *
                                                model.value!.toInt());
                                      }
                                      updateToReceivePoints();
                                    } else {
                                      model.isConversionDone = false;
                                      setState(() {});
                                    }
                                  } else {
                                    model.isConversionDone = false;
                                    setState(() {});
                                    return;
                                  }
                                }
                              },
                              enabled: true,
                              autofocus: false,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              cursorHeight: 28,
                              cursorColor: AppColors.whiteColor,
                              style: AppTextStyle.black26.copyWith(
                                color: AppColors.blackColor,
                              ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp("[0-9]")),
                                LengthLimitingTextInputFormatter(
                                    model.userBounzPoints?.length ?? 10),
                              ],
                              controller: bounzController,
                              decoration: InputDecoration(
                                hintText: '0',
                                hintStyle: AppTextStyle.black26.copyWith(
                                  color: AppColors.blackColor,
                                ),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (model.conversionRate == null) {
                                NetworkDio.showError(
                                  title: 'Please wait',
                                  errorMessage:
                                      'Please wait while we get your fresh balances',
                                  context: context,
                                );
                                return;
                              }
                              if (int.parse(model.userBounzPoints!) <
                                  int.parse(bounzController.text)) {
                                insufficientBal();
                                return;
                              }
                              if (int.parse(bounzController.text) >
                                      model.multiple! &&
                                  (int.parse(bounzController.text) %
                                          model.multiple!) !=
                                      0) {
                                var temp = model.multiple!;
                                while (int.parse(bounzController.text) > temp) {
                                  temp = (temp + model.multiple!);
                                }
                                bounzController.text = temp.toString();
                                updateToReceivePoints();
                                return;
                              } else if (int.parse(bounzController.text) <
                                  model.multiple!) {
                                bounzController.text =
                                    model.minConversion!.round().toString();
                                updateToReceivePoints();
                                return;
                              }

                              if ((int.parse(bounzController.text) %
                                      model.multiple!) ==
                                  0) {
                                if (int.parse(bounzController.text) <
                                    model.multiple!) {
                                  bounzController.text =
                                      model.minConversion!.round().toString();
                                } else {
                                  bounzController.text =
                                      (int.parse(bounzController.text) +
                                              model.multiple!.toInt())
                                          .toString();
                                }
                                updateToReceivePoints();
                              } else {
                                model.isConversionDone = false;
                                setState(() {});
                              }
                            },
                            child: SvgPicture.asset(
                              AppAssets.add,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 140,
                        height: 1,
                        color: AppColors.whiteColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: AppSizes.size10),
                        child: Text(
                          AppConstString.bounzBalance,
                          style: AppTextStyle.semiBold12.copyWith(
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                      Text(
                        GlobalSingleton.userInformation.pointBalance!.price
                            .toString(),
                        style: AppTextStyle.bold20.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: SvgPicture.asset(
                          AppAssets.bounzText,
                          alignment: Alignment.bottomCenter,
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 6.0),
                        child: SizedBox(
                          width: 25.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: -28,
            bottom: AppSizes.size34,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                AppAssets.handCoin,
                height: 64,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget smilesContainerWidget() {
    return Container(
      padding:
          const EdgeInsets.only(left: AppSizes.size20, top: AppSizes.size10),
      height: 155,
      decoration: BoxDecoration(
        color: AppColors.secondaryContainerColor,
        borderRadius: BorderRadius.circular(
          15,
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 4.0,
                        ),
                        child: Text(
                          AppConstString.toReceive,
                          style: AppTextStyle.semiBold14.copyWith(
                            color: AppColors.blackColor,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        child: TextFormField(
                          autofocus: false,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          enabled: false,
                          cursorHeight: 28,
                          cursorColor: AppColors.whiteColor,
                          style: AppTextStyle.black26.copyWith(
                            color: AppColors.blackColor,
                          ),
                          controller: smilesController,
                          decoration: InputDecoration(
                            hintText: '0',
                            hintStyle: AppTextStyle.black26.copyWith(
                              color: AppColors.blackColor,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        width: 140,
                        height: 1,
                        color: AppColors.blackColor,
                      ),
                      const SizedBox(
                        height: AppSizes.size10,
                      ),
                      Text(
                        AppConstString.smilesBalance,
                        style: AppTextStyle.semiBold12.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                      Text(
                        model.smilesPointsBal == null
                            ? "------"
                            : model.smilesPointsBal!.round().toString(),
                        style: AppTextStyle.bold20.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Image.asset(AppAssets.smilesText),
                      ),
                      const Padding(
                          padding: EdgeInsets.only(right: 6.0),
                          child: SizedBox(
                            width: 25.0,
                          )),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            right: -16,
            bottom: 9,
            child: Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                AppAssets.hand,
                height: 116,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget exchangeButtonWidget() {
    return Center(
      child: PrimaryButton(
        onTap: () async {
          if (model.isConversionDone!) {
            if (int.parse(bounzController.text) >
                int.parse(GlobalSingleton.userInformation.pointBalance!.price
                    .toString()
                    .replaceAll(",", ""))) {
              insufficientBal();
              return;
            }
            if (
                // model.availablePoints == true &&
                model.value! >= model.minConversion!) {
              confirmationExchange();
            } else {
              showMinAmountMsg();
            }
            final properties = MoEProperties();
            properties
                .addAttribute(
                    TriggeringCondition.excahangeType, 'Bounz to Smiles')
                .addAttribute(TriggeringCondition.smiles, smilesController.text)
                .addAttribute(TriggeringCondition.bounz, bounzController.text);
            MoenageManager.logEvent(
              MoenageEvent.initaltePointsExchange,
              properties: properties,
            );
          }
        },
        showShadow: true,
        text: 'Exchange Now',
        bColor:
            // model.isConversionDone!
            //     ?
            Colors.black,
        // : Colors.black.withOpacity(0.3),
        tColor: Colors.white,
      ),
    );
  }

  Future confirmationExchange() {
    return showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.secondaryContainerColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.size20),
              topRight: Radius.circular(AppSizes.size20)),
        ),
        builder: (ctx) {
          return SizedBox(
            height: 280.0,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstString.confirmText,
                    style: AppTextStyle.bold16.copyWith(
                      color: AppColors.btnBlueColor,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppConstString.transferring,
                        style: AppTextStyle.semiBold14.copyWith(
                          color: AppColors.btnBlueColor.withOpacity(
                            0.50,
                          ),
                        ),
                      ),
                      Text(
                        AppConstString.youWillReceive,
                        style: AppTextStyle.semiBold14.copyWith(
                          color: AppColors.btnBlueColor.withOpacity(
                            0.50,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.size14,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bounzController.text,
                        style: AppTextStyle.bold24.copyWith(
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        smilesController.text,
                        style: AppTextStyle.bold24.copyWith(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        AppAssets.bounzText,
                      ),
                      Image.asset(AppAssets.smilesText),
                    ],
                  ),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: RoundedBorderButton(
                        onTap: () {
                          final properties = MoEProperties();
                          properties.addAttribute(
                              TriggeringCondition.confirmation, 'No');
                          MoenageManager.logEvent(
                            MoenageEvent.confirmExchange,
                            properties: properties,
                          );
                          Navigator.pop(context);
                        },
                        text: 'Change',
                        bColor: AppColors.btnBlueColor,
                        tColor: AppColors.btnBlueColor,
                      )),
                      const SizedBox(
                        width: AppSizes.size10,
                      ),
                      Expanded(
                          child: PrimaryButton(
                        showShadow: true,
                        onTap: () async {
                          Navigator.pop(ctx);
                          final properties = MoEProperties();
                          properties.addAttribute(
                              TriggeringCondition.confirmation, 'Yes');
                          MoenageManager.logEvent(
                            MoenageEvent.confirmExchange,
                            properties: properties,
                          );
                          bool isSuccess =
                              await presenter.postTransactionToBlockChain(
                                  context,
                                  bounzController.text,
                                  model.roundOffMethod == "Floor"
                                      ? model.equivalentPoint!.floor()
                                      : model.equivalentPoint!.ceil());

                          if (isSuccess) {
                            var smilesBal = model.smilesPointsBal!.round() +
                                (model.roundOffMethod == "Floor"
                                    ? model.equivalentPoint!.floor()
                                    : model.equivalentPoint!.ceil());

                            var bounzBal = int.parse(GlobalSingleton
                                    .userInformation.pointBalance!.price
                                    .replaceAll(",", "")) -
                                (model.roundOffMethod == "Floor"
                                    ? int.parse(bounzController.text).floor()
                                    : int.parse(bounzController.text).ceil());

                            GlobalSingleton.bounzNewTempBal =
                                bounzBal.toString();
                            GlobalSingleton.smilesTempBal =
                                smilesBal.toString();
                            presenter.getProfileData(context);
                            AutoRouter.of(context)
                                .push(const RewardReceivedScreenRoute());
                          }
                        },
                        text: 'Confirm',
                      ))
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  void showMinAmountMsg({String? message}) {
    NetworkDio.showError(
      title: 'Min Points',
      errorMessage: message ??
          'Minimum ${model.minConversion!.round()} point required for conversion',
      context: context,
    );
  }

  void calculatePoints() {
    if (firstAdd != 0) {
      bounzController.text = model.minConversion!.round().toString();
    }

    if (int.parse(model.userBounzPoints!) < model.minConversion!.round()) {
      insufficientBal();
      return;
    }

    model.isConversionDone = true;
    model.value = double.parse(bounzController.text);
    if (model.value?.toInt() == 1) {
      model.equivalentPoint = model.conversionRate!;
    } else {
      model.equivalentPoint = (model.conversionRate! * model.value!.toInt());
    }

    if (firstAdd != 0) {
      smilesController.text = model.equivalentPoint != 0.0
          ? model.equivalentPoint == 1 ||
                  model.equivalentPoint == 0 ||
                  model.equivalentPoint == model.conversionRate
              ? model.roundOffMethod == null
                  ? model.conversionRate.toString()
                  : model.roundOffMethod == "Floor"
                      ? pointsFormatter(model.conversionRate?.floor())
                      : pointsFormatter(model.conversionRate?.ceil())
              : model.roundOffMethod == "Floor"
                  ? pointsFormatter(model.equivalentPoint?.floor())
                  : pointsFormatter(model.equivalentPoint?.ceil())
          : model.roundOffMethod == null
              ? model.conversionRate.toString()
              : model.roundOffMethod == "Floor"
                  ? pointsFormatter(model.conversionRate?.floor())
                  : pointsFormatter(model.conversionRate?.ceil());
    }
    firstAdd++;
    setState(() {});
  }

  Future insufficientBal() {
    return showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.secondaryContainerColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.size20),
              topRight: Radius.circular(AppSizes.size20)),
        ),
        builder: (context) {
          return SizedBox(
            height: 160.0,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppConstString.sufficientBal,
                    style: AppTextStyle.bold18.copyWith(
                      color: AppColors.btnBlueColor,
                    ),
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  RoundedBorderButton(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    height: 60,
                    text: 'Go Back',
                    bColor: AppColors.btnBlueColor,
                    tColor: AppColors.btnBlueColor,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void updateToReceivePoints() {
    model.isConversionDone = true;
    model.value = double.parse(bounzController.text);
    if (model.value?.toInt() == 1) {
      model.equivalentPoint = model.conversionRate!;
    } else {
      model.equivalentPoint = (model.conversionRate! * model.value!.toInt());
    }
    setState(() {
      smilesController.text = model.equivalentPoint != 0.0
          ? model.equivalentPoint == 1 ||
                  model.equivalentPoint == 0 ||
                  model.equivalentPoint == model.conversionRate
              ? model.roundOffMethod == null
                  ? model.conversionRate.toString()
                  : model.roundOffMethod == "Floor"
                      ? pointsFormatter(model.conversionRate?.floor())
                      : pointsFormatter(model.conversionRate?.ceil())
              : model.roundOffMethod == "Floor"
                  ? pointsFormatter(model.equivalentPoint?.floor())
                  : pointsFormatter(model.equivalentPoint?.ceil())
          : model.roundOffMethod == null
              ? model.conversionRate.toString()
              : model.roundOffMethod == "Floor"
                  ? pointsFormatter(model.conversionRate?.floor())
                  : pointsFormatter(model.conversionRate?.ceil());
    });
  }
}
