import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/enum.dart';
import 'package:bounz_revamp_app/models/country/country_model.dart';
import 'package:bounz_revamp_app/utils/validator.dart';
import 'package:bounz_revamp_app/widgets/country_picker_bottomsheet.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GiftFriendTabScreen extends StatefulWidget {
  final Function(GiftFor giftFor, Map<String, dynamic> data) onConfirmed;
  const GiftFriendTabScreen({Key? key, required this.onConfirmed})
      : super(key: key);

  @override
  _GiftFriendTabScreenState createState() => _GiftFriendTabScreenState();
}

TextEditingController firstNameController = TextEditingController();
TextEditingController lastNameController = TextEditingController();
TextEditingController mobileNumberController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController pincodeController = TextEditingController();
TextEditingController designationController = TextEditingController();

class _GiftFriendTabScreenState extends State<GiftFriendTabScreen> {
  FocusNode eName = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Country? selectedCountry;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.size20,
        right: AppSizes.size20,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(
                height: AppSizes.size20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormFieldWidget(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(RegExp("[?.0-9]"))
                      ],
                      labelText: AppConstString.firstName,
                      controller: firstNameController,
                      validator: (value) => Validators.validateText(
                        value,
                        "First Name",
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: AppSizes.size12,
                  ),
                  Expanded(
                    child: TextFormFieldWidget(
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.deny(RegExp("[?.0-9]"))
                      ],
                      labelText: AppConstString.lastName,
                      controller: lastNameController,
                      validator: (value) =>
                          Validators.validateText(value, "Last Name"),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              EmailWidget(
                labelText: AppConstString.email,
                controller: emailController,
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              mobileNumberInput(),
              const SizedBox(
                height: AppSizes.size20,
              ),
              confirmButton(),
              const SizedBox(
                height: AppSizes.size20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget fullNameWidget() {
    return TextFormFieldWidget(
      labelText: AppConstString.frdName,
      controller: firstNameController,
    );
  }

  Widget emailWidget() {
    return EmailWidget(
      labelText: 'Enter Email ID*',
      controller: emailController,
    );
  }

  Widget mobileNumberInput() {
    return NumberWidget(
      hintText: AppConstString.mobileNo,
      hintStyle: AppTextStyle.regular16,
      prefixIconConstraints: BoxConstraints.loose(const Size(110, 50)),
      prefixIcon: GestureDetector(
        onTap: () {
          countryPickerBottomsheet(
            buildContext: context,
            location: false,
            text: "Enter Your Country Code",
            passValue: (Country country) {
              setState(() {
                selectedCountry = country;
              });
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
                  selectedCountry?.image ?? AppAssets.uaeFlag,
                ),
              ),
            ),
            const SizedBox(
              width: AppSizes.size4,
            ),
            Text(
              "+${selectedCountry?.countryCode ?? "971"}",
              style: AppTextStyle.semiBold16,
            ),
            const Icon(
              Icons.arrow_drop_down_sharp,
              color: AppColors.whiteColor,
            ),
            const SizedBox(
              width: AppSizes.size4,
            ),
            Container(
              height: AppSizes.size20,
              width: 1,
              color: AppColors.whiteColor,
            ),
          ],
        ),
      ),
      controller: mobileNumberController,
      maxLength: selectedCountry?.mobileNumberLength ?? 9,
      validator: (value) => Validators.validateMobile(value),
    );
  }

  Widget confirmButton() {
    return PrimaryButton(
        text: AppConstString.confirm,
        onTap: () {
          if (_formKey.currentState!.validate()) {
            Navigator.of(context).pop();
            Map<String, dynamic> data = {
              "receiver_first_name": firstNameController.text.trim(),
              "receiver_last_name": lastNameController.text.trim(),
              "receiver_title": firstNameController.text.trim() +
                  lastNameController.text.trim(),
              "receiver_email": emailController.text.trim(),
              "receiver_mobile": mobileNumberController.text.trim(),
              "receiver_country_code":
                  "+${selectedCountry?.countryCode ?? "971"}",
              "receiver_country":
                  selectedCountry?.nationality ?? "United Arab Emirates",
            };
            widget.onConfirmed(GiftFor.friend, data);
          }
        },
        tColor: AppColors.whiteColor,
        bColor: AppColors.backgroundColor);
  }
}
