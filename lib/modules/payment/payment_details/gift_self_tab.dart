import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/constants/enum.dart';
import 'package:bounz_revamp_app/utils/validator.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class GiftSelfTabScreen extends StatefulWidget {
  final Function(GiftFor giftFor) onConfirmed;
  const GiftSelfTabScreen({Key? key, required this.onConfirmed})
      : super(key: key);

  @override
  _GiftSelfTabScreenState createState() => _GiftSelfTabScreenState();
}

class _GiftSelfTabScreenState extends State<GiftSelfTabScreen> {
  String countryImage =
      StorageManager.getStringValue(AppStorageKey.mobileNumberCountryImage)
          .toString();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSizes.size20,
        right: AppSizes.size20,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: AppSizes.size20,
          ),
          fullNameWidget(),
          const SizedBox(
            height: AppSizes.size20,
          ),
          emailWidget(),
          const SizedBox(
            height: AppSizes.size20,
          ),
          mobileNumberInput(),
          const SizedBox(
            height: AppSizes.size30,
          ),
          confirmButton(),
        ],
      ),
    );
  }

  Widget fullNameWidget() {
    return TextFormFieldWidget(
      labelText: 'Full Name*',
      controller: TextEditingController(
        text: GlobalSingleton.userInformation.firstName.toString() +
            ' ' +
            GlobalSingleton.userInformation.lastName.toString(),
      ),
      enabled: false,
    );
  }

  Widget emailWidget() {
    return EmailWidget(
      labelText: 'Email ID*',
      controller: TextEditingController(
        text: GlobalSingleton.userInformation.email.toString(),
      ),
      enabled: false,
    );
  }

  Widget mobileNumberInput() {
    return NumberWidget(
      hintText: AppConstString.mobileNo,
      hintStyle: AppTextStyle.regular16,
      enabled: false,
      prefixIconConstraints: BoxConstraints.loose(const Size(110, 50)),
      prefixIcon: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (countryImage.isNotEmpty)
            SizedBox(
              height: AppSizes.size16,
              child: CircleAvatar(
                radius: 15.0,
                backgroundImage: NetworkImage(
                  StorageManager.getStringValue(
                          AppStorageKey.mobileNumberCountryImage)
                      .toString(),
                ),
              ),
            ),
          const SizedBox(
            width: AppSizes.size4,
          ),
          Text(
            "+${GlobalSingleton.userInformation.countryCode}",
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
      controller: TextEditingController(
        text: GlobalSingleton.userInformation.mobileNumber.toString(),
      ),
      maxLength: 9,
      validator: (value) => Validators.validateMobile(value),
    );
  }

  Widget confirmButton() {
    return PrimaryButton(
      text: AppConstString.confirm,
      onTap: () {
        Navigator.of(context).pop();
        widget.onConfirmed(GiftFor.mySelf);
      },
      bColor: AppColors.backgroundColor,
    );
  }
}
