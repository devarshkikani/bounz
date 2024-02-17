import 'package:bounz_revamp_app/config/manager/storage_manager.dart';
import 'package:bounz_revamp_app/constants/app_storage_key.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/network_image_widget.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';

@RoutePage()
class RedeemedOfferDetailsScreen extends StatefulWidget {
  const RedeemedOfferDetailsScreen({super.key});

  @override
  State<RedeemedOfferDetailsScreen> createState() =>
      _RedeemedOfferDetailsScreenState();
}

class _RedeemedOfferDetailsScreenState
    extends State<RedeemedOfferDetailsScreen> {
  String outletImgUrl = "";
  String outletDec = "";
  String outletName = "";

  @override
  void initState() {
    super.initState();
    outletImgUrl =
        StorageManager.getStringValue(AppStorageKey.outletImgOfferRedeem)!;
    outletDec =
        StorageManager.getStringValue(AppStorageKey.outletDecOfferRedeem)!;
    outletName =
        StorageManager.getStringValue(AppStorageKey.outletNameOfferRedeem)!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
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
              outletName,
              style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
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
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: const Color(0xff000029).withOpacity(0.1),
                      ),
                      child: networkImage(outletImgUrl, fit: BoxFit.fill),
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  if (outletDec != "") ...[
                    Text(
                      "Description",
                      style: AppTextStyle.bold16,
                    ),
                    const SizedBox(
                      height: AppSizes.size16,
                    ),
                    Text(
                      outletDec,
                      style: AppTextStyle.semiBold14,
                    ),
                    const SizedBox(
                      height: AppSizes.size20,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
