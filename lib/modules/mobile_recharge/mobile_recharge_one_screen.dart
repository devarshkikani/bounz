import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bounz_revamp_app/widgets/input_text_field.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/models/country/country_model.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/models/pay_bills/service_model.dart';
import 'package:bounz_revamp_app/widgets/country_picker_bottomsheet.dart';

@RoutePage()
class MobileRechargeOneScreen extends StatefulWidget {
  final ServiceModel serviceModel;
  final String country;
  const MobileRechargeOneScreen(
      {Key? key, required this.serviceModel, required this.country})
      : super(key: key);

  @override
  State<MobileRechargeOneScreen> createState() =>
      _MobileRechargeOneScreenState();
}

class _MobileRechargeOneScreenState extends State<MobileRechargeOneScreen> {
  List<String> stringList = ["DU", "Etisalat"];
  final mobileController = TextEditingController();
  int selectedIndex = -1;
  bool isButtonEnabled = false;

  void _onItemSelected(int index) {
    setState(() {
      selectedIndex = index;
      isButtonEnabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AppBackGroundWidget(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 70,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Icon(
                              Icons.arrow_back,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: AppSizes.size14,
                        ),
                        Text(
                          AppConstString.mobileRecharge.toUpperCase(),
                          style: AppTextStyle.regular36
                              .copyWith(fontFamily: "Bebas"),
                        ),
                        const SizedBox(
                          height: AppSizes.size30,
                        ),
                        Text(
                          AppConstString.selectOperator,
                          textAlign: TextAlign.center,
                          style: AppTextStyle.bold16,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: AppSizes.size20,
                    ),
                    Wrap(
                      spacing: AppSizes.size14,
                      children: List.generate(
                        stringList.length,
                        (index) {
                          return GestureDetector(
                            onTap: () {
                              _onItemSelected(index);
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 60,
                                  width: 60,
                                  padding: const EdgeInsets.all(AppSizes.size6),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(AppSizes.size6),
                                    shape: BoxShape.rectangle,
                                    color: AppColors.whiteColor,
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(AppSizes.size6),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPLKNKtqYzPxMpUiJ4k3ai3Q2WyW9cVt-bnG2AbR0sRw&s',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: AppSizes.size1,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: AppSizes.size8),
                                  child: SizedBox(
                                    width: 72,
                                    child: Text(
                                      stringList[index],
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyle.regular12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: AppSizes.size20,
                    ),
                    Text(
                      AppConstString.enterMobileNumber,
                      style: AppTextStyle.bold16,
                    ),
                    const SizedBox(
                      height: AppSizes.size16,
                    ),
                    mobileNumberInput(),
                    //Spacer(),
                  ],
                ),
              ),
            ),
            Center(
              child: PrimaryButton(
                onTap: isButtonEnabled
                    ? () {
                        planDetailsBottomSheet(context);
                        // handle button press
                      }
                    : null,
                text: AppConstString.selectPlans,
                showShadow: true,
                // width: 100.0,
                height: 60.0, tColor: AppColors.whiteColor,
              ),
            ),
            const SizedBox(
              height: AppSizes.size30,
            ),
          ],
        ),
      ),
    );
  }

  Future planDetailsBottomSheet(BuildContext buildContext) {
    return showModalBottomSheet(
      backgroundColor: AppColors.secondaryContainerColor,
      context: buildContext,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: AppSizes.size20,
            right: AppSizes.size20,
            left: AppSizes.size20,
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: GestureDetector(
            onTap: () {},
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.9,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppConstString.planDetails,
                    style: AppTextStyle.bold16.copyWith(
                      color: AppColors.blackColor,
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: 10,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: AppSizes.size40,
                                  width: AppSizes.size40,
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(AppSizes.size6),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSPLKNKtqYzPxMpUiJ4k3ai3Q2WyW9cVt-bnG2AbR0sRw&s',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: AppSizes.size16,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppConstString.unitedArabEmirates,
                                      style: AppTextStyle.semiBold14.copyWith(
                                          color: AppColors
                                              .secondaryBackgroundColor),
                                    ),
                                    const SizedBox(
                                      height: AppSizes.size6,
                                    ),
                                    Text(
                                      AppConstString.dataValidity,
                                      style: AppTextStyle.regular12.copyWith(
                                          color: AppColors
                                              .secondaryBackgroundColor
                                              .withOpacity(0.8)),
                                    ),
                                    const SizedBox(
                                      height: AppSizes.size6,
                                    ),
                                    Text(
                                      AppConstString.aed25,
                                      style: AppTextStyle.bold14.copyWith(
                                          color: AppColors
                                              .secondaryBackgroundColor),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width / 3.8,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(top: AppSizes.size4),
                                  child: Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: AppSizes.size14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: AppSizes.size20),
                          child: HorizontalDottedLine(
                            height: 1.5,
                            color: AppColors.blackColor.withOpacity(0.2),
                            width:
                                MediaQuery.of(context).size.width, // optional
                          ),
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
  }
  //

  Widget mobileNumberInput() {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(right: AppSizes.size10),
      child: NumberWidget(
        contentPadding: const EdgeInsets.all(AppSizes.size10),
        hintText: AppConstString.mobileNo,
        hintStyle: AppTextStyle.regular16,
        suffixIcon: const Icon(
          Icons.contact_mail_sharp,
          color: AppColors.whiteColor,
        ),
        keyboardType: TextInputType.number,
        prefixIconConstraints: BoxConstraints.loose(const Size(110, 50)),
        prefixIcon: GestureDetector(
          onTap: () {
            countryPickerBottomsheet(
              buildContext: context,
              location: false,
              text: "Enter Your Country Code",
              passValue: (Country country) {},
            );
          },
          child: Padding(
            padding: const EdgeInsets.only(left: 10, bottom: 3.0),
            child: Row(
              children: [
                SizedBox(
                  height: AppSizes.size16,
                  child: Image.asset(AppAssets.indiaFlag, fit: BoxFit.fill),
                ),
                const SizedBox(
                  width: AppSizes.size8,
                ),
                Text(
                  AppConstString.countryCode91,
                  style: AppTextStyle.semiBold16,
                ),
                const Icon(
                  Icons.arrow_drop_down_sharp,
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
        ),
      ),
    );
  }
}

class HorizontalDottedLine extends StatelessWidget {
  final double? width;
  final double height;
  final Color color;

  const HorizontalDottedLine({
    Key? key,
    this.width,
    required this.height,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = width ?? constraints.constrainWidth();
        double dashWidth = 5.0;
        double dashSpace = 5.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: height,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
