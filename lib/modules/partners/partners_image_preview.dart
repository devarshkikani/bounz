import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
// ignore_for_file: must_be_immutable

@RoutePage()
class PartnersImagePreview extends StatefulWidget {
  int index;
  final List photos;
  PartnersImagePreview({Key? key, required this.index, required this.photos})
      : super(key: key);

  @override
  State<PartnersImagePreview> createState() => _PartnersImagePreviewState();
}

class _PartnersImagePreviewState extends State<PartnersImagePreview> {
  bool isImagePreviewOpen = false;
  late PageController _pageController;
  late ScrollController _listScrollController;

  void closeImagePreview() {
    isImagePreviewOpen = false;
    Navigator.of(context).pop();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _listScrollController = ScrollController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackColor.withOpacity(0.8),
      body: Stack(
        children: [
          Positioned(
            top: AppSizes.size20,
            left: AppSizes.size20,
            child: SafeArea(
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
          ),
          GestureDetector(
            onTap: closeImagePreview,
            child: Container(
              padding: const EdgeInsets.all(AppSizes.size20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const SizedBox(
                    height: AppSizes.size20,
                  ),
                  SizedBox(
                    height: 300.0,
                    child: PageView.builder(
                      itemCount: widget.photos.length,
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: AppColors.errorColor,
                            borderRadius: BorderRadius.circular(16.0),
                            image: DecorationImage(
                              image: NetworkImage(widget.photos[widget.index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                      controller: _pageController,
                      onPageChanged: (index) {
                        setState(() {
                          widget.index = index;
                        });
                      },
                    ),
                  ),
                  const SizedBox(
                    height: AppSizes.size10,
                  ),
                  SizedBox(
                    height: AppSizes.size60,
                    child: ListView.builder(
                      controller: _listScrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.photos.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              widget.index = index;
                            });
                          },
                          child: Container(
                            width: AppSizes.size50,
                            margin: const EdgeInsets.all(AppSizes.size10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                image: NetworkImage(widget.photos[index]),
                                fit: BoxFit.cover,
                              ),
                              border: Border.all(
                                color: widget.index == index
                                    ? AppColors.whiteColor
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                        );
                      },
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
}
