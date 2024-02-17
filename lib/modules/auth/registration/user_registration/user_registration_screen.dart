import 'dart:io';

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
import 'package:bounz_revamp_app/models/city/city_model.dart';
import 'package:bounz_revamp_app/models/country/country_model.dart';
import 'package:bounz_revamp_app/modules/auth/registration/user_registration/user_registration_presenter.dart';
import 'package:bounz_revamp_app/modules/auth/registration/user_registration/user_registration_view.dart';
import 'package:bounz_revamp_app/utils/api_path.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/utils/progress_indicator.dart';
import 'package:bounz_revamp_app/utils/validator.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/city_picker_bottomsheet.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moengage_flutter/properties.dart';

@RoutePage()
class UserRegistrationScreen extends StatefulWidget {
  final String countryCode;
  final String mobileNumber;
  const UserRegistrationScreen({
    Key? key,
    required this.countryCode,
    required this.mobileNumber,
  }) : super(key: key);

  @override
  _UserRegistrationScreenState createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen>
    implements UserRegistrationView {
  bool? isMale;
  DateTime? dateTime;
  bool checkboxSelect = false;
  Circle processIndicator = Circle();
  FocusNode fName = FocusNode();
  FocusNode lName = FocusNode();
  String? residentDropdownValue;
  String? nationalityDropdownValue;
  FocusNode eName = FocusNode();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController referralCodeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController residentCountryController = TextEditingController();

  TextEditingController selectCityController = TextEditingController();

  final GlobalKey<FormState> _personalDetailsformkey = GlobalKey<FormState>();

  UserRegistrationPresenter personalDetailsPresenter =
      UserRegistrationPresenter();

  Country? nationalityCountry;
  Country? residenatlCountry;
  City? citySelect;
  String? provider;
  String? googleId;
  String? appleId;
  String loginType = 'Phone';
  @override
  void initState() {
    super.initState();
    Map<String, dynamic>? data = GlobalSingleton.registerUserInfo;
    referralCodeController.text = GlobalSingleton.referralno ?? '';
    if (data != null) {
      firstNameController.text = data['first_name'] ?? '';
      lastNameController.text = data['last_name'] ?? '';
      emailController.text = data['email'] ?? '';
      dobController.text = data['dob'] ?? '';
      if (data.containsKey('google_id')) {
        provider = 'google';
        googleId = data['google_id'];
        loginType = 'Google';
      }
      if (data.containsKey('apple')) {
        provider = 'apple';
        googleId = data['apple_id'];
        loginType = 'Apple';
      }
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateTime ??
          DateTime(
            DateTime.now().year - 16,
            DateTime.now().month,
            DateTime.now().day,
          ),
      firstDate: DateTime(1950, 8),
      lastDate: DateTime(
        DateTime.now().year - 16,
        DateTime.now().month,
        DateTime.now().day,
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.darkOrangeColor, // header background color
              onPrimary: AppColors.whiteColor, // header text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.backgroundColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != dateTime) {
      setState(() {
        dateTime = picked;
        dobController.text = picked.dmyFormat;
      });
    }
  }

  void contineOnTap() async {
    if (isMale != null) {
      if (checkboxSelect) {
        processIndicator.show(context);
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        processIndicator.hide(context);
        if (fcmToken != null) {
          personalDetailsPresenter.createUser(
            context: context,
            loginType: loginType,
            nantionlityContryName: nationalityController.text,
            residenatlCountryName: residentCountryController.text,
            selectCityName: selectCityController.text.isNotEmpty
                ? selectCityController.text
                : "",
            data: {
              "phone": widget.mobileNumber,
              "country_code": widget.countryCode,
              "first_name": firstNameController.text.trim(),
              "last_name": lastNameController.text.trim(),
              "email": emailController.text.trim(),
              "dob": dobController.text,
              "nationality": nationalityCountry != null
                  ? nationalityCountry!.id.toString()
                  : "",
              "gender": isMale == true ? "male" : "female",
              "residential_country":
                  residenatlCountry != null ? residenatlCountry!.id : 0,
              "status": 1,
              "lang_code": "EN",
              "os": Platform.isIOS ? 'ios' : 'android',
              "city_id": citySelect != null ? citySelect!.id : 0,
              "referral_code": referralCodeController.text,
              "user_agent": "mobile",
              "fcm_token": fcmToken,
              "device_id": "1d2b3c1e-1o13-26ac-a650-e72e3173ee58",
              "communication_preference": true,
              "otp_verified": 1,
              "google_id": googleId,
              "apple_id": appleId,
              "login_step": 1,
              "store_code": GlobalSingleton.storeCode,
              "partner_id": GlobalSingleton.partnerId,
            },
          );
        } else {
          NetworkDio.showError(
            title: 'Error',
            errorMessage: "Sometings went wrong",
            context: context,
          );
        }
      } else {
        NetworkDio.showError(
          title: 'Error',
          errorMessage: AppConstString.selectTandC,
          context: context,
        );
      }
    } else {
      NetworkDio.showError(
        title: 'Error',
        errorMessage: AppConstString.pleaseSelectGender,
        context: context,
      );
    }
  }

  Future<List<Country>> getCountryList(BuildContext context) async {
    List<Country> countryList = [];
    final Map<String, dynamic>? response = await NetworkDio.getDioHttpMethod(
      context: context,
      url: ApiPath.apiEndPoint + ApiPath.country,
    );
    if (response != null) {
      for (Map<String, dynamic> i in response['data']['values']
          ['top_country']) {
        countryList.add(Country.fromJson(i));
      }
      for (Map<String, dynamic> i in response['data']['values']
          ['other_country']) {
        countryList.add(Country.fromJson(i));
      }
      GlobalSingleton.countryList = countryList;
    }
    return countryList;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: AppBackGroundWidget(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 18.0,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: bodyView(),
                  ),
                ),
                continueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bodyView() {
    return Form(
      key: _personalDetailsformkey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppConstString.personalDetailsHeader,
            style: AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
          ),
          const SizedBox(
            height: 28.0,
          ),
          Text(
            AppConstString.selectGender,
            style: AppTextStyle.semiBold16,
          ),
          const SizedBox(
            height: 12.0,
          ),
          selectGenderView(),
          const SizedBox(
            height: AppSizes.size20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormFieldWidget(
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.deny(
                        RegExp("[\"?.0-9`;&!#\$%&*():<>^]"))
                  ],
                  keyboardType: TextInputType.name,
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
                    FilteringTextInputFormatter.deny(
                        RegExp("[\"?.0-9`;&!#\$%&*():<>^]"))
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
            enabled: googleId != null || appleId != null ? false : true,
          ),
          const SizedBox(
            height: AppSizes.size20,
          ),
          dobWidget(),
          const SizedBox(
            height: AppSizes.size20,
          ),
          nationalityWidget(),
          const SizedBox(
            height: AppSizes.size20,
          ),
          residentWidget(),
          const SizedBox(
            height: AppSizes.size20,
          ),
          residentCountryController.text == "United Arab Emirates"
              ? cityWidget()
              : const SizedBox(),
          residentCountryController.text == "United Arab Emirates"
              ? const SizedBox(
                  height: AppSizes.size20,
                )
              : const SizedBox(),
          referralInputWidget(),
          const SizedBox(
            height: AppSizes.size8,
          ),
          tAndC(),
        ],
      ),
    );
  }

  Widget selectGenderView() {
    return Container(
      height: 118,
      decoration: BoxDecoration(
        border: Border.all(
          width: 0.6,
          color: AppColors.whiteColor,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isMale = true;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        height: 56,
                        width: 56,
                        child: SvgPicture.asset(
                          AppAssets.men,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    isMale == true ? checkIcon() : const SizedBox(),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.size4,
                ),
                Text(
                  AppConstString.male,
                  style: AppTextStyle.regular16,
                ),
              ],
            ),
          ),
          const VerticalDivider(
            thickness: 0.6,
            color: AppColors.whiteColor,
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                isMale = false;
              });
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    ClipOval(
                      child: SizedBox(
                        height: 56,
                        width: 56,
                        child: SvgPicture.asset(
                          AppAssets.women,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    isMale == false ? checkIcon() : const SizedBox(),
                  ],
                ),
                const SizedBox(
                  height: AppSizes.size4,
                ),
                Text(
                  AppConstString.female,
                  style: AppTextStyle.regular16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget checkIcon() {
    return Positioned(
      top: 24.0,
      left: 31.95,
      bottom: 0,
      child: Image.asset(
        AppAssets.greenTick,
      ),
    );
  }

  Widget dobWidget() {
    return TextFormFieldWidget(
      labelText: "Date of Birth*",
      controller: dobController,
      readOnly: true,
      autofocus: false,
      suffixIconConstraints: BoxConstraints.loose(
        const Size(50, 50),
      ),
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        selectDate(context);
      },
      validator: (value) => Validators.validateText(
        value,
        "DOB",
      ),
      suffixIcon: GestureDetector(
        onTap: () {
          selectDate(context);
        },
        child: Center(
          child: SvgPicture.asset(AppAssets.calendar),
        ),
      ),
    );
  }

  Widget nationalityWidget() {
    return TextFormFieldWidget(
      controller: nationalityController,
      readOnly: true,
      autofocus: false,
      labelText: AppConstString.nationality + '*',
      validator: (value) => Validators.validateText(
        value,
        "Nationality",
      ),
      suffixIconConstraints: BoxConstraints.loose(
        const Size(50, 50),
      ),
      suffixIcon: const Center(
        child: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: AppColors.whiteColor,
          size: AppSizes.size24,
        ),
      ),
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showCountryPicker(
          text: "Select Your Nationality",
          buildContext: context,
          onSelect: (country) {
            nationalityCountry = country;
            nationalityController.text = country.name.toString();
            StorageManager.setStringValue(
                key: AppStorageKey.storeNationalityImage,
                value: country.image.toString());
            final properties = MoEProperties();
            properties
                .addAttribute(TriggeringCondition.selectedLocation,
                    country.name.toString())
                .addAttribute(
                    TriggeringCondition.screenName, 'User Registration')
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.locationSelected,
              properties: properties,
            );
            setState(() {});
          },
        );
      },
    );
  }

  Widget residentWidget() {
    return TextFormFieldWidget(
      controller: residentCountryController,
      readOnly: true,
      labelText: AppConstString.residentCountry,
      suffixIconConstraints: BoxConstraints.loose(
        const Size(50, 50),
      ),
      suffixIcon: const Center(
        child: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: AppColors.whiteColor,
          size: AppSizes.size24,
        ),
      ),
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showCountryPicker(
          text: "Select Your Resident Country",
          buildContext: context,
          onSelect: (country) {
            residenatlCountry = country;
            residentCountryController.text = country.name.toString();
            StorageManager.setStringValue(
                key: AppStorageKey.storeResidentImage,
                value: country.image.toString());
            setState(() {});
          },
        );
      },
    );
  }

  Widget cityWidget() {
    return TextFormFieldWidget(
      controller: selectCityController,
      readOnly: true,
      labelText: AppConstString.citySelect,
      suffixIconConstraints: BoxConstraints.loose(
        const Size(50, 50),
      ),
      suffixIcon: const Center(
        child: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: AppColors.whiteColor,
          size: AppSizes.size24,
        ),
      ),
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showCityPicker(
          text: "Select Your City",
          buildContext: context,
          onSelect: (city) {
            citySelect = city;
            selectCityController.text = city.cityName.toString();
            setState(() {});
          },
        );
      },
    );
  }

  Widget referralInputWidget() {
    return TextFormFieldWidget(
      enabled: referralCodeController.text.isEmpty,
      controller: referralCodeController,
      labelText: "Referral Code",
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.deny(RegExp("[\"?.`;&!#\$%&*():<>^ ]"))
      ],
    );
  }

  Widget tAndC() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Transform.scale(
          scale: 1,
          child: Checkbox(
            checkColor: AppColors.whiteColor,
            activeColor: Colors.transparent,
            side: MaterialStateBorderSide.resolveWith(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.selected)) {
                  return const BorderSide(color: AppColors.whiteColor);
                }
                return const BorderSide(color: AppColors.whiteColor);
              },
            ),
            value: checkboxSelect,
            onChanged: (bool? value) {
              setState(() {
                checkboxSelect = value!;
              });
            },
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text: AppConstString.tnc1,
                  style: AppTextStyle.bold12,
                ),
                TextSpan(
                  text: AppConstString.tnc2,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      MoenageManager.logScreenEvent(name: 'Privacy Policy');

                      AutoRouter.of(context).push(
                        PrivacyPolicyRoute(),
                      );
                    },
                  style: AppTextStyle.bold12.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: AppConstString.tnc3,
                  style: AppTextStyle.bold12,
                ),
                TextSpan(
                  text: AppConstString.tnc4,
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      MoenageManager.logScreenEvent(name: 'Terms Conditions');

                      AutoRouter.of(context).push(
                        TermsConditionsRoute(),
                      );
                    },
                  style: AppTextStyle.bold12.copyWith(
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget continueButton() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: AppSizes.size12,
          ),
          Center(
            child: PrimaryButton(
              onTap: () {
                StorageManager.setStringValue(
                    key: AppStorageKey.isFilled,
                    value: referralCodeController.text.toString());
                if (_personalDetailsformkey.currentState!.validate()) {
                  contineOnTap();
                }
              },
              text: AppConstString.ctn,
              showShadow: true,
            ),
          ),
          const SizedBox(
            height: AppSizes.size30,
          ),
        ],
      ),
    );
  }

  void showCountryPicker({
    required String text,
    required BuildContext buildContext,
    required Function(Country country) onSelect,
  }) async {
    List<Country> countryList =
        GlobalSingleton.countryList ?? await getCountryList(buildContext);
    List<Country> searchCountry = countryList;
    var notMatchCountryText = AppConstString.noResultFound;
    List<Country> search(String query) {
      return countryList
          .where((e) => e.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    showModalBottomSheet(
      backgroundColor: AppColors.secondaryContainerColor,
      isScrollControlled: true,
      shape: const OutlineInputBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter stx) {
            final viewInsets = MediaQuery.of(context).viewInsets;
            return Padding(
              padding: EdgeInsets.only(
                bottom: viewInsets.bottom,
              ),
              child: SizedBox(
                height: 350.0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                      AppSizes.size20, AppSizes.size20, AppSizes.size20, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            text,
                            style: AppTextStyle.bold16.copyWith(
                              color: AppColors.blackColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: AppSizes.size20,
                      ),
                      searchField(
                        onChanged: (String? value) {
                          if (value != null) {
                            searchCountry = search(value);
                          } else if (value!.isEmpty) {
                            searchCountry = countryList;
                          } else {
                            searchCountry = countryList;
                          }
                          stx(() {});
                        },
                      ),
                      const SizedBox(
                        height: AppSizes.size10,
                      ),
                      Expanded(
                        child: searchCountry.isNotEmpty
                            ? ListView.separated(
                                itemCount: searchCountry.length,
                                padding: const EdgeInsets.only(
                                  top: AppSizes.size10,
                                ),
                                physics: const BouncingScrollPhysics(),
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(
                                    height: AppSizes.size20,
                                  );
                                },
                                itemBuilder: (BuildContext context, int index) {
                                  return InkWell(
                                    child: Row(
                                      children: [
                                        ClipOval(
                                          child: SizedBox(
                                            height: AppSizes.size40,
                                            width: AppSizes.size40,
                                            child: networkImage(
                                              searchCountry[index]
                                                  .image
                                                  .toString(),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: AppSizes.size16,
                                        ),
                                        Flexible(
                                          child: Text(
                                            searchCountry[index]
                                                .name
                                                .toString(),
                                            style: AppTextStyle.semiBold16
                                                .copyWith(
                                                    color:
                                                        AppColors.blackColor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      onSelect(searchCountry[index]);
                                      Navigator.of(context).pop();
                                    },
                                  );
                                },
                              )
                            : Center(
                                child: Text(
                                notMatchCountryText,
                                style: AppTextStyle.bold22.copyWith(
                                  color: AppColors.brownishColor,
                                ),
                              )),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget searchField({required Function(String? value) onChanged}) {
    return TextFormFieldWidget(
      suffixIconConstraints: BoxConstraints.loose(
        const Size(50, 50),
      ),
      labelText: "Search",
      suffixIcon: const Center(
        child: Icon(
          Icons.search,
          color: AppColors.whiteColor,
          size: AppSizes.size24,
        ),
      ),
      onChanged: onChanged,
    );
  }
}
