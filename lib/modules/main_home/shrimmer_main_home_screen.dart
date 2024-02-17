import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/shrimmer_widet.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';

class ShrimmerMainHome extends StatelessWidget {
  const ShrimmerMainHome({super.key});
  final Color footerBgColor = AppColors.darkOrangeColor;
  final Color footerHoverBgColor = AppColors.whiteColor;
  final Color footerHoverColor = AppColors.whiteColor;
  final Color footerTextColor = AppColors.whiteColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          Container(
            height: 220 + MediaQuery.of(context).viewPadding.top,
            decoration: const BoxDecoration(
              color: AppColors.darkOrangeColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(AppSizes.size40),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  appbarView(),
                  const SizedBox(
                    height: 26.0,
                  ),
                  totalBounzPointsWidget(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: AppSizes.size20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSizes.size12),
              child: CustomShrimmerWidget.rectangular(
                height: 120,
                width: MediaQuery.of(context).size.width,
              ),
            ),
          ),
          const SizedBox(
            height: AppSizes.size10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (index) {
                return const CustomShrimmerWidget.circular(
                  height: AppSizes.size10,
                  width: AppSizes.size10,
                );
              },
            ),
          ),
          const SizedBox(
            height: AppSizes.size10,
          ),
          const Padding(
            padding: EdgeInsets.only(left: AppSizes.size20),
            child: Row(
              children: [
                CustomShrimmerWidget.rectangular(
                  height: AppSizes.size20,
                  width: 100,
                ),
                Spacer(),
                CustomShrimmerWidget.rectangular(
                  height: AppSizes.size10,
                  width: 100,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: AppSizes.size20,
          ),
          SizedBox(
            height: 150,
            child: Padding(
              padding: const EdgeInsets.only(left: AppSizes.size20),
              child: ListView(
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                children: List.generate(
                  4,
                  (index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: AppSizes.size20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.size20),
                        child: CustomShrimmerWidget.rectangular(
                          height: 150,
                          width: MediaQuery.of(context).size.width / 4,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        color: footerBgColor,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            5,
            (index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const CustomShrimmerWidget.circular(
                    height: 30,
                    width: 30,
                  ),
                  const SizedBox(
                    height: AppSizes.size10,
                  ),
                  CustomShrimmerWidget.rectangular(
                    height: 10,
                    width: MediaQuery.of(context).size.width / 6,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget appbarView() {
    return const SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          AppSizes.size20,
          AppSizes.size20,
          AppSizes.size20,
          0,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  CustomShrimmerWidget.circular(
                    height: 40,
                    width: 40,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomShrimmerWidget.circular(
                    height: 40,
                    width: 40,
                  ),
                  SizedBox(
                    width: AppSizes.size10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomShrimmerWidget.rectangular(
                        height: 10,
                        width: 40,
                      ),
                      SizedBox(
                        height: AppSizes.size6,
                      ),
                      CustomShrimmerWidget.rectangular(
                        height: 10,
                        width: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomShrimmerWidget.circular(
                    height: 40,
                    width: 40,
                  ),
                  SizedBox(
                    width: AppSizes.size10,
                  ),
                  CustomShrimmerWidget.circular(
                    height: 40,
                    width: 40,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget totalBounzPointsWidget() {
    return Container(
      height: 90,
      // width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
      decoration: BoxDecoration(
        color: AppColors.secondaryContainerColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 30,
            color: const Color(0xff8b6969).withOpacity(.8),
            offset: const Offset(10, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(
            height: AppSizes.size20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShrimmerWidget.rectangular(
                    height: 10,
                    width: AppSizes.size70,
                  ),
                  SizedBox(
                    height: 6,
                  ),
                  CustomShrimmerWidget.rectangular(
                    height: 20,
                    width: AppSizes.size80,
                  ),
                ],
              ),
              Container(
                width: 0.5,
                margin: const EdgeInsets.symmetric(horizontal: AppSizes.size30),
                height: AppSizes.size36,
                color: AppColors.btnBlueColor,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomShrimmerWidget.rectangular(
                        height: 10,
                        width: 100,
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      CustomShrimmerWidget.rectangular(
                        height: 20,
                        width: 120,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: AppSizes.size12,
          ),
        ],
      ),
    );
  }
}
