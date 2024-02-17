import 'dart:async';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/widgets/pin_code_fields.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:bounz_revamp_app/modules/auth/otp/otp_varification_view.dart';
import 'package:bounz_revamp_app/modules/auth/otp/otp_varification_model.dart';
import 'package:bounz_revamp_app/modules/auth/otp/otp_varification_presenter.dart';
// ignore_for_file: must_be_immutable

@RoutePage()
class OtpVerificationOnboarding extends StatefulWidget {
  final OtpVarificationPresenter presenter;

  const OtpVerificationOnboarding(this.presenter, {Key? key}) : super(key: key);

  @override
  _OtpVerificationOnboardingState createState() =>
      _OtpVerificationOnboardingState();
}

class _OtpVerificationOnboardingState extends State<OtpVerificationOnboarding>
    implements OtpVarificationView {
  final TextEditingController otpController = TextEditingController();
  late OtpVarificationModel _model;

  Timer? countdownTimer;

  String get timerText =>
      '${((180 - _model.currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((180 - _model.currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int? milliseconds]) {
    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      widget.presenter.updateTimer(timer);
    });
  }

  @override
  initState() {
    super.initState();
    widget.presenter.reSetView = this;
    startTimeout();
  }

  @override
  void refreshModel(OtpVarificationModel model) {
    setState(() {
      _model = model;
    });
  }

  @override
  void resendOtp() {
    startTimeout();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> number = [];
    if (_model.email == null) {
      number = _model.mobileNumber.split('').toList();
      number.replaceRange(0, number.length - 4, ['******']);
    }
    return Scaffold(
      body: AppBackGroundWidget(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
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
                height: AppSizes.size44,
              ),
              Text(
                _model.email == null
                    ? AppConstString.otpVerify1
                    : "Enter OTP to verify!",
                style: AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
              ),
              if (_model.email == null)
                Text(
                  AppConstString.otpVerify2,
                  style: AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
                ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              Text(
                'Enter the 5 digit code sent on  ${_model.email ?? number.join()}',
                style: AppTextStyle.light16,
              ),
              const SizedBox(
                height: AppSizes.size40,
              ),
              otpWidget(),
              const SizedBox(
                height: AppSizes.size24,
              ),
              resendOtpButton(),
              const SizedBox(
                height: AppSizes.size10,
              ),
              proceedButtonWidget(),
              const SizedBox(
                height: AppSizes.size20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget resendOtpButton() {
    return Center(
      child: RoundedBorderButton(
        onTap: () {
          if (_model.enableResend) {
            widget.presenter.resendOtp(
              context: context,
            );
          }
        },
        text: _model.enableResend ? 'Resend OTP' : 'Resend OTP in $timerText',
        tColor: _model.enableResend
            ? AppColors.blackColor
            : AppColors.blackColor.withOpacity(0.37),
        bColor: _model.enableResend
            ? AppColors.btnBlueColor
            : AppColors.btnBlueColor.withOpacity(0.37),
      ),
    );
  }

  Widget proceedButtonWidget() {
    return Center(
      child: PrimaryButton(
        onTap: () {
          if (otpController.text.length == 5) {
            widget.presenter.verifyOtp(
              context: context,
              otpText: otpController.text,
            );
          } else {
            NetworkDio.showWarning(
              context: context,
              message: '5 digit OTP is required.',
            );
          }
        },
        text: AppConstString.proceed,
        showShadow: true,
      ),
    );
  }

  Widget otpWidget() {
    return PinCodeTextField(
      appContext: context,
      length: 5,
      controller: otpController,
      onChanged: (String value) {},
    );
  }
}
