import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:bounz_revamp_app/widgets/my_behavior.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:bounz_revamp_app/utils/progress_indicator.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/utils/network/network_dio.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/models/partner_coupon/partner_coupon.dart';
import 'package:bounz_revamp_app/utils/extensions/date_time_extension.dart';

import '../../../constants/app_const_text.dart';

@RoutePage()
class VoucherDetailsScreen extends StatefulWidget {
  final PartnerCouponList partnerCoupon;
  const VoucherDetailsScreen({super.key, required this.partnerCoupon});

  @override
  State<VoucherDetailsScreen> createState() => _VoucherDetailsScreenState();
}

class _VoucherDetailsScreenState extends State<VoucherDetailsScreen> {
  GlobalKey previewContainer = GlobalKey();
  Circle circle = Circle();

  Future<void> downloadAndCaptureSS() async {
    circle.show(context);
    try {
      final RenderRepaintBoundary boundary = previewContainer.currentContext!
          .findRenderObject()! as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage(pixelRatio: 2);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      await ImageGallerySaver.saveImage(pngBytes);
      NetworkDio.showSuccess(
        title: AppConstString.success,
        context: context,
        sucessMessage: AppConstString.imageStored,
      );
    } catch (e) {
      NetworkDio.showError(
        title: AppConstString.error,
        context: context,
        errorMessage: e.toString(),
      );
    }
    circle.hide(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBackGroundWidget(
            padding: EdgeInsets.zero,
            child: bodyView(),
          ),
          Positioned(
            top: AppSizes.size40,
            left: AppSizes.size40,
            right: AppSizes.size20,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: AppColors.blackColor,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await downloadAndCaptureSS();
                    },
                    child: const Icon(
                      Icons.file_download_outlined,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bodyView() {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: SingleChildScrollView(
        child: RepaintBoundary(
          key: previewContainer,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(40)),
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    AppAssets.backgroundLayer,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 250,
                    alignment: Alignment.topLeft,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppSizes.size30),
                      ),
                      color: AppColors.whiteColor,
                      image: DecorationImage(
                        fit: widget.partnerCoupon.couponImg != null
                            ? BoxFit.cover
                            : null,
                        image: widget.partnerCoupon.couponImg != null
                            ? CachedNetworkImageProvider(
                                widget.partnerCoupon.couponImg ?? "",
                              )
                            : Image.asset(
                                AppAssets.bounzWordImg,
                              ).image,
                      ),
                    ),
                  ),
                  Container(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.only(left: AppSizes.size20),
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(AppSizes.size36),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.partnerCoupon.partnerName ?? "",
                          style: AppTextStyle.bold18
                              .copyWith(color: AppColors.whiteColor),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          widget.partnerCoupon.couponName ?? "",
                          style: AppTextStyle.semiBold16
                              .copyWith(color: AppColors.whiteColor),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        subTitleView(),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      AppConstString.couponCode,
                      style: AppTextStyle.regular18.copyWith(
                        fontFamily: "Bebas",
                        letterSpacing: .36,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size12,
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: BarcodeWidget(
                              barcode: Barcode.code128(),
                              drawText: false,
                              data: widget.partnerCoupon.couponCode ?? "",
                              style: AppTextStyle.bold20
                                  .copyWith(color: AppColors.btnBlueColor),
                            ),
                          ),
                        ),
                        Text(
                          widget.partnerCoupon.couponCode.toString(),
                          style: AppTextStyle.bold24.copyWith(
                            color: AppColors.blackColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppConstString.description,
                          style: AppTextStyle.bebasRegular18Space36,
                        ),
                        const SizedBox(
                          height: AppSizes.size12,
                        ),
                        Text(
                          widget.partnerCoupon.description.toString(),
                          style: AppTextStyle.regular14.copyWith(
                            fontSize: 13,
                            color: AppColors.whiteColor,
                            letterSpacing: .3,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          AppConstString.termsAndCondition,
                          style: AppTextStyle.bebasRegular18Space36,
                        ),
                        const SizedBox(
                          height: AppSizes.size12,
                        ),
                        Html(
                          data: widget.partnerCoupon.termsAndConditions ?? "",
                          style: {
                            "body": Style(
                              margin: Margins.zero,
                              padding: HtmlPaddings.zero,
                              color: AppColors.whiteColor,
                              fontSize: FontSize(13.0),
                              fontWeight: FontWeight.w400,
                              letterSpacing: .3,
                            )
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget subTitleView() {
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstString.voucherReceived,
              style: AppTextStyle.regular14.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              AppConstString.voucherExpiry,
              style: AppTextStyle.regular14.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '  :  ',
              style: AppTextStyle.regular14.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '  :  ',
              style: AppTextStyle.regular14.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.partnerCoupon.creationDate?.ymddateFormatWithoutDay ?? "",
              style: AppTextStyle.regular14.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.partnerCoupon.expiryDate?.ymddateFormatWithoutDay ?? "",
              style: AppTextStyle.regular14.copyWith(
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
