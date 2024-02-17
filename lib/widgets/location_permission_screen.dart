import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';
import 'package:bounz_revamp_app/utils/get_user_location.dart';
import 'package:bounz_revamp_app/widgets/rounded_border_button.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:geolocator/geolocator.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/widgets/primary_button.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/global_singleton.dart';

@RoutePage()
class LocationPermissionScreen extends StatefulWidget {
  final Function()? afterSuccess;
  const LocationPermissionScreen({super.key, this.afterSuccess});

  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen>
    with WidgetsBindingObserver {
  String currentAddress = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    // if (state == AppLifecycleState.resumed) {
    //   processIndicator.show(context);
    //   final Future<String> isLocationGet =
    //       UserLocation().getCurrentPosition(widget.afterSuccess, context, 0);
    //   if (await isLocationGet == "SUCCESS") {
    //     if (widget.afterSuccess != null) {
    //       widget.afterSuccess!();
    //     }
    //     Navigator.of(context).pop();
    //     processIndicator.hide(context);
    //   } else {
    //     processIndicator.hide(context);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return GlobalSingleton.currentPosition != null;
      },
      child: Scaffold(
        body: AppBackGroundWidget(
          child: RefreshIndicator(
            onRefresh: () async {
              final String isLocationGet = await UserLocation()
                  .getCurrentPosition(widget.afterSuccess, context, 0);
              if (isLocationGet == "SUCCESS") {
                if (widget.afterSuccess != null) {
                  widget.afterSuccess!();
                }
                Navigator.of(context).pop();
              } else {}
            },
            child: ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: AppSizes.size30,
                ),
                Text(
                  'Add Your \nCurrent Location',
                  style: AppTextStyle.regular36.copyWith(fontFamily: 'Bebas'),
                ),
                const SizedBox(
                  height: AppSizes.size60,
                ),
                Center(
                  child: Text(
                    '''Location services permission is required to find outlets nearby.''',
                    style: AppTextStyle.regular16,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: AppSizes.size60,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.size30),
                    child: PrimaryButton(
                        text: 'Open Settings',
                        onTap: () async {
                          await Geolocator.openAppSettings();
                        },
                        tColor: AppColors.whiteColor,
                        bColor: AppColors.secondaryBackgroundColor),
                  ),
                ),
                const SizedBox(
                  height: AppSizes.size10,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: AppSizes.size30),
                    child: RoundedBorderButton(
                        text: 'Go Back',
                        onTap: () async {
                          MoenageManager.logScreenEvent(name: 'Main Home');
                          AutoRouter.of(context).pushAndPopUntil(
                              MainHomeScreenRoute(
                                isFirstLoad:
                                    GlobalSingleton.fromSplash == false,
                              ),
                              predicate: (_) => false);
                        },
                        tColor: AppColors.secondaryBackgroundColor,
                        bColor: AppColors.secondaryBackgroundColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
