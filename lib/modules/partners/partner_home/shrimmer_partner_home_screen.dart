import 'package:flutter/material.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/shrimmer_widet.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';

class ShrimmerPartnerHomeScreenView extends StatelessWidget {
  const ShrimmerPartnerHomeScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 5),
      alignment: Alignment.topCenter,
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: AppSizes.size12,
        crossAxisSpacing: AppSizes.size12,
        childAspectRatio:
            GlobalSingleton.osType == "ios" ? 2.7 / 3.5 : 2.6 / 3.7,
        physics: const BouncingScrollPhysics(),
        children: List.generate(
          10,
          (index) {
            return Padding(
              padding: const EdgeInsets.only(left: 8),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.size20),
                child: CustomShrimmerWidget.rectangular(
                  height: 150,
                  width: MediaQuery.of(context).size.width * .39,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
