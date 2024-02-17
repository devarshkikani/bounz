import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppBackGroundWidget extends StatelessWidget {
  const AppBackGroundWidget({Key? key, required this.child, this.padding})
      : super(key: key);
  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Container(
        color: AppColors.backgroundColor,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
                left: AppSizes.size20, top: AppSizes.size20),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(40)),
              child: Container(
                padding: padding ??
                    const EdgeInsets.only(
                        left: AppSizes.size20,
                        right: AppSizes.size20,
                        top: AppSizes.size20),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      AppAssets.backgroundLayer,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
