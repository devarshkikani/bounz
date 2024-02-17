import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/shrimmer_widet.dart';

class ShrimmerOffersHomeScreenView extends StatelessWidget {
  const ShrimmerOffersHomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: 10,
      padding: const EdgeInsets.only(
        left: AppSizes.size8,
        bottom: AppSizes.size20,
        top: AppSizes.size10,
      ),
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: const BouncingScrollPhysics(),
      separatorBuilder: (context, index) {
        return const SizedBox(
          height: AppSizes.size20,
        );
      },
      itemBuilder: (BuildContext context, int index) => ClipRRect(
        borderRadius: BorderRadius.circular(AppSizes.size20),
        child: CustomShrimmerWidget.rectangular(
          height: 180,
          width: MediaQuery.of(context).size.width,
        ),
      ),
    );
  }
}
