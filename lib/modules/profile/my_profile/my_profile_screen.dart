import 'dart:convert';
import 'dart:io';
import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:http/http.dart' as http;
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/constants/triggering_condition.dart';
import 'package:bounz_revamp_app/models/city/city_model.dart';
import 'package:bounz_revamp_app/models/country/country_model.dart';
import 'package:bounz_revamp_app/models/employment/employment_model.dart';
import 'package:bounz_revamp_app/models/user/user_information.dart';
import 'package:bounz_revamp_app/modules/profile/my_profile/my_profile_model.dart';
import 'package:bounz_revamp_app/modules/profile/my_profile/my_profile_presenter.dart';
import 'package:bounz_revamp_app/modules/profile/my_profile/my_profile_view.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/utils/validator.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/widgets/city_picker_bottomsheet.dart';
import 'package:bounz_revamp_app/widgets/country_picker_bottomsheet.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moengage_flutter/model/gender.dart';
import 'package:moengage_flutter/properties.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';

@RoutePage()
class MyProfileScreen extends StatefulWidget {
  final bool fromSplash;
  const MyProfileScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  _MyProfileScreenState createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen>
    implements MyProfileView {
  final focusNode = FocusNode();
  String? gender;
  DateTime? dateTime;
  bool isUAE = true;
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController employmentController = TextEditingController();
  TextEditingController residentController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController bounzController = TextEditingController();
  TextEditingController selectCityController = TextEditingController();
  late UserInformation userInfo;
  int? cityId;
  File? selectedFile;
  final ImagePicker picker = ImagePicker();
  List<String?> images = <String>[];
  final formKey = GlobalKey<FormState>();

  Country? nationalityCountry;
  Country? residentCountry;
  Country? useBounzCountry;
  String? nationalityCountryImage;
  String? residentCountryImage;
  String? useBounzCountryImage;
  late MyProfileModel model;
  String? selectedEmploymentId;
  String? countyId;
  String? countyName;
  String? countryFlagUrl;
  final MyProfilePresenter presenter = BasicMyProfilePresenter();

  @override
  void initState() {
    super.initState();
    presenter.updateView = this;
    userInfo = GlobalSingleton.userInformation;
    gender = userInfo.gender;
    isUAE = userInfo.isUaeResident != 'false';
    firstNameController.text = userInfo.firstName ?? '';
    lastNameController.text = userInfo.lastName ?? '';
    emailController.text = userInfo.email ?? '';
    phoneController.text = userInfo.mobileNumber ?? '';
    dobController.text = userInfo.dob ?? '';
    model.disableEmail = userInfo.email == null ? false : true;
    if (userInfo.employmentType != null) {
      employmentController.text = userInfo.employmentType ?? '';
      selectedEmploymentId = userInfo.empCode;
    }
    if (userInfo.residentialCountry != null) {
      if (userInfo.residentialCountry!.isNotEmpty) {
        residentController.text = userInfo.residentialCountry![0].name ?? '';
      }
    }
    if (userInfo.nationality != null) {
      if (userInfo.nationality!.isNotEmpty) {
        nationalityController.text = userInfo.nationality![0].name ?? '';
      }
    }
    if (userInfo.cityName != null) {
      if (userInfo.cityName!.isNotEmpty) {
        cityId = userInfo.cityId;
        selectCityController.text = userInfo.cityName ?? '';
        isUAE = true;
      }
    }
    if (userInfo.countryFlag != null) {
      if (userInfo.countryFlag!.isNotEmpty) {
        countryFlagUrl = userInfo.countryFlag;
      }
    }

    if (StorageManager.getStringValue(AppStorageKey.storeResidentImage) !=
        null) {
      if (StorageManager.getStringValue(AppStorageKey.storeResidentImage)
              ?.isNotEmpty ==
          true) {
        residentCountryImage =
            StorageManager.getStringValue(AppStorageKey.storeResidentImage);
      }
    }
    if (StorageManager.getStringValue(AppStorageKey.storeNationalityImage) !=
        null) {
      if (StorageManager.getStringValue(AppStorageKey.storeNationalityImage)
              ?.isNotEmpty ==
          true) {
        nationalityCountryImage =
            StorageManager.getStringValue(AppStorageKey.storeNationalityImage);
      }
    }
    if (StorageManager.getStringValue(AppStorageKey.storeBounzImage) != null) {
      if (StorageManager.getStringValue(AppStorageKey.storeBounzImage)
              ?.isNotEmpty ==
          true) {
        useBounzCountryImage =
            StorageManager.getStringValue(AppStorageKey.storeBounzImage);
      }
    }
    getId(context);
  }

  void getId(BuildContext buildContext) async {
    List<Country> countryList =
        GlobalSingleton.countryList ?? await getCountryList(buildContext);
    http.Response data = await http.get(Uri.parse('http://ip-api.com/json'));
    Map countryData = jsonDecode(data.body);
    for (int i = 0; i < countryList.length; i++) {
      if (countryList[i].name == countryData['country']) {
        countyId = countryList[i].countryCode;
        countyName = countryList[i].name;
      }
    }
    bounzController.text = countyName ?? "United Arab Emirates";
  }

  @override
  void refreshModel(MyProfileModel myProfileModel) {
    setState(() {
      model = myProfileModel;
    });
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
    );
    if (picked != null && picked != dateTime) {
      setState(() {
        dateTime = picked;
        dobController.text = picked.dmyFormat;
      });
    }
  }

  Future<void> imageSelect(
      {required ImageSource source, required BuildContext context}) async {
    final XFile? image = await picker.pickImage(source: source).catchError((e) {
      return null;
    });
    if (image != null) {
      final CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        maxWidth: 1080,
        maxHeight: 1080,
      );
      if (croppedImage != null) {
        selectedFile = File(croppedImage.path);
      }
    }
    Navigator.pop(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (userInfo.nationality == null ||
            userInfo.nationality?.isEmpty == true ||
            userInfo.email == null ||
            userInfo.dob == null ||
            userInfo.gender == null) {
          completeProfileDialog(context);
          return false;
        } else {
          if (widget.fromSplash) {
            MoenageManager.logScreenEvent(name: 'Main Home');
            AutoRouter.of(context).pushAndPopUntil(
                MainHomeScreenRoute(isFirstLoad: true, index: 1),
                predicate: (_) => false);
          } else {
            AutoRouter.of(context).canPop();
          }
          return true;
        }
      },
      child: Scaffold(
        body: AppBackGroundWidget(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  if (userInfo.nationality == null ||
                      userInfo.email == null ||
                      userInfo.dob == null ||
                      userInfo.gender == null) {
                    completeProfileDialog(context);
                  } else {
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
              Text(
                AppConstString.myProfile,
                style: AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        profilePictureWidget(),
                        const SizedBox(
                          height: AppSizes.size30,
                        ),
                        nameWidget(),
                        const SizedBox(
                          height: AppSizes.size20,
                        ),
                        mobileWidget(),
                        const SizedBox(
                          height: AppSizes.size20,
                        ),
                        emailWidget(),
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
                        Text(
                          AppConstString.selectGender,
                          style: AppTextStyle.regular16,
                        ),
                        const SizedBox(
                          height: AppSizes.size12,
                        ),
                        selectGenderView(),
                        const SizedBox(
                          height: AppSizes.size20,
                        ),
                        employmentWidget(),
                        const SizedBox(
                          height: AppSizes.size22,
                        ),
                        radioButtonWidget(),
                        const SizedBox(
                          height: AppSizes.size16,
                        ),
                        isUAE ? cityWidget() : residentWidget(),
                        const SizedBox(
                          height: AppSizes.size20,
                        ),
                        bounzLocationCountryWidget(),
                        const SizedBox(
                          height: AppSizes.size20,
                        ),
                        /* residentController.text == "United Arab Emirates" ||
                                bounzController.text == "United Arab Emirates"
                            ? cityWidget()
                            : const SizedBox(),
                        residentController.text == "United Arab Emirates" ||
                                bounzController.text == "United Arab Emirates"
                            ? const SizedBox(
                                height: AppSizes.size20,
                              )
                            : const SizedBox(),*/
                        submitButton(),
                        const SizedBox(
                          height: AppSizes.size20,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget profilePictureWidget() {
    return InkWell(
      onTap: () {
        modalBottomSheetMenu(context);
      },
      child: Stack(
        children: [
          ClipOval(
            child: SizedBox(
              height: 70,
              width: 70,
              child: selectedFile != null
                  ? Image.file(
                      selectedFile!,
                      fit: BoxFit.cover,
                    )
                  : userInfo.image == null ||
                          GlobalSingleton.userInformation.image == "null"
                      ? GlobalSingleton.userInformation.gender == "male"
                          ? SvgPicture.asset(
                              AppAssets.men,
                            )
                          : SvgPicture.asset(
                              AppAssets.women,
                            )
                      : networkImage(
                          userInfo.image!,
                          fit: BoxFit.cover,
                        ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset(
              AppAssets.cameraNew,
            ),
          )
        ],
      ),
    );
  }

  Widget nameWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormFieldWidget(
            labelText: AppConstString.firstName,
            controller: firstNameController,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.deny(
                  RegExp("[\"?.0-9`;&!#\$%&*():<>^]"))
            ],
            validator: (value) => Validators.validateText(value, "First Name"),
          ),
        ),
        const SizedBox(
          width: AppSizes.size12,
        ),
        Expanded(
          child: TextFormFieldWidget(
            labelText: AppConstString.lastName,
            controller: lastNameController,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.deny(
                  RegExp("[\"?.0-9`;&!#\$%&*():<>^]"))
            ],
            validator: (value) => Validators.validateText(value, "Last Name"),
            focusNode: focusNode,
          ),
        ),
      ],
    );
  }

  Widget mobileWidget() {
    return Column(
      children: [
        NumberWidget(
          enabled: false,
          hintText: AppConstString.mobileNo,
          hintStyle: AppTextStyle.regular16,
          readOnly: model.disablePhone,
          prefixIconConstraints: BoxConstraints.loose(const Size(110, 50)),
          prefixIcon: GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    height: AppSizes.size16,
                    width: AppSizes.size16,
                    child: networkImage(countryFlagUrl ?? ""
                        /* StorageManager.getStringValue(
                              AppStorageKey.mobileNumberCountryImage)
                          .toString(),*/
                        ),
                  ),
                ),
                const SizedBox(
                  width: AppSizes.size4,
                ),
                Text(
                  "+${model.selectedCountry?.countryCode ?? userInfo.countryCode}",
                  style: AppTextStyle.semiBold16,
                ),
                const SizedBox(
                  width: AppSizes.size10,
                ),
                Container(
                  height: AppSizes.size20,
                  width: 1,
                  color: AppColors.whiteColor,
                ),
              ],
            ),
          ),
          suffixIcon: GestureDetector(
            onTap: () {
              /*FocusManager.instance.primaryFocus?.unfocus();
              if (model.disablePhone) {
                model.disablePhone = false;
              } else {
                widget.presenter.generateOtp(
                  context: context,
                  data: {
                    'country_code': model.selectedCountry?.countryCode ?? '971',
                    'phone': phoneController.text,
                  },
                );
              }
              setState(() {});*/
            },
            child: Padding(
              padding: const EdgeInsets.only(
                right: AppSizes.size16,
              ),
              child: Image.asset(AppAssets.greenTick),
              // child: Text(
              //   model.disablePhone ? AppConstString.change : 'OTP',
              //   style: AppTextStyle.bold12.copyWith(
              //     decoration: TextDecoration.underline,
              //     fontFamily: "Gilroy",
              //   ),
              // ),
            ),
          ),
          controller: phoneController,
          maxLength: model.selectedCountry?.mobileNumberLength ?? 9,
          validator: (value) => Validators.validateMobile(value),
        ),
        /*if (GlobalSingleton.userInformation.phoneVerified == 'YES')
          Padding(
            padding: const EdgeInsets.only(top: 8, right: AppSizes.size16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Image.asset(AppAssets.greenTick),
                Text(
                  'Number Verified',
                  style: AppTextStyle.regular16,
                ),
              ],
            ),
          ),*/
      ],
    );
  }

  Widget emailWidget() {
    return Column(
      children: [
        EmailWidget(
          labelText: 'Enter Email ID*',
          controller: emailController,
          readOnly: model.disableEmail,
          suffixIcon: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (model.disableEmail) {
                setState(() {
                  model.disableEmail = false;
                });
              } else {
                presenter.generateOtp(
                  context: context,
                  data: {
                    "type": "email",
                    "email": emailController.text.trim(),
                    "membership_no":
                        GlobalSingleton.userInformation.membershipNo,
                  },
                );
              }
            },
            child: Padding(
              padding: const EdgeInsets.only(
                top: AppSizes.size18,
                right: AppSizes.size16,
              ),
              child: Text(
                model.disableEmail ? AppConstString.change : 'OTP',
                style: AppTextStyle.bold12.copyWith(
                  decoration: TextDecoration.underline,
                  fontFamily: "Gilroy",
                ),
              ),
            ),
          ),
        ),
        if (GlobalSingleton.userInformation.emailVerified == 'YES' &&
            model.disableEmail)
          Padding(
            padding: const EdgeInsets.only(top: 8, right: AppSizes.size16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Image.asset(AppAssets.greenTick),
                Text(
                  'Email Verified',
                  style: AppTextStyle.regular16,
                ),
              ],
            ),
          ),
      ],
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
                gender = 'male';
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
                    gender == 'male' ? checkIcon() : const SizedBox(),
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
                gender = 'female';
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
                    gender == 'female' ? checkIcon() : const SizedBox(),
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

  Widget employmentWidget() {
    return TextFormFieldWidget(
      controller: employmentController,
      readOnly: true,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showEmploymentPicker(
          text: "Select your Employment Type",
          buildContext: context,
          onSelect: (employment) {
            selectedEmploymentId = employment.id.toString();
            employmentController.text = employment.name ?? '';
            setState(() {});
          },
        );
      },
      labelText: AppConstString.empType,
      suffixIconConstraints: BoxConstraints.loose(
        const Size(50, 50),
      ),
      suffixIcon: const Center(
        child: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: AppColors.whiteColor,
          size: 24.0,
        ),
      ),
    );
  }

  Widget radioButtonWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Text(
            AppConstString.radioText,
            style: AppTextStyle.regular16,
          ),
        ),
        Row(
          children: [
            Radio(
              value: true,
              groupValue: isUAE,
              fillColor: MaterialStateColor.resolveWith(
                (states) => AppColors.whiteColor,
              ),
              onChanged: (val) {
                setState(() {
                  isUAE = true;
                });
              },
            ),
            Text(
              AppConstString.yes,
              style: AppTextStyle.regular16,
            ),
            Radio(
              value: false,
              groupValue: isUAE,
              fillColor: MaterialStateColor.resolveWith(
                (states) => AppColors.whiteColor,
              ),
              onChanged: (val) {
                setState(() {
                  isUAE = false;
                });
              },
            ),
            Text(
              AppConstString.no,
              style: AppTextStyle.regular16,
            ),
          ],
        ),
      ],
    );
  }

  Widget residentWidget() {
    return TextFormFieldWidget(
      controller: residentController,
      readOnly: true,
      prefixIconConstraints: residentCountryImage == null
          ? null
          : BoxConstraints.loose(const Size(70, 50)),
      prefixIcon: residentCountryImage == null
          ? null
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    height: AppSizes.size16,
                    width: AppSizes.size16,
                    child: networkImage(
                      residentCountryImage ?? "",
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppSizes.size10,
                ),
                Container(
                  height: AppSizes.size20,
                  width: 1,
                  color: AppColors.whiteColor,
                ),
              ],
            ),
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showCountryPicker(
          text: "Select Your Resident Country",
          buildContext: context,
          onSelect: (country) {
            residentCountry = country;
            residentController.text = country.name ?? '';
            country.name == "United Arab Emirates"
                ? isUAE = true
                : isUAE = false;
            residentCountryImage = country.image;
            setState(() {});
          },
        );
      },
      labelText: AppConstString.resiCountry,
      suffixIconConstraints: BoxConstraints.loose(
        const Size(50, 50),
      ),
      suffixIcon: const Center(
        child: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: AppColors.whiteColor,
          size: 24.0,
        ),
      ),
    );
  }

  Widget nationalityWidget() {
    return TextFormFieldWidget(
      controller: nationalityController,
      readOnly: true,
      prefixIconConstraints: nationalityCountryImage == null
          ? null
          : BoxConstraints.loose(const Size(70, 50)),
      prefixIcon: nationalityCountryImage == null
          ? null
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    height: AppSizes.size20,
                    width: AppSizes.size20,
                    child: networkImage(
                      nationalityCountryImage ?? "",
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppSizes.size16,
                ),
                Container(
                  height: AppSizes.size20,
                  width: 1,
                  color: AppColors.whiteColor,
                ),
              ],
            ),
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showCountryPicker(
          text: "Select Your Nationality",
          buildContext: context,
          onSelect: (country) {
            nationalityCountry = country;
            nationalityController.text = country.name ?? '';
            nationalityCountryImage = country.image;
            final properties = MoEProperties();
            properties
                .addAttribute(
                    TriggeringCondition.selectedLocation, country.name ?? '')
                .addAttribute(TriggeringCondition.screenName, 'My Profile')
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.locationSelected,
              properties: properties,
            );
            setState(() {});
          },
        );
      },
      validator: (value) => Validators.validateText(value, "Nationality"),
      labelText: AppConstString.nationality + '*',
      suffixIconConstraints: BoxConstraints.loose(
        const Size(50, 50),
      ),
      suffixIcon: const Center(
        child: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: AppColors.whiteColor,
          size: 24.0,
        ),
      ),
    );
  }

  Widget bounzLocationCountryWidget() {
    return TextFormFieldWidget(
      controller: bounzController,
      readOnly: true,
      prefixIconConstraints: useBounzCountryImage == null
          ? null
          : BoxConstraints.loose(const Size(70, 50)),
      prefixIcon: useBounzCountryImage == null
          ? null
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: SizedBox(
                    height: AppSizes.size20,
                    width: AppSizes.size20,
                    child: networkImage(
                      useBounzCountryImage ?? "",
                    ),
                  ),
                ),
                const SizedBox(
                  width: AppSizes.size16,
                ),
                Container(
                  height: AppSizes.size20,
                  width: 1,
                  color: AppColors.whiteColor,
                ),
              ],
            ),
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        showCountryPicker(
          text: "Select your Bounz",
          buildContext: context,
          onSelect: (country) {
            useBounzCountry = country;
            bounzController.text = country.name ?? '';
            useBounzCountryImage = country.image;
            setState(() {});
          },
        );
      },
      labelText: AppConstString.bounzLocation,
      suffixIconConstraints: BoxConstraints.loose(
        const Size(50, 50),
      ),
      suffixIcon: const Center(
        child: Icon(
          Icons.keyboard_arrow_down_outlined,
          color: AppColors.whiteColor,
          size: 24.0,
        ),
      ),
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
          onSelect: (City city) {
            cityId = city.id;
            selectCityController.text = city.cityName ?? '';
            setState(() {});
          },
        );
      },
    );
  }

  Widget submitButton() {
    return Center(
      child: PrimaryButton(
        onTap: () async {
          if (formKey.currentState!.validate()) {
            if (gender == null) {
              completeProfileDialog(context);
              return;
            }
            if (GlobalSingleton.userInformation.email !=
                emailController.text.trim()) {
              NetworkDio.showError(
                title: AppConstString.errorField,
                context: context,
                errorMessage: AppConstString.verifyEmailMessage,
              );
              return;
            }
            Map<String, dynamic> data = {
              "first_name": firstNameController.text.trim(),
              "last_name": lastNameController.text.trim(),
              "dob": dobController.text,
              "is_uae_resident": isUAE,
              "gender": gender,
              "nationality": nationalityCountry != null
                  ? nationalityCountry!.id.toString()
                  : userInfo.nationality!.isNotEmpty
                      ? userInfo.nationality![0].id
                      : 0,
              "residential_country": residentCountry != null
                  ? residentCountry!.id.toString()
                  : userInfo.residentialCountry!.isNotEmpty
                      ? userInfo.residentialCountry![0].id
                      : 0,
              'city_name': isUAE ? selectCityController.text : "",
              "city_id": isUAE ? cityId : 0,
              "user_agent": "mobile",
              "current_country": countyId,
              "membership_no": GlobalSingleton.userInformation.membershipNo,
            };
            if (selectedFile != null) {
              List<int> imageBytes = selectedFile!.readAsBytesSync();
              data["profile_image"] = base64Encode(imageBytes);
              data["image_extension"] = selectedFile!.path.split(".").last;
            }
            if (model.updatedPhone) {
              data["phone"] = phoneController.text.trim();
              data["country_code"] = model.selectedCountry?.countryCode ??
                  userInfo.countryCode ??
                  '971';
            }
            if (selectedEmploymentId != "null") {
              data["employment_type"] = selectedEmploymentId;
            }
            if (residentCountryImage != null) {
              StorageManager.setStringValue(
                  key: AppStorageKey.storeResidentImage,
                  value: residentCountryImage ?? '');
            }
            if (nationalityCountryImage != null) {
              StorageManager.setStringValue(
                  key: AppStorageKey.storeNationalityImage,
                  value: nationalityCountryImage ?? '');
            }
            if (useBounzCountryImage != null) {
              StorageManager.setStringValue(
                  key: AppStorageKey.storeBounzImage,
                  value: useBounzCountryImage ?? '');
            }
            await presenter.updateProfile(
              data: data,
              context: context,
              isFromSplash: widget.fromSplash,
            );
            final properties = MoEProperties();
            properties
                .addAttribute(TriggeringCondition.screenName, "MyProfile")
                .addAttribute(TriggeringCondition.firstName, data['first_name'])
                .addAttribute(TriggeringCondition.lastName, data['last_name'])
                .addAttribute(
                    TriggeringCondition.email, emailController.text.trim())
                .addAttribute(
                    TriggeringCondition.dob, dobController.text.trim())
                .addAttribute(
                    TriggeringCondition.residentCountry,
                    isUAE
                        ? "United Arab Emirates"
                        : residentController.text.trim())
                .addAttribute(TriggeringCondition.city,
                    isUAE ? selectCityController.text.trim() : "")
                .addAttribute(TriggeringCondition.gender, data['gender'])
                .addAttribute(TriggeringCondition.mobileNumber,
                    "${userInfo.countryCode}${userInfo.mobileNumber}")
                .setNonInteractiveEvent();
            MoenageManager.logEvent(
              MoenageEvent.myprofileUpdate,
              properties: properties,
            );
            updateMoEngage(
                data['gender'] == 'male' ? MoEGender.male : MoEGender.female);
          }
        },
        text: 'Submit',
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
                        child: ListView.separated(
                          itemCount: searchCountry.length,
                          padding: const EdgeInsets.only(
                            top: AppSizes.size10,
                          ),
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) {
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
                                        searchCountry[index].image ?? '',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: AppSizes.size16,
                                  ),
                                  Flexible(
                                    child: Text(
                                      searchCountry[index].name ?? '',
                                      style: AppTextStyle.semiBold16.copyWith(
                                          color: AppColors.blackColor),
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
                        ),
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

  void showEmploymentPicker({
    required String text,
    required BuildContext buildContext,
    required Function(EmploymentModel country) onSelect,
  }) async {
    List<EmploymentModel> getEmploymentList =
        GlobalSingleton.employmentTypeList ??
            await getEmploymentTypeList(buildContext);
    List<EmploymentModel> searchEmployment = getEmploymentList;
    List<EmploymentModel> search(String query) {
      return getEmploymentList
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
                            searchEmployment = search(value);
                          } else if (value!.isEmpty) {
                            searchEmployment = getEmploymentList;
                          } else {
                            searchEmployment = getEmploymentList;
                          }
                          stx(() {});
                        },
                      ),
                      const SizedBox(
                        height: AppSizes.size10,
                      ),
                      Expanded(
                        child: ListView.separated(
                          itemCount: searchEmployment.length,
                          padding: const EdgeInsets.only(
                            top: AppSizes.size10,
                          ),
                          physics: const BouncingScrollPhysics(),
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              height: AppSizes.size20,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              child: Row(
                                children: [
                                  Text(
                                    searchEmployment[index].name ?? '',
                                    style: AppTextStyle.semiBold16.copyWith(
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                onSelect(searchEmployment[index]);
                                Navigator.of(context).pop();
                              },
                            );
                          },
                        ),
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

  void modalBottomSheetMenu(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext builder) {
          return Container(
            height: 200,
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.primaryContainerColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  imagePickerDecoration(
                      type: 'Camera',
                      onTap: () async {
                        final PermissionStatus status =
                            await Permission.camera.request();
                        if (status.isDenied || status.isPermanentlyDenied) {
                          await openAppSettings();
                        } else {
                          await imageSelect(
                            source: ImageSource.camera,
                            context: builder,
                          );
                        }
                      }),
                  Container(
                    height: 125,
                    margin: const EdgeInsets.all(20),
                    width: 1,
                    color: AppColors.blackColor,
                  ),
                  imagePickerDecoration(
                      type: 'Gallery',
                      onTap: () async {
                        final PermissionStatus status = Platform.isAndroid
                            ? await Permission.mediaLibrary.request()
                            : await Permission.photos.request();
                        if (status.isDenied || status.isPermanentlyDenied) {
                          await openAppSettings();
                        } else {
                          await imageSelect(
                            source: ImageSource.gallery,
                            context: builder,
                          );
                        }
                      }),
                ],
              ),
            ),
          );
        });
  }

  Widget imagePickerDecoration({
    required String type,
    required Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      // splashColor: primary,
      // hoverColor: primary,
      // highlightColor: primary,
      // focusColor: primary,
      child: Container(
        height: 110,
        width: 110,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(
              type == 'Gallery'
                  ? Icons.photo_library_outlined
                  : Icons.add_a_photo_rounded,
              color: AppColors.whiteColor,
            ),
            const SizedBox(
              height: AppSizes.size16,
            ),
            Text(
              type,
              style: AppTextStyle.black16,
            ),
          ],
        ),
      ),
    );
  }

  void updateMoEngage(gender) {
    UserInformation userInfo = GlobalSingleton.userInformation;

    MoenageManager.moengagePlugin
        .setUniqueId(GlobalSingleton.userInformation.membershipNo!);
    MoenageManager.moengagePlugin.setFirstName(userInfo.firstName ?? '');
    MoenageManager.moengagePlugin.setLastName(userInfo.lastName ?? '');
    MoenageManager.moengagePlugin.setEmail(userInfo.email ?? '');
    MoenageManager.moengagePlugin.setBirthDate(userInfo.dob ?? '');
    MoenageManager.moengagePlugin.setPhoneNumber(
        "${userInfo.countryCode ?? ''}${userInfo.mobileNumber ?? ''}");
    MoenageManager.moengagePlugin.setGender(gender);
    MoenageManager.moengagePlugin.setUserName(
        (userInfo.firstName ?? '') + ' ' + (userInfo.lastName ?? ''));
  }

  Future completeProfileDialog(BuildContext context) {
    return showModalBottomSheet(
      backgroundColor: AppColors.secondaryContainerColor,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
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
            height: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Oh oh! Looks like you have some fields pending. Complete your profile to proceed.',
                  style: AppTextStyle.bold16
                      .copyWith(color: AppColors.darkBlueTextColor),
                ),
                const SizedBox(
                  height: AppSizes.size30,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
