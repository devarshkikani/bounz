import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';

@RoutePage()
class PartnerPhotosScreen extends StatefulWidget {
  final String patnername;
  final String location;
  final List photos;
  const PartnerPhotosScreen(
      {required this.patnername,
      required this.location,
      required this.photos,
      Key? key})
      : super(key: key);

  @override
  State<PartnerPhotosScreen> createState() => _PartnerPhotosScreenState();
}

class _PartnerPhotosScreenState extends State<PartnerPhotosScreen>
    with TickerProviderStateMixin {
  bool sideContainerShow = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(seconds: 1),
        vsync: this,
        animationBehavior: AnimationBehavior.preserve);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.easeInToLinear);

    _controller.forward();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackGroundWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
            Padding(
              padding: const EdgeInsets.only(top: AppSizes.size20),
              child: FittedBox(
                child: Text(
                  widget.patnername.toUpperCase(),
                  style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.size6),
              child: Text(
                widget.location,
                style: AppTextStyle.regular24,
              ),
            ),
            const SizedBox(
              width: AppSizes.size20,
            ),
            Expanded(
              child: FadeTransition(
                opacity: _animation,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: widget.photos.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        MoenageManager.logScreenEvent(
                            name: 'Partners Image Preview');

                        AutoRouter.of(context).push(
                          PartnersImagePreviewRoute(
                              index: index, photos: widget.photos),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(widget.photos[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
