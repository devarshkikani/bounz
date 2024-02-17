import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:flutter/material.dart';

class FilterBottomSheet {
  static Future<dynamic> filtereBottomSheet({
    required BuildContext context,
    required int currentIndex,
    required Function(int index, Map<String, dynamic> name) doneOnTap,
  }) {
    List<Map<String, dynamic>> monthList = getMonthsInYear();

    return showModalBottomSheet(
        backgroundColor: AppColors.secondaryContainerColor,
        shape: const OutlineInputBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(AppSizes.size20),
            topRight: Radius.circular(20),
          ),
        ),
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.only(
                  left: AppSizes.size20,
                  top: AppSizes.size26,
                  bottom: AppSizes.size36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Transaction Period",
                    style: AppTextStyle.bold16
                        .copyWith(color: AppColors.blackColor),
                  ),
                  const SizedBox(height: AppSizes.size18),
                  SizedBox(
                    height: AppSizes.size48,
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: monthList.length,
                      padding: const EdgeInsets.only(right: AppSizes.size20),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            currentIndex = index;
                            setState(() {});
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.size10),
                            decoration: BoxDecoration(
                              color: currentIndex == index
                                  ? AppColors.backgroundColor
                                  : Colors.transparent,
                              border: Border.all(
                                color:
                                    const Color(0xff1C2934).withOpacity(0.80),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(AppSizes.size12),
                              ),
                            ),
                            child: Text(
                              index == 0
                                  ? 'This Month'
                                  : monthList[index]['title'],
                              style: AppTextStyle.semiBold14.copyWith(
                                color: currentIndex == index
                                    ? AppColors.whiteColor
                                    : AppColors.darkBlueTextColor,
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const SizedBox(width: AppSizes.size12);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size42,
                  ),
                  Center(
                    child: PrimaryButton(
                      text: "Done",
                      tColor: AppColors.whiteColor,
                      bColor: AppColors.btnBlueColor,
                      height: AppSizes.size60,
                      onTap: () {
                        doneOnTap(currentIndex, monthList[currentIndex]);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            );
          });
        });
  }
}
