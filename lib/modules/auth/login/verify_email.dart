import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/otp_input_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({Key? key}) : super(key: key);
  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final TextEditingController otpInput1 = TextEditingController();
  final TextEditingController otpInput2 = TextEditingController();
  final TextEditingController otpInput3 = TextEditingController();
  final TextEditingController otpInput4 = TextEditingController();
  final TextEditingController otpInput5 = TextEditingController();
  final TextEditingController otpInput6 = TextEditingController();

  final formKey = GlobalKey<FormState>();
  final _focusNodes = List.generate(
    5,
    (index) => FocusNode(),
  );
  final _textControllers = List.generate(
    5,
    (index) => TextEditingController(),
  );
  late FocusNode _firstTextFieldFocusNode;
  String buttonText = 'Verify & Continue';

  @override
  void initState() {
    super.initState();
    _firstTextFieldFocusNode = FocusNode();
    _focusNodes[0] = _firstTextFieldFocusNode;
    _firstTextFieldFocusNode.requestFocus();
    for (int i = 0; i < 5; i++) {
      final textController = _textControllers[i];
      final focusNode = _focusNodes[i];
      textController.addListener(() {
        if (textController.text.isEmpty && i > 0 && !focusNode.hasFocus) {
          _focusNodes[i - 1].requestFocus();
        }
      });
      if (i < 4) {
        final nextFocusNode = _focusNodes[i + 1];
        textController.addListener(() {
          if (textController.text.isNotEmpty && focusNode.hasFocus) {
            focusNode.unfocus();
            nextFocusNode.requestFocus();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _firstTextFieldFocusNode.dispose();
    for (int i = 0; i < 5; i++) {
      _focusNodes[i].dispose();
      _textControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: GestureDetector(
        onTap: () {
          // Remove focus from all text form fields when user taps anywhere on the screen
          for (var focusNode in _focusNodes) {
            focusNode.unfocus();
          }
        },
        child: AppBackGroundWidget(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.size28,
                    ),
                    Text(
                      AppConstString.otpVerify,
                      style:
                          AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
                    ),
                    const SizedBox(
                      height: AppSizes.size14,
                    ),
                    Text(
                      AppConstString.enter5digit,
                      style: AppTextStyle.regular16,
                    ),
                    const SizedBox(
                      height: AppSizes.size30,
                    ),
                    otpWidget(),
                    const SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(AppConstString.resendOTP,
                                style: AppTextStyle.bold12),
                            Container(
                              width: AppSizes.size70,
                              height: 1,
                              color: AppColors.whiteColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: AppSizes.size40),
                        child: Column(
                          children: [
                            PrimaryButton(
                              onTap: () {
                                MoenageManager.logScreenEvent(
                                    name: 'Help Support');

                                AutoRouter.of(context).push(
                                  HelpSupportScreenRoute(),
                                );
                              },
                              text: "Verify & Continue",
                            ),
                          ],
                        ),
                      ),
                    )
                  ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget otpWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Container(
        height: 40.0,
        width: 330,
        decoration: BoxDecoration(
          color: AppColors.brownishColor.withOpacity(0.3),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            OtpInput(controller: otpInput1, index: 0, otpLength: 0),
            OtpInput(controller: otpInput2, index: 1, otpLength: 1),
            OtpInput(controller: otpInput3, index: 2, otpLength: 2),
            OtpInput(controller: otpInput4, index: 3, otpLength: 3),
            OtpInput(
              controller: otpInput5,
              index: 4,
              otpLength: 4,
              showLine: false,
            ),
          ],
        ),
      ),
    );
  }
}
