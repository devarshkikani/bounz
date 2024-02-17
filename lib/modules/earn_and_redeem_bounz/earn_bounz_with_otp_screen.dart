import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/dashboard/get_otp_model.dart';
import 'package:bounz_revamp_app/modules/dashboard/dashboard_screen.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:moengage_flutter/properties.dart';

@RoutePage()
class EarnBounzWithOtpScreen extends StatefulWidget {
  final String title;
  final String termsConditions;
  const EarnBounzWithOtpScreen(
      {Key? key, required this.title, required this.termsConditions})
      : super(key: key);

  @override
  State<EarnBounzWithOtpScreen> createState() => _EarnBounzWithOtpScreenState();
}

class _EarnBounzWithOtpScreenState extends State<EarnBounzWithOtpScreen>
    with TickerProviderStateMixin {
  GetOtpModel _getOtpModel = GetOtpModel();
  String otpValue = "";
  late AnimationController _controller;
  bool _otpBtnHide = false;

  Future<String> generateOtp(BuildContext context) async {
    Map<String, dynamic>? response = await NetworkDio.postDioHttpMethodSSO(
        context: context,
        url: ApiPath.apiEndPoint + ApiPath.generateOtp,
        data: {
          'mobile_number': GlobalSingleton.userInformation.mobileNumber,
          'country_code': GlobalSingleton.userInformation.countryCode,
          'email': GlobalSingleton.userInformation.email,
          'channel': "POS", //static
          'type': 'lock', //static
        });
    if (response != null) {
      _getOtpModel = GetOtpModel.fromJson(response);
      final properties = MoEProperties();
      properties
          .addAttribute(TriggeringCondition.status, 'Verified')
          .addAttribute(
              TriggeringCondition.otpGeneratedFor, 'Points Redemption')
          .setNonInteractiveEvent();
      MoenageManager.logEvent(
        MoenageEvent.mobileNumberOtpVerification,
        properties: properties,
      );

      _otpBtnHide = !_otpBtnHide;
      _controller = AnimationController(
          vsync: this, duration: const Duration(seconds: 300));
      _controller.forward();
      return _getOtpModel.data?.values?.otp ?? "";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: Container(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height - kToolbarHeight - 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
                    widget.title,
                    style: AppTextStyle.regular36.copyWith(
                      fontFamily: "Bebas",
                    ),
                  ),
                  Html(
                    data: widget.termsConditions,
                  ),
                  const SizedBox(
                    height: AppSizes.size10,
                  ),
                ],
              ),
              Center(
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Lottie.asset(
                      widget.title.contains('REDEEM')
                          ? AppAssets.bounzEarnOtp
                          : AppAssets.showBarcodeImg,
                      height: MediaQuery.of(context).size.height * 0.40,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSizes.size30),
                      child: PrimaryButton(
                        height: MediaQuery.of(context).size.height * 0.065,
                        text: AppConstString.ctn,
                        onTap: () async {
                          if (widget.title.contains('REDEEM')) {
                            redemption();
                          } else {
                            accural();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> redemption() async {
    otpValue = await generateOtp(context);
    showModalBottomSheet(
        backgroundColor: AppColors.secondaryContainerColor,
        context: context,
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
        ),
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 350,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Redeem Instore",
                                style: AppTextStyle.bold16
                                    .copyWith(color: AppColors.blackColor),
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: MediaQuery.of(context).size.width - 50,
                                child: Text(
                                  "Present the barcode and share this 4 digit code with the cashier to complete your transaction",
                                  style: AppTextStyle.semiBold14
                                      .copyWith(color: AppColors.blackColor),
                                  maxLines: 3,
                                ),
                              ),
                            ]),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      GlobalSingleton.userInformation.membershipNo ?? "",
                      style: AppTextStyle.bold24.copyWith(
                          letterSpacing: 5, color: AppColors.blackColor),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: BarcodeWidget(
                        barcode: Barcode.code128(),
                        height: AppSizes.size50,
                        width: MediaQuery.of(context).size.width * .7,
                        drawText: false,
                        data:
                            GlobalSingleton.userInformation.membershipNo ?? "",
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10.0),
                      child: Divider(),
                    ),
                    FittedBox(
                      child: Container(
                        margin: const EdgeInsets.only(left: 25),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            for (int i = 0; i < otpValue.length; i++)
                              Text(
                                otpValue[i].toString() + "         ",
                                style: AppTextStyle.bold24
                                    .copyWith(color: AppColors.blackColor),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _otpBtnHide
                        ? Container(
                            alignment: Alignment.center,
                            height: AppSizes.size60,
                            width: MediaQuery.of(context).size.width * .5,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: 1, color: AppColors.blackColor),
                              borderRadius:
                                  BorderRadius.circular(AppSizes.size30),
                            ),
                            child: FittedBox(
                              child: Countdown(
                                animation: StepTween(
                                  begin: 300,
                                  end: 0,
                                ).animate(_controller)
                                  ..addStatusListener((status) {
                                    if (status == AnimationStatus.completed) {
                                      setState(() {
                                        _otpBtnHide = false;
                                      });
                                    }
                                  }),
                              ),
                            ))
                        : GestureDetector(
                            onTap: () async {
                              otpValue = await generateOtp(context);
                              setState(() {});
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: AppSizes.size60,
                              width: MediaQuery.of(context).size.width * .5,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: AppColors.blackColor),
                                borderRadius:
                                    BorderRadius.circular(AppSizes.size30),
                              ),
                              child: const Text(
                                'GENERATE NEW OTP',
                                style: TextStyle(color: AppColors.blackColor),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> accural() async {
    showModalBottomSheet(
        backgroundColor: AppColors.secondaryContainerColor,
        context: context,
        isScrollControlled: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        builder: (ctx) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 250,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Scan Barcode",
                          style: AppTextStyle.bold20
                              .copyWith(color: AppColors.blackColor),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Icon(
                            Icons.cancel_outlined,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 50,
                      child: Text(
                        "Present the barcode to the cashier at checkout to complete your transaction",
                        style: AppTextStyle.semiBold14
                            .copyWith(color: AppColors.blackColor),
                        maxLines: 3,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        GlobalSingleton.userInformation.membershipNo ?? "",
                        style: AppTextStyle.bold24.copyWith(
                            letterSpacing: 5, color: AppColors.blackColor),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: BarcodeWidget(
                        barcode: Barcode.code128(),
                        height: AppSizes.size50,
                        width: MediaQuery.of(context).size.width * .7,
                        drawText: false,
                        data:
                            GlobalSingleton.userInformation.membershipNo ?? "",
                      ),
                    )
                  ],
                ),
              ),
            );
          });
        });
  }
}
