import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/shrimmer_widet.dart';
import 'package:flutter/material.dart';

class ShrimmerGiftCardDetails extends StatelessWidget {
  const ShrimmerGiftCardDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CustomShrimmerWidget.circular(
          height: 20,
          width: 20,
        ),
        const SizedBox(
          height: AppSizes.size30,
        ),
        CustomShrimmerWidget.rectangular(
          height: 36,
          width: MediaQuery.of(context).size.width * .7,
        ),
        const SizedBox(
          height: AppSizes.size20,
        ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.size10),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: CustomShrimmerWidget.rectangular(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
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
                    width: MediaQuery.of(context).size.width * .7,
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
                    width: MediaQuery.of(context).size.width * .5,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomShrimmerWidget.rectangular(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .2,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomShrimmerWidget.rectangular(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .2,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomShrimmerWidget.rectangular(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .2,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomShrimmerWidget.rectangular(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .2,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: AppSizes.size20,
              ),
              Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CustomShrimmerWidget.rectangular(
                      height: 50,
                      width: MediaQuery.of(context).size.width * .4,
                    ),
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
