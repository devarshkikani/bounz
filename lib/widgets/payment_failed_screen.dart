import 'package:bounz_revamp_app/config/manager/global_singleton.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bounz_revamp_app/constants/app_sizes.dart';
import 'package:bounz_revamp_app/config/theme/app_colors.dart';
import 'package:bounz_revamp_app/constants/app_const_text.dart';
import 'package:bounz_revamp_app/constants/app_const_assets.dart';
import 'package:bounz_revamp_app/config/theme/app_text_style.dart';
import 'package:bounz_revamp_app/widgets/app_backgound_widget.dart';
import 'package:bounz_revamp_app/config/manager/moenage_manager.dart';
import 'package:bounz_revamp_app/config/routes/router_import.gr.dart';

@RoutePage()
class PaymentFailedScreen extends StatefulWidget {
  final int? pageIndex;
  final String? reason;
  const PaymentFailedScreen({Key? key, this.pageIndex, this.reason})
      : super(key: key);

  @override
  State<PaymentFailedScreen> createState() => _PaymentFailedScreenState();
}

class _PaymentFailedScreenState extends State<PaymentFailedScreen> {
  @override
  void initState() {
    super.initState();
    GlobalSingleton.transactionList = null;
    Future.delayed(const Duration(seconds: 3), () {
      MoenageManager.logScreenEvent(name: 'Main Home');
      AutoRouter.of(context).pushAndPopUntil(
          MainHomeScreenRoute(index: widget.pageIndex),
          predicate: (_) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: AppBackGroundWidget(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: AppSizes.size30,
              ),
              Text(
                AppConstString.paymentFailed,
                style: AppTextStyle.bold36.copyWith(
                  fontFamily: 'Bebas',
                ),
              ),
              const SizedBox(
                height: AppSizes.size26,
              ),
              Lottie.asset(AppAssets.paymentFailed, height: 150.0),
              const SizedBox(
                height: AppSizes.size46,
              ),
              Text(
                widget.reason ?? AppConstString.paymentFailedDetails,
                textAlign: TextAlign.center,
                style: AppTextStyle.bold16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
