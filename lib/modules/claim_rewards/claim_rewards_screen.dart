import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:moengage_flutter/properties.dart';

@RoutePage()
class ClaimRewardsScreen extends StatefulWidget {
  final bool fromSplash;
  const ClaimRewardsScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  State<ClaimRewardsScreen> createState() => _ClaimRewardsScreenState();
}

class _ClaimRewardsScreenState extends State<ClaimRewardsScreen> {
  final focusNode = FocusNode();
  Map<String, dynamic>? response;
  bool isProcessing = false;
  late bool showFloatingBox;
  final TextEditingController textController = TextEditingController();
  final TextEditingController couperCodeController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  late bool isSubmitButtonEnabled;
  bool isTextFieldEmpty = true;
  bool txtChange = false;

  @override
  void initState() {
    super.initState();
    showFloatingBox = false;
    isSubmitButtonEnabled = false;
    focusNode.addListener(() {
      setState(() {
        isSubmitButtonEnabled = couperCodeController.text.isNotEmpty;
      });
    });
  }

  Future claimRewards({
    required BuildContext context,
  }) async {
    setState(() {
      isProcessing = true;
    });
    final response = await NetworkDio.postDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.claimRewards,
      context: context,
      data: {
        "coupon_code": couperCodeController.text,
        "membership_no": GlobalSingleton.userInformation.membershipNo,
      },
    );

    if (response != null) {
      getProfileData(context, response["values"][0]["points"]);
    } else {
      setState(() {
        txtChange = false;
        isProcessing = false;
      });
    }
  }

  Future getProfileData(BuildContext context, points) async {
    Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      url: ApiPath.apiEndPoint + ApiPath.getProfile,
      context: context,
      queryParameters: {
        'membership_no': GlobalSingleton.userInformation.membershipNo,
      },
    );
    if (response != null) {
      GlobalSingleton.userInformation = UserInformation.fromJson(
        response['data']['values'][0],
      );
      StorageManager.setStringValue(
        key: AppStorageKey.userInformation,
        value: userInformationToJson(GlobalSingleton.userInformation),
      );

      MoenageManager.logScreenEvent(name: 'Reward Claimed');
      AutoRouter.of(context).push(
        RewardClaimedScreenRoute(earnPoints: points, pageIndex: 4),
      );
    }
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
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: AppColors.backgroundColor,
          body: AppBackGroundWidget(
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
                Expanded(
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            AppConstString.claimRewardsFour,
                            style: AppTextStyle.regular36.copyWith(
                              fontFamily: 'Bebas',
                            ),
                          ),
                          const SizedBox(
                            height: AppSizes.size30,
                          ),
                          lottieWidget(),
                          const SizedBox(
                            height: AppSizes.size20,
                          ),
                          Center(
                            child: Text(AppConstString.enterCouponCode,
                                style: AppTextStyle.semiBold16),
                          ),
                          const SizedBox(
                            height: AppSizes.size16,
                          ),
                          txtWidget(),
                          const SizedBox(
                            height: AppSizes.size30,
                          ),
                          const SizedBox(
                            height: AppSizes.size30,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: submitButtonWidget(),
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  txtWidget() {
    return TextFormFieldWidget(
        labelText: 'Enter here',
        controller: couperCodeController,
        maxLength: 20,
        autofocus: true,
        focusNode: focusNode,
        onChanged: (value) {
          setState(() {
            isSubmitButtonEnabled = value!.isNotEmpty;
            txtChange = value.isNotEmpty ? txtChange : false;
          });
        },
        onFieldSubmitted: (value) {
          setState(() {
            isTextFieldEmpty = value!.isEmpty;
            isSubmitButtonEnabled = value.isNotEmpty;
          });
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Coupon code is required.';
          }

          if (value.contains(' ')) {
            return "Coupon code must not contain spaces.";
          }
          final alphanumericPattern = RegExp(r'^[a-zA-Z0-9]+$');

          if (!alphanumericPattern.hasMatch(value)) {
            return "Coupon code must not contain special characters.";
          }

          return null;
        });
  }

  lottieWidget() {
    if (showFloatingBox &&
        !isTextFieldEmpty &&
        response?.containsKey('status') == true &&
        response!['status'] == true) {
      return Lottie.asset(
        AppAssets.floatingBox,
        repeat: true,
        fit: BoxFit.cover,
      );
    } else {
      return Lottie.asset(
        AppAssets.giftBox,
        repeat: true,
        fit: BoxFit.cover,
      );
    }
  }

  submitButtonWidget() {
    return PrimaryButton(
      text: isProcessing ? AppConstString.processing : AppConstString.submit,
      onTap: isSubmitButtonEnabled
          ? () async {
              final properties = MoEProperties();
              properties
                  .addAttribute(TriggeringCondition.screenName, "ClaimRewards")
                  .addAttribute(
                      TriggeringCondition.couponCode, couperCodeController.text)
                  .setNonInteractiveEvent();
              MoenageManager.logEvent(
                MoenageEvent.rewardsClaimed,
                properties: properties,
              );
              setState(() {
                if (!isTextFieldEmpty) {
                  txtChange = !txtChange;
                }
              });
              if (formKey.currentState!.validate()) {
                await claimRewards(context: context);
              }
            }
          : null,
    );
  }
}
