import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/shrimmer_widet.dart';
import 'package:flutter/material.dart';

class ShrimmerOfferDetailScreen extends StatelessWidget {
  const ShrimmerOfferDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 222,
          alignment: Alignment.topLeft,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSizes.size30),
            ),
          ),
          child: CustomShrimmerWidget.rectangular(
            height: 222,
            width: MediaQuery.of(context).size.width,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: AppColors.backgroundColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(AppSizes.size36),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.size20,
              vertical: AppSizes.size20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomShrimmerWidget.rectangular(
                      height: 16,
                      width: MediaQuery.of(context).size.width * .5,
                    ),
                    const Spacer(),
                    const CustomShrimmerWidget.circular(
                      height: 16,
                      width: 16,
                    ),
                    const SizedBox(
                      width: AppSizes.size12,
                    ),
                    const CustomShrimmerWidget.circular(
                      height: 16,
                      width: 16,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                CustomShrimmerWidget.rectangular(
                  height: 12,
                  width: MediaQuery.of(context).size.width * .8,
                ),
                const SizedBox(
                  height: 5,
                ),
                const Divider(
                  height: 8,
                  thickness: 0.3,
                  color: AppColors.whiteColor,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const CustomShrimmerWidget.circular(
                      height: 16,
                      width: 16,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    CustomShrimmerWidget.rectangular(
                      height: 12,
                      width: MediaQuery.of(context).size.width * .3,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: AppSizes.size20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.size20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomShrimmerWidget.rectangular(
                height: 18,
                width: 40,
              ),
              const SizedBox(
                height: AppSizes.size12,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShrimmerWidget.rectangular(
                    height: 16,
                    width: MediaQuery.of(context).size.width * .2,
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.size16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShrimmerWidget.rectangular(
                    height: 10,
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(
                    height: AppSizes.size6,
                  ),
                  CustomShrimmerWidget.rectangular(
                    height: 10,
                    width: MediaQuery.of(context).size.width * .7,
                  ),
                  const SizedBox(
                    height: AppSizes.size6,
                  ),
                  CustomShrimmerWidget.rectangular(
                    height: 10,
                    width: MediaQuery.of(context).size.width * .8,
                  ),
                  const SizedBox(
                    height: AppSizes.size6,
                  ),
                  CustomShrimmerWidget.rectangular(
                    height: 10,
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(
                    height: AppSizes.size6,
                  ),
                  CustomShrimmerWidget.rectangular(
                    height: 10,
                    width: MediaQuery.of(context).size.width * .3,
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShrimmerWidget.rectangular(
                    height: 16,
                    width: MediaQuery.of(context).size.width * .2,
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.size16,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomShrimmerWidget.rectangular(
                    height: 10,
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(
                    height: AppSizes.size6,
                  ),
                  CustomShrimmerWidget.rectangular(
                    height: 10,
                    width: MediaQuery.of(context).size.width * .7,
                  ),
                  const SizedBox(
                    height: AppSizes.size6,
                  ),
                  CustomShrimmerWidget.rectangular(
                    height: 10,
                    width: MediaQuery.of(context).size.width * .8,
                  ),
                  const SizedBox(
                    height: AppSizes.size6,
                  ),
                  CustomShrimmerWidget.rectangular(
                    height: 10,
                    width: MediaQuery.of(context).size.width,
                  ),
                  const SizedBox(
                    height: AppSizes.size6,
                  ),
                  CustomShrimmerWidget.rectangular(
                    height: 10,
                    width: MediaQuery.of(context).size.width * .3,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
