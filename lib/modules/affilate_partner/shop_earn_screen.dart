import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ShopAndEarnScreen extends StatefulWidget {
  final bool fromSplash;
  const ShopAndEarnScreen(
      {@PathParam('fromSplash') this.fromSplash = false, Key? key})
      : super(key: key);

  @override
  State<ShopAndEarnScreen> createState() => _ShopAndEarnScreenState();
}

class _ShopAndEarnScreenState extends State<ShopAndEarnScreen> {
  final CarouselController _controller = CarouselController();
  int _current = 0;

  final List<String> imgList = [
    AppAssets.carouselBanner,
    AppAssets.carouselBanner1,
    AppAssets.carouselBanner2,
  ];

  final List<String> imageList2 = [
    'https://i.pinimg.com/736x/15/aa/16/15aa1678d4ee5615c5c53ed5c9968126.jpg',
    'https://static.vecteezy.com/system/resources/previews/014/018/561/original/amazon-logo-on-transparent-background-free-vector.jpg',
    'https://i.pinimg.com/736x/15/aa/16/15aa1678d4ee5615c5c53ed5c9968126.jpg',
    'https://static.vecteezy.com/system/resources/previews/014/018/561/original/amazon-logo-on-transparent-background-free-vector.jpg',
  ];

  bool shouldReclip(CustomClipper<Path> oldClipper) => false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AppBackGroundWidget(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.fromSplash) {
                        MoenageManager.logScreenEvent(name: 'Main Home');
                        AutoRouter.of(context).pushAndPopUntil(
                            MainHomeScreenRoute(
                              isFirstLoad: true,
                            ),
                            predicate: (_) => false);
                      } else {
                        AutoRouter.of(context).canPop();
                      }
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      size: 20,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size30,
                  ),
                  Text(
                    AppConstString.shopAndEarn,
                    style: AppTextStyle.regular36.copyWith(
                      fontFamily: "Bebas",
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  topView(),
                ],
              ),
              const SizedBox(
                height: AppSizes.size10,
              ),
              Text(
                "Most Popular",
                textAlign: TextAlign.center,
                style: AppTextStyle.regular18.copyWith(
                  fontFamily: "Bebas",
                  letterSpacing: .36,
                ),
              ),
              const SizedBox(
                height: AppSizes.size10,
              ),
              SizedBox(
                height: 135,
                child: commonListView(itemCount: imageList2),
              ),
              const SizedBox(
                height: AppSizes.size10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.size20),
                child: Divider(
                  color: AppColors.whiteColor,
                ),
              ),
              const SizedBox(
                height: AppSizes.size10,
              ),
              Text(
                "New Partners",
                textAlign: TextAlign.center,
                style: AppTextStyle.regular18.copyWith(
                  fontFamily: "Bebas",
                  letterSpacing: .36,
                ),
              ),
              const SizedBox(
                height: AppSizes.size10,
              ),
              SizedBox(
                height: 135,
                child: commonListView(itemCount: imageList2),
              ),
              const SizedBox(
                height: AppSizes.size10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: AppSizes.size20),
                child: Divider(
                  color: AppColors.whiteColor,
                ),
              ),
              const SizedBox(
                height: AppSizes.size10,
              ),
              Text(
                "Trending Partners",
                textAlign: TextAlign.center,
                style: AppTextStyle.regular18.copyWith(
                  fontFamily: "Bebas",
                  letterSpacing: .36,
                ),
              ),
              const SizedBox(
                height: AppSizes.size10,
              ),
              SizedBox(
                height: 135,
                child: commonListView(itemCount: imageList2),
              ),
              const SizedBox(
                height: AppSizes.size10,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topView() {
    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: 135,
            enableInfiniteScroll: false,
            viewportFraction: 0.9,
            padEnds: false,
            onPageChanged: (index, reason) {
              setState(
                () {
                  _current = index;
                },
              );
            },
          ),
          items: imgList.map((item) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.only(right: AppSizes.size10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(item),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(
          height: AppSizes.size10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: _current == entry.key
                  ? Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 2.0,
                        horizontal: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.whiteColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        "${entry.key + 1}/${imgList.length}",
                        style: AppTextStyle.regular12.copyWith(
                          color: AppColors.blackColor,
                        ),
                      ),
                    )
                  : Container(
                      width: 6.0,
                      height: 6.0,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (AppColors.whiteColor).withOpacity(0.3),
                      ),
                    ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget commonListView({required List<String> itemCount}) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: itemCount.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(width: 12.0);
      },
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            MoenageManager.logScreenEvent(name: 'Shop Earn Details');

            AutoRouter.of(context).push(
              const ShopEarnDetailScreenRoute(),
            );
          },
          child: SizedBox(
            width: 120,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                itemCount[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
