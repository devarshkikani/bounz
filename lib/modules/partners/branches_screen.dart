import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:bounz_revamp_app/widgets/maputil.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/models/partner/new_partner_detail_model.dart';

@RoutePage()
class BranchesScreen extends StatefulWidget {
  final List<AllBranch>? allBranches;
  final List<double>? distance;
  final String? branchName;
  final int selected;
  final Function(int index) onTap;

  const BranchesScreen({
    Key? key,
    required this.onTap,
    required this.selected,
    required this.allBranches,
    required this.distance,
    required this.branchName,
  }) : super(key: key);

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  MapUtils mapUtils = MapUtils();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColors.backgroundColor,
        child: AppBackGroundWidget(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.size20,
            vertical: AppSizes.size20,
          ),
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
                widget.branchName?.toUpperCase() ?? '',
                style: AppTextStyle.regular36.copyWith(fontFamily: "Bebas"),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: widget.allBranches?.length,
                  padding:
                      const EdgeInsets.symmetric(vertical: AppSizes.size10),
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (_, index) {
                    return InkWell(
                      onTap: () {
                        widget.onTap(index);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppSizes.size10),
                        margin: const EdgeInsets.only(bottom: AppSizes.size10),
                        decoration: BoxDecoration(
                          color: index == widget.selected
                              ? AppColors.scaffoldColor
                              : AppColors.primaryContainerColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.allBranches?[index].title ?? "",
                                    style: AppTextStyle.bold12.copyWith(
                                      letterSpacing: .6,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 4.0,
                                  ),
                                  SizedBox(
                                    child: Text(
                                      '${widget.allBranches?[index].address ?? ""} • ${widget.allBranches?[index].distance?.toStringAsFixed(2)} KM Away',
                                      style: AppTextStyle.regular10.copyWith(
                                        letterSpacing: .5,
                                      ),
                                      maxLines: 3,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: AppSizes.size4,
                            ),
                            InkWell(
                              onTap: () {
                                mapUtils.openMap(
                                    widget.allBranches![index].lat!,
                                    widget.allBranches![index].long!);
                              },
                              child: SvgPicture.asset(AppAssets.direction),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
