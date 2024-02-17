import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/models/country/country_model.dart';
import 'package:bounz_revamp_app/modules/auth/login/login_registration_model.dart';
import 'package:bounz_revamp_app/modules/auth/login/login_registration_presenter.dart';
import 'package:bounz_revamp_app/modules/auth/login/login_registration_view.dart';
import 'package:bounz_revamp_app/modules/auth/login/soical_button_widget.dart';
import 'package:bounz_revamp_app/utils/validator.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/country_picker_bottomsheet.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

@RoutePage()
class LoginRegistrationScreen extends StatefulWidget {
  final LoginRegistrationPresenter presenter;
  const LoginRegistrationScreen(this.presenter, {Key? key}) : super(key: key);

  @override
  State<LoginRegistrationScreen> createState() =>
      _LoginRegistrationScreenState();
}

class _LoginRegistrationScreenState extends State<LoginRegistrationScreen>
    implements LoginRegistrationView {
  final focusNode = FocusNode();
  late LoginRegistrationModel _model;
  TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget.presenter.loginRegistrationView = this;
  }

  @override
  void refreshModel(LoginRegistrationModel loginRegistrationModel) {
    if (mounted) {
      setState(() {
        _model = loginRegistrationModel;
      });
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        padding:
            const EdgeInsets.only(left: AppSizes.size20, top: AppSizes.size20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: AppSizes.size10,
            ),
            SvgPicture.asset(AppAssets.bounzWithLetter),
            const SizedBox(
              height: AppSizes.size20,
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      topView(),
                      const SizedBox(
                        height: AppSizes.size40,
                      ),
                      mobileNumberInput(),
                      const SizedBox(
                        height: AppSizes.size40,
                      ),
                      proceedButton(),
                      const SizedBox(
                        height: AppSizes.size28,
                      ),
                      _model.isAppleSignIn || _model.isGoogleSignIn
                          ? const SizedBox()
                          : orDivider(),
                      const SizedBox(
                        height: AppSizes.size22,
                      ),
                      _model.isGoogleSignIn == false &&
                              _model.isAppleSignIn == false
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(right: AppSizes.size18),
                              child: Center(
                                child: Text(
                                  AppConstString.continueWith,
                                  style: AppTextStyle.regular14,
                                ),
                              ),
                            )
                          : const SizedBox(),
                      const SizedBox(
                        height: AppSizes.size16,
                      ),
                      _model.isGoogleSignIn == false &&
                              _model.isAppleSignIn == false
                          ? socialLoginButton()
                          : const SizedBox(),
                      const SizedBox(
                        height: AppSizes.size44,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget topView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppConstString.kindlyEnterMobileNumber,
          style: AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
        ),
        const SizedBox(
          height: AppSizes.size16,
        ),
        Text(
          AppConstString.noBuzzingAtOdd,
          style: AppTextStyle.light16,
        ),
      ],
    );
  }

  Widget mobileNumberInput() {
    return Padding(
      padding: const EdgeInsets.only(right: AppSizes.size20),
      child: NumberWidget(
        focusNode: focusNode,
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.deny(RegExp("[^a-zA-Z0-9]"))
        ],
        hintText: AppConstString.mobileNo,
        hintStyle: AppTextStyle.regular16,
        prefixIconConstraints: BoxConstraints.loose(const Size(125, 50)),
        prefixIcon: GestureDetector(
          onTap: () {
            countryPickerBottomsheet(
              buildContext: context,
              location: false,
              text: "Enter Your Country Code",
              passValue: (Country country) {
                widget.presenter.selectCountry(country);
                phoneController.clear();
                setState(() {});
              },
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: AppSizes.size16,
                child: CircleAvatar(
                  radius: 15.0,
                  backgroundImage: NetworkImage(
                    _model.countryCode?.image ?? AppAssets.uaeFlag,
                  ),
                ),
              ),
              const SizedBox(
                width: AppSizes.size4,
              ),
              Text(
                "+${_model.countryCode?.countryCode ?? "971"}",
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
        keyboardType: TextInputType.number,
        maxLength: _model.countryCode?.mobileNumberLength ?? 9,
        validator: (value) {
          return Validators.validateMobile(
            value,
            mobileNumberLength: _model.countryCode?.mobileNumberLength ?? 9,
          );
        },
      ),
    );
  }

  Widget proceedButton() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(
            bottom: AppSizes.size20, right: AppSizes.size20),
        child: PrimaryButton(
          width: MediaQuery.of(context).size.width * .55,
          text: AppConstString.proceed,
          showShadow: true,
          onTap: () {
            Map<String, dynamic> data = {
              'country_code':
                  _model.countryCode?.countryCode!.replaceAll('-', '') ?? '971',
              'phone': phoneController.text,
            };
            if (_model.isGoogleSignIn == true || _model.isAppleSignIn == true) {
              data = {
                'country_code':
                    _model.countryCode?.countryCode!.replaceAll('-', '') ??
                        '971',
                'phone': phoneController.text,
                'isSocialMediaRegister': 1 //
              };
            }
            if (_formKey.currentState!.validate()) {
              widget.presenter.generateOtp(context: context, data: data);
            }
          },
        ),
      ),
    );
  }

  Widget orDivider() {
    return Padding(
      padding: const EdgeInsets.only(
        right: AppSizes.size20,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 1,
            width: 12,
            color: AppColors.whiteColor.withOpacity(0.5),
          ),
          const SizedBox(
            width: AppSizes.size6,
          ),
          Text(
            AppConstString.or,
            style: AppTextStyle.extraLight14,
          ),
          const SizedBox(
            width: AppSizes.size6,
          ),
          Container(
            height: 1,
            width: 12,
            color: AppColors.whiteColor.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget socialLoginButton() {
    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSizes.size10),
        margin: const EdgeInsets.only(
          right: AppSizes.size20,
        ),
        width: MediaQuery.of(context).size.width / 2.0,
        decoration: BoxDecoration(
          border: Border.all(width: 0.4, color: AppColors.whiteColor),
          borderRadius: BorderRadius.circular(AppSizes.size20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SocialButtonWidget(
              text: AppConstString.google,
              icon: AppAssets.google,
              tap: () async {
                await widget.presenter.signinwithGoogle(context);
              },
            ),
            if (Platform.isIOS)
              const Divider(
                color: AppColors.whiteColor,
                thickness: 0.5,
              ),
            if (Platform.isIOS)
              SocialButtonWidget(
                text: AppConstString.apple,
                icon: AppAssets.apple,
                tap: () async {
                  await widget.presenter.signinwithApple(context);
                },
              ),
          ],
        ),
      ),
    );
  }
}
