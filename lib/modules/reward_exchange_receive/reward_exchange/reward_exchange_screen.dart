import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/reward_exchange/reward_exchange_model.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/reward_exchange/reward_exchange_presenter.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/reward_exchange/reward_exchange_view.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/reward_exchange_drop_down.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/utils/progress_hud.dart';
import 'package:bounz_revamp_app/utils/validator.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/widgets/pin_code_fields_smiles.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:moengage_flutter/properties.dart';
import '../reward_exchange_history/history_exchange_screen.dart';

@RoutePage()
class RewardExchangeScreen extends StatefulWidget {
  final bool fromSplash;

  const RewardExchangeScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  _RewardExchangeScreenState createState() => _RewardExchangeScreenState();
}

class _RewardExchangeScreenState extends State<RewardExchangeScreen>
    implements RewardExchangeView {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  var memberIdController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController bounzController = TextEditingController();
  TextEditingController smilesController = TextEditingController();
  TextEditingController otpExpSessionController = TextEditingController();

  bool reloadCoinsDrop = false;
  bool isIdErr = false;
  bool isLinked = false;
  bool isAmountEntered = false;
  bool isConversionDone = false;
  bool convertClicked = false;
  bool showRefreshIcon = false;
  bool showAnimation = false;
  int minMsgCount = 0;
  var loader = OptionPage();
  final focusNode = FocusNode();
  final List<String> list = [AppAssets.bounzText, AppAssets.smilesText];

  late RewardExchangeViewModel model;
  RewardExchangePresenter presenter = BasicRewardExchangePresenter();

  @override
  void initState() {
    super.initState();
    presenter.updateView = this;
    model.dropdownValue = list[0];
    reloadCoinsDrop = false;

    model.userBounzPoints =
        GlobalSingleton.userInformation.pointBalance!.toString();
    model.range = double.parse(model.userBounzPoints ?? "");

    presenter.getAllMemberData(context);
  }

  @override
  void dispose() {
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (widget.fromSplash) {
                    MoenageManager.logScreenEvent(name: 'Main Home');
                    AutoRouter.of(context).pushAndPopUntil(
                        MainHomeScreenRoute(isFirstLoad: true),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppConstString.rewardExchange,
                    style: AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
                  ),
                  GestureDetector(
                    onTap: () {
                      final properties = MoEProperties();
                      properties.setNonInteractiveEvent();
                      properties.addAttribute(
                          TriggeringCondition.screenName, 'Reward Exchange');
                      MoenageManager.logEvent(
                        MoenageEvent.exchangeHistory,
                        properties: properties,
                      );

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ExchangeHistoryScreen()),
                      );
                    },
                    child: SvgPicture.asset(
                      AppAssets.exchange,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.size30,
              ),
              bounzContainerWidget(),
              convertClicked == false
                  ? const SizedBox(
                      height: AppSizes.size10,
                    )
                  : Container(),
              convertClicked == false
                  ? convertButtonRowWidget()
                  : showRefreshIcon == false && convertClicked == true
                      ? loaderIndicatorWidget()
                      : refreshIndicatorWidget(),
              SizedBox(
                height: convertClicked == false ? AppSizes.size10 : 0.0,
              ),
              smilesContainerWidget(),
              const SizedBox(
                height: AppSizes.size20,
              ),
              isLinked ? const SizedBox() : linkAccountButton(),
              SizedBox(
                height: isLinked ? AppSizes.size2 : AppSizes.size20,
              ),
              exchangeButtonWidget(),
              const SizedBox(
                height: AppSizes.size16,
              ),
              isLinked ? deLinkAccountWidget() : const SizedBox(),
            ],
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
                      SizedBox(
                        width: 80.0,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              if (value.isNotEmpty) {
                                isAmountEntered = true;
                              } else {
                                isAmountEntered = false;
                              }
                            });
                          },
                          enabled: isLinked ? true : false,
                          autofocus: false,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          cursorHeight: 28,
                          cursorColor: AppColors.whiteColor,
                          style: AppTextStyle.black26.copyWith(
                            color: AppColors.blackColor,
                          ),
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
                      Container(
                        width: 80,
                        height: 1,
                        color: AppColors.whiteColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: AppSizes.size10),
                        child: Text(
                          model.dropdownValue == AppAssets.bounzText
                              ? AppConstString.bounzBalance
                              : AppConstString.smilesBalance,
                          style: AppTextStyle.semiBold12.copyWith(
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                      Text(
                        model.dropdownValue == AppAssets.bounzText
                            ? GlobalSingleton
                                .userInformation.pointBalance!.price
                                .toString()
                            : model.smilesPointsBal == null
                                ? "------"
                                : model.smilesPointsBal.toString(),
                        style: AppTextStyle.bold20.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                  RewardDropdownButtonHideUnderline(
                    child: RewardDropdownButton<String>(
                      value: model.dropdownValue,
                      dropdownColor: AppColors.rewardExchange1,
                      icon: const Padding(
                        padding: EdgeInsets.only(right: 6.0, bottom: 13.5),
                        child: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: AppColors.whiteColor,
                          size: 25.0,
                        ),
                      ),
                      elevation: 16,
                      onTap: () {},
                      onChanged: (String? value) {
                        setState(
                          () {
                            model.dropdownValue = value!;
                          },
                        );
                      },
                      items: list.map<RewardDropdownMenuItem<String>>(
                        (String value) {
                          return RewardDropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom: value == AppAssets.bounzText ? 14 : 17,
                              ),
                              child: value == AppAssets.bounzText
                                  ? SvgPicture.asset(
                                      value,
                                      alignment: Alignment.centerRight,
                                    )
                                  : Image.asset(
                                      value,
                                      alignment: Alignment.centerRight,
                                    ),
                            ),
                          );
                        },
                      ).toList(),
                    ),
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
                        width: 80.0,
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
                        width: 80.0,
                        height: 1,
                        color: AppColors.whiteColor,
                      ),
                      const SizedBox(
                        height: AppSizes.size10,
                      ),
                      Text(
                        model.dropdownValue == AppAssets.bounzText
                            ? AppConstString.smilesBalance
                            : AppConstString.bounzBalance,
                        style: AppTextStyle.semiBold12.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                      Text(
                        model.dropdownValue == AppAssets.bounzText
                            ? model.smilesPointsBal == null
                                ? "------"
                                : model.smilesPointsBal.toString()
                            : GlobalSingleton
                                .userInformation.pointBalance!.price
                                .toString(),
                        style: AppTextStyle.bold20.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      model.dropdownValue == AppAssets.bounzText
                          ? Padding(
                              padding: const EdgeInsets.only(bottom: 4.0),
                              child: Image.asset(AppAssets.smilesText),
                            )
                          : SvgPicture.asset(
                              AppAssets.bounzText,
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
          Visibility(
            visible: showAnimation && reloadCoinsDrop,
            child: Positioned(
              right: -5,
              top: 5,
              child: SizedBox(
                width: 100,
                height: 100,
                child: Lottie.asset(
                  AppAssets.coinsDrop,
                  repeat: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget convertButtonRowWidget() {
    return Row(
      children: [
        const SizedBox(
          width: AppSizes.size10,
        ),
        Text(
          AppConstString.smileCount,
          style: AppTextStyle.bold14,
        ),
        const Spacer(),
        Center(
          child: PrimaryButton(
            onTap: isLinked && isAmountEntered
                ? () {
                    if (model.availablePoints == true) {
                      model.value = double.parse(bounzController.text);

                      if (model.value?.toInt() == 1) {
                        model.equivalentPoint = model.conversionRate!;
                      } else {
                        model.equivalentPoint =
                            (model.conversionRate! * model.value!.toInt());
                      }

                      setState(() {
                        smilesController.text = model.equivalentPoint != 0.0
                            ? model.equivalentPoint == 1 ||
                                    model.equivalentPoint == 0 ||
                                    model.equivalentPoint ==
                                        model.conversionRate
                                ? model.roundOffMethod == null
                                    ? model.conversionRate.toString()
                                    : model.roundOffMethod == "Floor"
                                        ? pointsFormatter(
                                            model.conversionRate?.floor())
                                        : pointsFormatter(
                                            model.conversionRate?.ceil())
                                : model.roundOffMethod == "Floor"
                                    ? pointsFormatter(
                                        model.equivalentPoint?.floor())
                                    : pointsFormatter(
                                        model.equivalentPoint?.ceil())
                            : model.roundOffMethod == null
                                ? model.conversionRate.toString()
                                : model.roundOffMethod == "Floor"
                                    ? pointsFormatter(
                                        model.conversionRate?.floor())
                                    : pointsFormatter(
                                        model.conversionRate?.ceil());

                        convertClicked = !convertClicked;
                        isConversionDone = true;
                        showAnimation = true;
                        reloadCoinsDrop = true;
                      });
                    } else {
                      showMinAmountMsg();
                    }
                  }
                : () {},
            text: 'Convert',
            height: AppSizes.size36,
            bColor: isLinked ? Colors.black : Colors.black.withOpacity(0.3),
            tColor: isLinked ? Colors.white : Colors.white.withOpacity(0.7),
            width: 100.0,
          ),
        ),
      ],
    );
  }

  Widget linkAccountButton() {
    return Center(
      child: RoundedBorderButton(
        onTap: () {
          linkAccountBottomSheet();
        },
        text: 'Link Account',
        bColor: AppColors.btnBlueColor,
        tColor: AppColors.btnBlueColor,
      ),
    );
  }

  //link account
  Future linkAccountBottomSheet() {
    return showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.secondaryContainerColor,
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.size20),
              topRight: Radius.circular(AppSizes.size20)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: AppSizes.size20,
                right: AppSizes.size20,
                left: AppSizes.size20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: 230.0,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstString.enterIdText,
                        style: AppTextStyle.semiBold14.copyWith(
                          color: AppColors.btnBlueColor,
                        ),
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        AppConstString.hintText,
                        style: AppTextStyle.semiBold14.copyWith(
                          color: AppColors.btnBlueColor,
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: AppSizes.size20),
                        child: NumberWidget(
                            focusNode: focusNode,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                            hintText: AppConstString.mobileNo,
                            autofocus: true,
                            hintStyle: AppTextStyle.regular16,
                            prefixIconConstraints:
                                BoxConstraints.loose(const Size(125, 50)),
                            controller: phoneController,
                            maxLength: 12,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              return Validators.validateSmilesMobile(
                                value,
                              );
                            }),
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      Center(
                        child: PrimaryButton(
                          onTap: () async {
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);
                              bool opnOtp = await presenter.linkSmileAccount(
                                  context, phoneController.text);
                              if (opnOtp) {
                                linkAcOtpBottomsheet();
                              }
                            } else {
                              return;
                            }
                          },
                          text: 'Proceed',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void linkAcOtpBottomsheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.secondaryContainerColor,
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.size20),
              topRight: Radius.circular(AppSizes.size20)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: AppSizes.size20,
                right: AppSizes.size20,
                left: AppSizes.size20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: 230.0,
                child: Form(
                  key: _formKey1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstString.enterOtpText,
                        style: AppTextStyle.semiBold14.copyWith(
                          color: AppColors.btnBlueColor,
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              PinCodeTextFieldSmiles(
                                appContext: context,
                                length: 5,
                                controller: otpController,
                                onChanged: (String value) {
                                  setState(() {});
                                },
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Text(
                                (otpController.text.isEmpty)
                                    ? 'Please Enter OTP'
                                    : (otpController.text.length != 5)
                                        ? '5 Digit OTP required'
                                        : "",
                                style: const TextStyle(
                                    color: AppColors.errorColor),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      Center(
                        child: PrimaryButton(
                          onTap: () {
                            if (_formKey1.currentState!.validate()) {
                              Navigator.pop(context);
                              presenter.otpVerifyHash(
                                  context,
                                  phoneController.text,
                                  otpController.text,
                                  invalidOtpBottomSheet,
                                  timedOutBottomSheet);
                            } else {
                              return;
                            }
                          },
                          text: 'Proceed',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void invalidOtpBottomSheet() {
    otpController.clear();
    loader.hideOption();
    showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.secondaryContainerColor,
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.size20),
              topRight: Radius.circular(AppSizes.size20)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: AppSizes.size20,
                right: AppSizes.size20,
                left: AppSizes.size20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: 100.0,
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Invalid OTP",
                        style: AppTextStyle.semiBold14.copyWith(
                          color: AppColors.btnBlueColor,
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      Center(
                        child: PrimaryButton(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          text: 'Ok',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  Future timedOutBottomSheet() {
    loader.hideOption();
    return showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.secondaryContainerColor,
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.size20),
              topRight: Radius.circular(AppSizes.size20)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: AppSizes.size20,
                right: AppSizes.size20,
                left: AppSizes.size20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: 100.0,
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Oops! server not respond in time",
                        style: AppTextStyle.semiBold14.copyWith(
                          color: AppColors.btnBlueColor,
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      Center(
                        child: PrimaryButton(
                          onTap: () {
                            Navigator.of(context).pop();
                            presenter.getAllMemberData(context);
                          },
                          text: 'Retry',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  // confirmationExchange bottom sheet
  Future confirmationExchange() {
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
                      model.dropdownValue == AppAssets.bounzText
                          ? SvgPicture.asset(
                              AppAssets.bounzText,
                            )
                          : Image.asset(AppAssets.smilesText),
                      model.dropdownValue == AppAssets.bounzText
                          ? Image.asset(AppAssets.smilesText)
                          : SvgPicture.asset(
                              AppAssets.bounzText,
                            ),
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
                          if ((model.value!.toInt()) < (model.minConversion!) ||
                              model.availablePoints! == false) {
                            setState(() {
                              NetworkDio.showError(
                                title: "Conversion",
                                errorMessage:
                                    'Minimum conversion of ${model.minConversion!} is required',
                                context: context,
                              );
                            });
                          } else {
                            bool isSuccess =
                                await presenter.postTransactionToBlockChain(
                                    context,
                                    bounzController.text,
                                    model.roundOffMethod == "Floor"
                                        ? model.equivalentPoint!.floor()
                                        : model.equivalentPoint!.ceil(),
                                    sessionExpireAlert);
                            final properties = MoEProperties();
                            properties.addAttribute(
                                TriggeringCondition.screenName,
                                'Reward Received');
                            properties.addAttribute(
                                TriggeringCondition.excahangeType,
                                'Bounz To Smiles');
                            properties.addAttribute(TriggeringCondition.smiles,
                                smilesController.text);
                            properties.addAttribute(TriggeringCondition.bounz,
                                bounzController.text);
                            properties.addAttribute(
                                TriggeringCondition.smilesNewBalance,
                                GlobalSingleton.smilesTempBal ?? "");
                            properties.addAttribute(
                                TriggeringCondition.bounzNewBalance,
                                GlobalSingleton.bounzNewTempBal ?? "");
                            MoenageManager.logEvent(
                              MoenageEvent.screenView,
                              properties: properties,
                            );
                            if (isSuccess) {
                              Navigator.pop(context);
                              NetworkDio.showError(
                                title: "Conversion",
                                errorMessage:
                                    'Conversion has been completed successfully',
                                context: context,
                              );
                            }
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

  //animation widgets
  Widget loaderIndicatorWidget() {
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          showRefreshIcon = !showRefreshIcon;
        });
      }
    });
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(right: 10.0),
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.btnBlueColor,
          ),
          child: const Icon(
            Icons.more_horiz_outlined,
            color: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }

  Widget refreshIndicatorWidget() {
    return GestureDetector(
      onTap: () {
        setState(() {
          convertClicked = !convertClicked;
          showRefreshIcon = !showRefreshIcon;
          reloadCoinsDrop = false;
        });
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.btnBlueColor,
            ),
            child: const Icon(
              Icons.refresh,
              color: AppColors.whiteColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget exchangeButtonWidget() {
    return Center(
      child: PrimaryButton(
        onTap: isLinked && isConversionDone
            ? () {
                final properties = MoEProperties();
                properties
                    .addAttribute(TriggeringCondition.transferringProgram, '')
                    .addAttribute(TriggeringCondition.receivingProgram, '')
                    .addAttribute(
                        TriggeringCondition.newTransferringprogramBalance, '')
                    .addAttribute(
                        TriggeringCondition.newReceivingprogramBalance, '')
                    .setNonInteractiveEvent();
                MoenageManager.logEvent(
                  MoenageEvent.rewardsExchange,
                  properties: properties,
                );
                confirmationExchange();
              }
            : null,
        showShadow: true,
        text: 'Exchange Now ',
        bColor: isConversionDone ? Colors.black : Colors.black.withOpacity(0.3),
        tColor: isConversionDone ? Colors.white : Colors.white,
        //isConversionDone
      ),
    );
  }

  //Unlink account
  Widget deLinkAccountWidget() {
    return Center(
      child: GestureDetector(
        onTap: () {
          unlinkConformation();
        },
        child: Text(
          AppConstString.deLinkAccountText,
          style: AppTextStyle.semiBold16,
        ),
      ),
    );
  }

  void unlinkConformation() {
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
                margin: const EdgeInsets.only(top: 10, left: 15, right: 15),
                height: 140,
                child: Column(
                  children: [
                    Text(
                      AppConstString.conformDeLinkAccountText,
                      style: AppTextStyle.semiBold20,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        PrimaryButton(
                          onTap: () async {
                            bool unlinkStatus =
                                await presenter.unLinkSmileAccount(
                                    context, false, model.smilesMemberID!);
                            unlinkMsgBottomSheet(unlinkStatus);
                          },
                          text: "Proceed",
                          height: AppSizes.size36,
                          width: 100.0,
                        ),
                        const SizedBox(width: 50),
                        PrimaryButton(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          text: "Cancel",
                          height: AppSizes.size36,
                          width: 100.0,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
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

  //Session Expired
  void sessionExpireAlert() {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.secondaryContainerColor,
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.size20),
              topRight: Radius.circular(AppSizes.size20)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: AppSizes.size20,
                right: AppSizes.size20,
                left: AppSizes.size20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: 120.0,
                child: Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your session has been Expired",
                        style: AppTextStyle.semiBold14.copyWith(
                          color: AppColors.btnBlueColor,
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          PrimaryButton(
                            onTap: () {
                              Navigator.pop(context);
                              otpSessionExpireSheet();
                            },
                            text: 'Enter Pin',
                            width: AppSizes.size160,
                          ),
                          PrimaryButton(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            text: 'Cancel',
                            width: AppSizes.size160,
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void otpSessionExpireSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.secondaryContainerColor,
        isScrollControlled: true,
        isDismissible: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.size20),
              topRight: Radius.circular(AppSizes.size20)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: AppSizes.size20,
                right: AppSizes.size20,
                left: AppSizes.size20,
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SizedBox(
                height: 230.0,
                child: Form(
                  key: _formKey2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppConstString.enterOtpText,
                        style: AppTextStyle.semiBold14.copyWith(
                          color: AppColors.btnBlueColor,
                        ),
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      PinCodeTextFieldSmiles(
                        appContext: context,
                        length: 5,
                        controller: otpExpSessionController,
                        onChanged: (String value) {
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 5.0),
                      Text(
                        (otpExpSessionController.text.isEmpty)
                            ? 'Please Enter OTP'
                            : (otpExpSessionController.text.length != 5)
                                ? '5 Digit OTP required'
                                : "",
                        style: const TextStyle(color: AppColors.errorColor),
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      Center(
                        child: PrimaryButton(
                          onTap: () {
                            if (_formKey2.currentState!.validate()) {
                              Navigator.pop(context);
                              presenter.verifyPostTranOTP(
                                  context,
                                  otpExpSessionController.text,
                                  smilesController.text,
                                  model.roundOffMethod == "Floor"
                                      ? model.equivalentPoint!.floor()
                                      : model.equivalentPoint!.ceil());

                              // pending transaction page will be there
                            } else {
                              return;
                            }
                          },
                          text: 'Proceed',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void showMinAmountMsg() {
    NetworkDio.showError(
      title: 'Min Points',
      errorMessage: (model.dropdownValue == AppAssets.bounzText)
          ? 'Minimum 500 Bounz point required for conversion'
          : 'Minimum 7500 Smiles point required for conversion',
      context: context,
    );
  }

  @override
  void refreshModel(RewardExchangeViewModel rewardExchangeViewModel) {
    setState(() {
      model = rewardExchangeViewModel;
      if (rewardExchangeViewModel.allMemberModel?.linkedPartners!.length !=
          null) {
        isLinked =
            rewardExchangeViewModel.allMemberModel!.linkedPartners!.isEmpty
                ? false
                : true;
      }
    });
  }
}
