import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/utils/validator.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/widgets/pin_code_fields_smiles.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/link_acc_reward_exchange/link_acc_reward_exchange_view.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/link_acc_reward_exchange/link_acc_reward_exchange_model.dart';
import 'package:bounz_revamp_app/modules/reward_exchange_receive/link_acc_reward_exchange/link_acc_reward_exchange_presenter.dart';

@RoutePage()
class LinkAccRewardExchangeScreen extends StatefulWidget {
  const LinkAccRewardExchangeScreen({super.key});

  @override
  State<LinkAccRewardExchangeScreen> createState() =>
      _LinkAccRewardExchangeScreenState();
}

class _LinkAccRewardExchangeScreenState
    extends State<LinkAccRewardExchangeScreen>
    implements LinkAccRewardExchangeView {
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final focusNode = FocusNode();

  late LinkAccRewardExchangeViewModel model;
  BasicLinkAccRewardExchangePresenter presenter =
      BasicLinkAccRewardExchangePresenter();

  @override
  void refreshModel(
      LinkAccRewardExchangeViewModel linkAccRewardExchangeViewModel) {
    model = linkAccRewardExchangeViewModel;
  }

  @override
  void initState() {
    super.initState();
    presenter.updateView = this;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
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
                      AppConstString.verification,
                      style:
                          AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
                    ),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                Text(
                  'Link your Smiles account',
                  style: AppTextStyle.semiBold18
                      .copyWith(fontFamily: 'SourceSansPro'),
                ),
                const SizedBox(
                  height: AppSizes.size16,
                ),
                Text(
                  'Use the mobile Number you have registered with Smiles.',
                  style: AppTextStyle.regular16,
                ),
                const SizedBox(
                  height: AppSizes.size20,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: AppSizes.size20),
                  child: NumberWidget(
                      focusNode: focusNode,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      hintText: AppConstString.mobileNoSmiles,
                      autofocus: true,
                      hintStyle: AppTextStyle.regular16,
                      prefixIconConstraints:
                          BoxConstraints.loose(const Size(125, 50)),
                      prefixIcon: GestureDetector(
                        onTap: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: AppSizes.size16,
                              child: CircleAvatar(
                                radius: 15.0,
                                backgroundImage: NetworkImage(
                                  model.country?.image ?? AppAssets.uaeFlag,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: AppSizes.size4,
                            ),
                            Text(
                              "+${model.country?.countryCode ?? "971"}",
                              style: AppTextStyle.semiBold16,
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.whiteColor,
                            ),
                            const SizedBox(
                              width: AppSizes.size6,
                            ),
                            Container(
                              height: AppSizes.size20,
                              width: 1,
                              color: AppColors.whiteColor,
                            ),
                          ],
                        ),
                      ),
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
                  height: AppSizes.size50,
                ),
                Center(
                  child: PrimaryButton(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        if (!phoneController.text.startsWith("0", 0)) {
                          phoneController.text = "0" + phoneController.text;
                        }
                        bool opnOtp = await presenter.linkSmileAccount(
                            context, phoneController.text);
                        if (opnOtp) {
                          linkAcOtpBottomsheet();
                        }
                      } else {
                        return;
                      }
                    },
                    showShadow: true,
                    text: 'Proceed',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
          bool isError = false;
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
                              if (isError) ...[
                                Text(
                                  (otpController.text.isEmpty)
                                      ? 'Please Enter OTP'
                                      : (otpController.text.length != 5)
                                          ? '5 Digit OTP required'
                                          : "",
                                  style: const TextStyle(
                                      color: AppColors.errorColor),
                                )
                              ]
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
                            if (_formKey1.currentState!.validate() &&
                                otpController.text.isNotEmpty &&
                                otpController.text.length == 5) {
                              isError = false;
                              Navigator.pop(context);
                              presenter.otpVerifyHash(
                                  context,
                                  phoneController.text,
                                  otpController.text,
                                  invalidOtpBottomSheet,
                                  timedOutBottomSheet,
                                  redirectToSelection);
                            } else {
                              setState(() {
                                isError = true;
                              });
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

  Future<void> redirectToSelection() async {
    bool isSuccess = await presenter.getAllMemberData(context);
    if (isSuccess) {
      AutoRouter.of(context).replace(const RewardsExSelectionScreenRoute());
    }
  }
}
