import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';

@RoutePage()
class ShopEarnDetailScreen extends StatefulWidget {
  const ShopEarnDetailScreen({Key? key}) : super(key: key);

  @override
  State<ShopEarnDetailScreen> createState() => _ShopEarnDetailScreenState();
}

class _ShopEarnDetailScreenState extends State<ShopEarnDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        padding: EdgeInsets.zero,
        child: SingleChildScrollView(
          child: Column(
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
                child: Stack(
                  children: [
                    Image.network(
                      "https://img.freepik.com/free-photo/wide-angle-shot-single-tree-growing-clouded-sky-during-sunset-surrounded-by-grass_181624-22807.jpg",
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: AppSizes.size20, top: AppSizes.size20),
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
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 20,
                ),
                height: 120,
                decoration: const BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Available Offers",
                      style: AppTextStyle.bold18,
                    ),
                    const SizedBox(
                      height: AppSizes.size10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        left: AppSizes.size10,
                        top: AppSizes.size10,
                        bottom: AppSizes.size10,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.secondaryContainerColor,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              AppAssets.tagIcon,
                              height: AppSizes.size10,
                            ),
                          ),
                          const SizedBox(
                            width: AppSizes.size10,
                          ),
                          Text(
                            "Earn 10 BOUNZ per AED 10 spent",
                            style: AppTextStyle.semiBold14.copyWith(
                              color: AppColors.textFieldColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSizes.size30,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: AppSizes.size10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "How it works",
                      style: AppTextStyle.black14,
                    ),
                    const SizedBox(
                      height: AppSizes.size10,
                    ),
                    const IndividualDottedSteps(
                      step: "Step 1",
                      description:
                          'Please enter your BOUNZ number to get redirected to partner website/app, ensure you complete the transaction there without closing the window or visiting any other website.',
                      isDottedline: true,
                    ),
                    const IndividualDottedSteps(
                      step: "Step 2",
                      description:
                          'Please ensure that the cart is empty before you start shopping on the partner website.',
                      dottedLineHeight: 50.0,
                      isDottedline: true,
                    ),
                    const IndividualDottedSteps(
                      step: "Step 3",
                      description:
                          'Click Here to know the eligible categories for Intermiles earning for Amazon Sale.',
                      dottedLineHeight: 50.0,
                      isDottedline: true,
                    ),
                    const IndividualDottedSteps(
                      step: "Step 4",
                      description:
                          'InterMiles will be credited to your InterMiles account within 60 days',
                      dottedLineHeight: 50.0,
                      isDottedline: false,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: AppSizes.size10,
              ),
              Center(
                child: PrimaryButton(
                  onTap: () {},
                  text: "Go to Flipkart",
                  showShadow: true,
                  // width: 100.0,
                  height: 60.0,
                ),
              ),
              const SizedBox(
                height: AppSizes.size30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IndividualDottedSteps extends StatelessWidget {
  final String step;
  final String description;
  final double? dottedLineHeight;
  final bool isDottedline;

  const IndividualDottedSteps({
    Key? key,
    required this.step,
    required this.description,
    this.dottedLineHeight,
    required this.isDottedline,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 6.0,
              width: 10.0,
              decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(0),
              height: dottedLineHeight ?? 65.0,
              // width: 350,
              child: isDottedline == true
                  ? const MySeparator(color: AppColors.whiteColor)
                  : const SizedBox(),
            ),
          ],
        ),
        const SizedBox(width: 10.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontFamily: "Gilroy",
                fontSize: AppSizes.size12,
                color: AppColors.whiteColor,
              ),
            ),
            const SizedBox(
              height: 4.0,
            ),
            SizedBox(
              width: 350.0,
              child: Text(
                description,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: "Gilroy",
                  fontSize: 12,
                  color: AppColors.whiteColor.withOpacity(0.89),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}

class MySeparator extends StatelessWidget {
  const MySeparator(
      {Key? key, this.height = 1.5, this.color = AppColors.blackColor})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxHeight = constraints.constrainHeight();
        double dashWidth = height;
        double dashHeight = 10;
        final dashCount = (boxHeight / (1.1 * dashHeight)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.vertical,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
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
